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
  r301     %r{^(.+).html$}, '$1'
  rewrite   %r{^(.+)$}, '$1.html'
end

if ENV['FORCE_SSL'].present?
  use Rack::SslEnforcer
end

if ENV['CANONICAL_HOST_URL'].present?
  use Rack::CanonicalHost, URI(ENV["CANONICAL_HOST_URL"]).host
elsif ENV['CANONICAL_HOST'].present?
  use Rack::CanonicalHost, ENV["CANONICAL_HOST"]
end

use Rack::CommonLogger

run Rack::Jekyll.new
