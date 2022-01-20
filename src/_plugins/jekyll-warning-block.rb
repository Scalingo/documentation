module Jekyll
  class WarningBlock < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      # Gather settings
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)

      source = super
      content = converter.convert(source.strip).gsub(/<\/?p[^>]*>/, "").chomp
      "<aside class=\"warning\">#{content}</aside>"
    end
  end
end

Liquid::Template.register_tag("warning", Jekyll::WarningBlock)
