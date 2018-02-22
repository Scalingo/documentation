module Jekyll
  class NoteBlock < Liquid::Block

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      contents = super
      content = Liquid::Template.parse(contents).render context
      "<aside class=\"note\">#{content}</aside>"
    end
  end
end

Liquid::Template.register_tag('note', Jekyll::NoteBlock)
