require 'rack/jekyll'
require 'rack/rewrite'
require 'rack/ssl-enforcer'
require 'rack/canonical_host'
require 'yaml'

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end

use Rack::Rewrite do
  rewrite    '/rss', '/feed.xml'
  rewrite    %r{(^.+).html}, "$1/index.html", if: Proc.new {|env|
    env["REQUEST_PATH"].start_with?("/post")
  }
  rewrite    %r{(^.+)}, "$1.html", if: Proc.new {|env|
    env["REQUEST_PATH"].start_with?("/tagged")
  }
  rewrite    %r{/\d{4}(/.+)+/([^\./]+)$}, '$1/$2.html'
end

if ENV['FORCE_SSL'].present?
  use Rack::SslEnforcer
end

if ENV['CANONICAL_HOST_URL'].present?
  use Rack::CanonicalHost, URI(ENV["CANONICAL_HOST_URL"]).host
elsif ENV['CANONICAL_HOST'].present?
  use Rack::CanonicalHost, ENV["CANONICAL_HOST"]
end

run Rack::Jekyll.new
