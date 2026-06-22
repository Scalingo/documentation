module Jekyll
  class StackTag < Liquid::Tag
    CLASSES = {
      "26" => "supported",
      "24" => "supported",
      "22" => "deprecated",
      "20" => "discontinued",
      "18" => "discontinued",
      "14" => "discontinued"
    }.freeze

    def initialize(tag_name, markup, tokens)
      super
      @stack = markup.strip
    end

    def render(context)
      css_class = CLASSES.fetch(@stack, "unknown")

      %(<span class="stack #{css_class}" title="Current status: #{css_class.capitalize}">scalingo-#{@stack}</span>)
    end
  end
end

Liquid::Template.register_tag("scalingo", Jekyll::StackTag)
