module Jekyll
  class PNDomainTag < Liquid::Tag
    def initialize(tag_name, domain_name, tokens)
      super
      @text = domain_name.strip
    end

    def render(context)
      parts = @text.split('.').reverse
      html_parts = []

      i = 0
      while parts.length > 0 do
        p = parts[0]

        html = "<span"

        if i == 0
          # We want to keep "private-network.internal." in one piece
          # So we have to override p here, and shift one more item:
          html = html + " class=\"domain-name-nid\""
          p = parts[1] + "." + parts[0] + "."
          parts.shift
        elsif i == 1
          html = html + " class=\"domain-name-pn\""
        elsif i == 2
          html = html + " class=\"domain-name-ap\""
        elsif i == 3
          html = html + " class=\"domain-name-ct\""
        end

        html = html + ">#{p}</span>"
        html_parts.append(html)

        i = i+1
        parts.shift
      end

      "<code>" + html_parts.reverse.join(".") + "</code>"
    end
  end
end

Liquid::Template.register_tag("pndn", Jekyll::PNDomainTag)
