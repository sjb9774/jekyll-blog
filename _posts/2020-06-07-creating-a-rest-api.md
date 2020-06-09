---
layout: post
title:  "Creating your own REST API"
date:   2020-06-07 5:00:00 -0600
tags: api rest python flask
categories: getting-started
---

APIs have become increasingly popular ways to interact with third-party software
and platforms in recent years. They are sensible ways of providing great amounts
of information and functionality to external programs without having to worry
about tightly coupling the program to the platform the API is exposing.

Modern software practices have seemingly settled on JSON-based REST APIs for
API development. Here's a quick rundown of what each of these acronyms stands
for in case you're unfamiliar:
* JSON
  * **J**ava**S**cript **O**bject **N**otation
  * JSON is a standard for representing loosely structured primitive, map,
    and array/list data
  * Looks a little like this `{"my_field": "the value", "field2": 100}`
* REST
  * **R**epresentational **S**tate **T**ransfer
  * This is a fancy way of describing the properties of well-designed web APIs
  * You can review the details [on Wikipedia][rest-wiki]
* API
  * **A**pplication **P**rogramming **I**nterface
  * Literally refers to an interface exposed by applications to program against
  * This can also be used to describe libraries that expose specific methods for
  interacting with another application, not only web services

With this understanding, let's walk through a quick guide for setting up our own
REST API as base for larger programs.

For rapid prototyping, I always use Python and my favorite web framework for
Python is Flask. To get started let's do a couple things, firstly installing the
Python package manager `pip` if you haven't already. Check out the official
documentation for more info: [installing pip][pip-install].

Now that we have `pip` installed, let's set up a virtual environment where we
can install our Python dependencies without worrying about other projects on the
computer or that might be created later (for example, if you had another project
that required an older version of Flask, using global environment would cause
issues when we go to install the newest version for this guide).
{% highlight bash %}
cd ~/path/to/my/desired/project/directory
pip install virtualenv
virtualenv .venv -p python3 # installs a new python install in the .venv directory
. .venv/bin/activate # run the "activate" executable to start using this python install

pip install flask
{% endhighlight %}

Now with our environment setup and Flask installed, let's create two new files:
`api.py` and `runserver.py`. `api.py` will be responsible for creating our API
endpoints while `runserver.py` will simply prep the Flask development server and
run it so we can test. Within `runserver.py` add the following:
{% highlight python %}
# runserver.py
from flask import Flask

app = Flask(__name__)
app.run(debug=True)
{% endhighlight %}

It's that simple to start up a local web server with Flask. If you run this
python file with `python runserver.py` you'll see output like the following:
{% highlight bash %}
$ python runserver.py
 * Serving Flask app "runserver" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: on
 * Running on http://127.0.0.1:5000/ (Press CTRL+C to quit)
 * Restarting with stat
 * Debugger is active!
 * Debugger PIN: 111-111-111
{% endhighlight %}

At this point if you navigate to [http://127.0.0.1:5000][localhost] you'll get a 404 error
since we haven't set up anything in Flask to handle the homepage (and we won't,
since this is an API) but that will at least confirm Flask is running correctly.

Now, as a point of good practice and to avoid some confusing `import` problems
later, let's move the definition of `app` into its own file. Create `app.py`:
{% highlight python %}
# app.py
from flask import Flask

app = Flask(__name__)
{% endhighlight %}

And now let's update the `runserver.py` file to use that definition:
{% highlight python %}
# runserver.py
from app import app

if __name__ == "__main__":
    app.run(debug=True)
{% endhighlight %}

As covered earlier, REST APIs return JSON responses to requests for data. Let's
go ahead and add a simple API endpoint for Flask to handle for us. Add the
following in `api.py`:
{% highlight python %}
# api.py
from flask import jsonify
from app import app


@app.route('/api/data', methods=["GET"])
def api_endpoint():
    my_data = {
        "data": [0,1,2,3],
        "data2": "abcd"
    }
    return jsonify(my_data)
{% endhighlight %}

