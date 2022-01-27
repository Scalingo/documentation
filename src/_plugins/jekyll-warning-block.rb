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
      "<aside class=\"warning\">#{icon}<div>#{content}</div></aside>"
    end

    def icon
      <<~SVG
        <svg width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path
            d="M8.99995 1.79688C8.50101 1.79688 8.07359 2.10091 7.89253 2.53398L1.38042 13.7652V13.7664C1.26289 13.9557 1.2004 14.174 1.19995 14.3969C1.19995 14.7151 1.32638 15.0204 1.55142 15.2454C1.77647 15.4704 2.08169 15.5969 2.39995 15.5969C2.42811 15.5967 2.45625 15.5955 2.48433 15.5934L2.48667 15.5969H8.99995H15.5132L15.5156 15.5922C15.5436 15.5947 15.5718 15.5963 15.5999 15.5969C15.9182 15.5969 16.2234 15.4704 16.4485 15.2454C16.6735 15.0204 16.7999 14.7151 16.7999 14.3969C16.7997 14.1736 16.7372 13.9549 16.6195 13.7652L16.6101 13.7488C16.6097 13.7484 16.6093 13.748 16.6089 13.7477L10.1074 2.53398C9.92631 2.10091 9.49889 1.79688 8.99995 1.79688ZM8.27221 6.8125H9.72768L9.60698 10.6961H8.39292L8.27221 6.8125ZM9.00229 11.8832C9.49549 11.8832 9.79096 12.1486 9.79096 12.6016C9.79096 13.0462 9.49549 13.3105 9.00229 13.3105C8.50549 13.3105 8.20776 13.0462 8.20776 12.6016C8.20776 12.1486 8.50489 11.8832 9.00229 11.8832Z"
            fill="#E54732" />
        </svg>
      SVG
    end
  end
end

Liquid::Template.register_tag("warning", Jekyll::WarningBlock)
