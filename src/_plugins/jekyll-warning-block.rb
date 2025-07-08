module Jekyll
  class WarningBlock < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      source = super

      output = <<~MARKDOWN
      <aside class="warning" markdown="block">
      #{source}
      </aside>
      MARKDOWN

      output
    end
  end
end

Liquid::Template.register_tag("warning", Jekyll::WarningBlock)
