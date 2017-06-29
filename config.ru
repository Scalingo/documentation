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

run Rack::Jekyll.new
