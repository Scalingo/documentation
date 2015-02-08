module Middleman
  module Blog
    module BlogArticle
      # Render this resource to a string with the appropriate layout.
      # Called automatically by Middleman.
      # @return [String]
      def render(opts={}, locs={}, &block)
        if !opts.has_key?(:layout)
          opts[:layout] = metadata[:options][:layout]
          opts[:layout] = blog_options.layout if opts[:layout].nil?
          # Convert to a string unless it's a boolean
          opts[:layout] = opts[:layout].to_s if opts[:layout].is_a? Symbol
        end

        content = super(opts, locs, &block)

        unless opts[:keep_separator]
          content.sub!(blog_options.summary_separator, "")
        end

        content
      end
    end
  end
end