As you can probably tell in this example, this data is static and purely for
testing purposes, but it does demonstrate just how simple it is to set up an
endpoint in Flask. Naturally, in a real application the logic for getting the
data would likely come from database and be formatted within this method for
easy consumption by the integrating program. Don't worry too much about the
`jsonify` function, it's similar to the Python `json.dumps` method but also sets
the correct HTTP headers that should be sent with a JSON response.

{% aside %}
It's okay if you're not familiar
with the `@app.route` line of code above the signature for `api_endpoint`.
This is a shorthand for a Python decorator; suffice to say that this is how
Flask registers our function to handle the endpoint we defined.
{% endaside %}

Now, before our `runserver.py` script can serve up this new endpoint, it has to
be made aware of it so the decorator can be run and work its magic on our Flask
`app` object. We make this happen by importing the endpoint into the
`runserver.py` file before the `app.run()` method is called by simply adding the
following line after our other import:
{% highlight python %}
from api import api_endpoint
{% endhighlight %}

At this point you can go ahead and navigate to http://127.0.0.1:5000/api/data
and you'll see the data defined in that method returned to your browser. More
appropriately for an API (as APIs aren't generally accessed through a browser),
you can send a request via `curl` like so:
{% highlight bash %}
$ curl http://127.0.0.1:5000/api/data -X GET
{
  "data": [
    0,
    1,
    2,
    3
  ],
  "data2": "abcd"
}
{% endhighlight %}

Or, of course, if you'd like to be able to access the API through Python we can
use the popular `requests` module like so:
{% highlight bash %}
$ pip install requests
$ python
Python 3.7.5 (default, Nov  1 2019, 02:16:32)
[Clang 11.0.0 (clang-1100.0.33.8)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import requests
>>> r = requests.get('http://127.0.0.1:5000/api/data')
>>> r.json()
{'data': [0, 1, 2, 3], 'data2': 'abcd'}
>>>
{% endhighlight %}

Now before we wrap up let's take this one step further and make use of some path
and query parameters. Here's my updated `api.py` function that demonstrates
these features:
{% highlight python %}
# api.py
from flask import jsonify, request
from app import app

@app.route('/api/data/<data_key>', methods=["GET"])
def api_endpoint(data_key):
    my_data = {
        "data": [0,1,2,3],
        "data2": "abcd"
    }
    name = request.args.get('name')
    result = {
        "response": my_data.get(data_key, {}),
        "requester": name
    }
    return jsonify(result)
{% endhighlight %}

There's a number of things to pay attention to here:
* I've imported `request` from Flask. This object gives us access to a lot of
information pertaining to the "current" request at the time of execution.
  * In this set of changes I use the `request` object to get query parameters
  via the `request.args.get` method where I'm expecting a `"name"` argument.
* The `app.route` path argument had `<data_key>` added to it. This is a path
argument placeholder, the value of which will be passed directly to the function.
* The data returned by this method is no longer static but rather depends on the
arguments passed via the request path and the query parameters.

Here's an example request against this updated method via `curl`:
{% highlight bash %}
$ curl http://127.0.0.1:5000/api/data/data?name=Stephen
{
  "requester": "Stephen",
  "response": [
    0,
    1,
    2,
    3
  ]
}
{% endhighlight %}

Or again using `requests` in `Python`:
{% highlight Python %}
>>> r = requests.get('http://127.0.0.1:5000/api/data/data', params={'name': 'Stephen'})
>>> r.json()
{'requester': 'Stephen', 'response': [0, 1, 2, 3]}
{% endhighlight %}

That's pretty much it for getting started. As you can see, the proof-of-concept
is quite simple. There's a lot more that goes into creating a fully fleshed-out
API but hopefully this guide gives you a good place to start building out your
own web services!


[rest-wiki]: https://en.wikipedia.org/wiki/Representational_state_transfer#Architectural_constraints
[pip-install]: https://pip.pypa.io/en/stable/installing/
[localhost]: http://127.0.0.1:5000
