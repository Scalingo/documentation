module Jekyll
  class NoteBlock < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      source = super.strip

      # Allows to have all sort of Markdown in the note:
      output = <<~MARKDOWN
      <aside class="note" markdown="block">
        #{source}
      </aside>
      MARKDOWN

      output
    end
  end
end

Liquid::Template.register_tag("note", Jekyll::NoteBlock)
