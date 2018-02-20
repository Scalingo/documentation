require 'webpacker'
require 'active_support/all'
# require "active_support/core_ext/module/attribute_accessors"

ENV['NODE_ENV'] ||= ENV['JEKYLL_ENV']
ENV['RAILS_ENV'] ||= ENV['JEKYLL_ENV']

# Fake a few Rails stuff to be able to use the webpacker gem
class Rails
  def self.root
    Pathname.new(Dir.pwd)
  end

  def self.env
    ENV['RAILS_ENV']
  end
end

module Jekyll
  module AssetPackFilter
    def asset_pack_path(input)
      Webpacker::Configuration.module_eval do
        def public_path
          Rails.root
        end
      end
      Webpacker.manifest.lookup!(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetPackFilter)
