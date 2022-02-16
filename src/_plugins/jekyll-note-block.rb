module Jekyll
  class NoteBlock < Liquid::Block
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
      "<aside class=\"note\">#{icon}<div>#{content}</div></aside>"
    end

    def icon
      <<~SVG
        <svg class="mt-1" width="18" height="18" viewBox="0 0 18 18" fill="none" xmlns="http://www.w3.org/2000/svg">
          <g clip-path="url(#clip0_4076_10748)">
            <path
              d="M3.67205 17.4954C3.60005 17.4954 3.52805 17.4594 3.45605 17.4234C3.34805 17.3514 3.27605 17.1714 3.31205 17.0274L4.89605 11.1234L0.144045 7.27138C4.50257e-05 7.19938 -0.035955 7.01938 4.50201e-05 6.87538C0.036045 6.73138 0.180045 6.62337 0.324045 6.62337L6.44405 6.29938L8.64005 0.575375C8.71205 0.467375 8.85605 0.359375 9.00005 0.359375C9.14405 0.359375 9.28805 0.467375 9.32405 0.575375L11.52 6.29938L17.64 6.62337C17.784 6.62337 17.928 6.73138 17.964 6.87538C18 7.01938 17.964 7.16338 17.856 7.27138L13.104 11.1234L14.688 17.0274C14.724 17.1714 14.688 17.3154 14.544 17.4234C14.436 17.4954 14.256 17.5314 14.148 17.4234L9.00005 14.1114L3.85205 17.4234C3.78005 17.4954 3.74405 17.4954 3.67205 17.4954Z"
              fill="#8055FF" />
          </g>
          <defs>
            <clipPath id="clip0_4076_10748">
              <rect width="18" height="18" fill="white" />
            </clipPath>
          </defs>
        </svg>
      SVG
    end
  end
end

Liquid::Template.register_tag("note", Jekyll::NoteBlock)
