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
  r301 /\/internals\/(.*)-buildpack/, "/platform/deployment/buildpacks/$1"

  redirections = YAML.load_file('redirections.yml')
  redirections['301'].each{|redir|
    r301 redir["old"], redir["new"]
  }
  redirections['obsolete'].each{|redir|
    r301 redir, "/"
  }

  r301    %r{^(.+).html$}, '$1'
  rewrite %r{^(.+)$}, '$1.html', if: Proc.new {|rack_env|
    rack_env['PATH_INFO'].present? && rack_env['PATH_INFO'] != '/' && rack_env['PATH_INFO'] !~ /\.(jpg|jpeg|png|gif|ico|eot|otf|ttf|woff|woff2|css|js|xml|txt)$/i
  }
end

if ENV['FORCE_SSL'].present?
  use Rack::SslEnforcer
end

if ENV['CANONICAL_HOST'].present? && ENV['CANONICAL_HOST_DISABLED'].blank?
  canonical_hosts_ignore = ENV['CANONICAL_HOSTS_IGNORE'].present? ? ENV['CANONICAL_HOSTS_IGNORE'].split(",").map(&:strip) : []
  use Rack::CanonicalHost, ENV['CANONICAL_HOST'], ignore: canonical_hosts_ignore
end

use Rack::CommonLogger

run Rack::Jekyll.new
