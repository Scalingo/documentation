# Jekyll ExtLinks plugin
#
# Add rel="external nofollow" and target="blank" to all external links (not relative link).
# Remove nofollow to all domains present in config 'followed_domains'
#
# Inspired from http://ogarkov.com/jekyll/plugins/extlinks/

require 'uri'
require 'nokogiri'

module Jekyll
  module ExtLinks
    # Access plugin config in _config.yml
    def config
      @context.registers[:site].config['extlinks']
    end

    # Checks if str contains any fragment of the fragments array
    def contains_any(str, fragments)
      return false unless Regexp.union(fragments) =~ str
      true
    end

    def extlinks(content)
      # Process configured link attributes and whitelisted hosts
      followed_domains = []
      if config
        if config['followed_domains']
          followed_domains = config['followed_domains']
        end
      end

      doc = Nokogiri::HTML.fragment(content)
      # Stop if we could't parse with HTML
      return content unless doc

      doc.css('a').each do |a|
        # If this is a local link don't change it
        href = a.get_attribute('href')
        uri = URI(href)

        next if uri.scheme !~ /\Ahttp/i

        # If there's a rel already don't change it
        next unless !a.get_attribute('rel') || a.get_attribute('rel').empty?

        if followed_domains.include?(uri.host)
          a.set_attribute("rel", "external")
        else
          a.set_attribute("rel", "nofollow external")
        end
        a.set_attribute("target", "_blank")
      end

      doc.to_s
    end

  end
end
Liquid::Template.register_filter(Jekyll::ExtLinks)
