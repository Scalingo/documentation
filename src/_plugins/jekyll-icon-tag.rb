# Shortcut to include SVG icons from /_includes/icons
# Usage:
#   {% icon hi-five %}
#   {% icon {{ page.my_variable }} %}
module Jekyll
  class IconTag < Tags::IncludeTag
    def initialize(tag_name, icon_name, tokens)
      super
      @icon_name = icon_name.strip
    end

    def render(context)
      @file = "icons/#{render_icon_name(context)}.svg"
      super
    end

    def render_icon_name(context)
      if VARIABLE_SYNTAX.match?(@icon_name)
        Liquid::Template.parse(@icon_name).render(context)
      else
        @icon_name
      end
    end
  end
end

Liquid::Template.register_tag("icon", Jekyll::IconTag)
