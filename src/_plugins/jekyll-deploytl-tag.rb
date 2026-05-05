module Jekyll
  class DeployTimelineTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
      @steps = parse_steps(markup)
    end

    def render(context)
      first_ok = @steps.min

      html = "<ol class=\"deploy-timeline\">\n"
      html << %Q{<li#{class_attr(1, first_ok)}><span>building</span> Source fetched</li>\n}
      html << %Q{<li#{class_attr(2, first_ok)}><span>building</span> Technology detected</li>\n}
      html << %Q{<li#{class_attr(3, first_ok)}><span>building</span> Application image built</li>\n}
      html << %Q{<li#{class_attr(4, first_ok)}><span>starting</span> Container started</li>\n}
      html << %Q{<li#{class_attr(5, first_ok)}><span>starting</span> Postdeploy hook run</li>\n}
      html << %Q{<li#{class_attr(6, first_ok)}><span>running&nbsp;</span> Application running</li>\n}
      html << "</ol>"

      html
    end

    private

    def class_attr(step, first_ok)
      if @steps.include?(step)
        ' class="cur"'
      elsif first_ok && step < first_ok
        ' class="ok"'
      else
        ''
      end
    end

    def parse_steps(markup)
      match = markup.match(/steps="([^"]+)"/)
      return [] unless match

      value = match[1]

      if value.include?("-")
        start_s, end_s = value.split("-").map(&:to_i)
        (start_s..end_s).to_a
      else
        [value.to_i]
      end
    end
  end
end


Liquid::Template.register_tag("deploytl", Jekyll::DeployTimelineTag)
