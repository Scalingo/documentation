module Jekyll
  class BreadcrumbTag < Liquid::Tag
    def initialize(tag_name, text, tokens)
      super
    end

    def render(context)
      breadcrumb_hash = Jekyll.sites.first.data["breadcrumb_hash"]
      current_url = context['page']['url']
      # Remove first and last element
      # First is blank and last is the current page
      url_parts = current_url.split("/")[1..-2]

      result = []
      new_path = ""

      url_parts.map do |part|
        new_path += "/#{part}"
        title = breadcrumb_hash[new_path]

        "<a href=\"#{new_path}\">#{title}</a>"
      end.join(" - ")
    end
  end
end

Liquid::Template.register_tag("breadcrumb", Jekyll::BreadcrumbTag)
