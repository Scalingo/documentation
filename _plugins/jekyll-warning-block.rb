module Jekyll
  class WarningBlock < Liquid::Block

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      contents = super
      content = Liquid::Template.parse(contents).render context
      "<aside class=\"warning\">#{content}</aside>"
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::WarningBlock)
