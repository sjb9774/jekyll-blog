module Jekyll
  class RenderAsideBlock < Liquid::Block
    def render(context)
      text = super
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      output = converter.convert(super(context))
      "<div class=\"aside\">#{output}</div>"
    end

  end
end

Liquid::Template.register_tag('aside', Jekyll::RenderAsideBlock)