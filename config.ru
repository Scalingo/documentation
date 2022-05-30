require "rack/jekyll"
require "rack/rewrite"
require "rack/ssl-enforcer"
require "rack/canonical_host"
require "rack/cors"
require "yaml"

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end

use Rack::Rewrite do
  r301 %r{.*}, "https://#{ENV["CANONICAL_HOST"]}/samples$&", if: proc { |rack_env|
    ["samples.scalingo.com"].include?(rack_env["SERVER_NAME"])
  }
  r301 "/samples/", "/samples"

  r301 %r{.*}, "https://#{ENV["CANONICAL_HOST"]}/changelog$&", if: proc { |rack_env|
    ["changelog.scalingo.com"].include?(rack_env["SERVER_NAME"])
  }
  r301 "/changelog/", "/changelog"

  r301 %r{.*}, "https://#{ENV["CANONICAL_HOST"]}/platform/cli/start", if: proc { |rack_env|
    ["cli.scalingo.com"].include?(rack_env["SERVER_NAME"])
  }

  r301(/\/internals\/(.*)-buildpack/, "/platform/deployment/buildpacks/$1")

  r301(/\/addons\/scalingo-postgresql(.*)/, "/databases/postgresql$1")
  r301(/\/addons\/scalingo-mysql(.*)/, "/databases/mysql$1")
  r301(/\/addons\/scalingo-mongodb(.*)/, "/databases/mongodb$1")
  r301(/\/addons\/scalingo-elasticsearch(.*)/, "/databases/elasticsearch$1")
  r301(/\/addons\/scalingo-influxdb(.*)/, "/databases/influxdb$1")

  redirections = YAML.load_file("redirections.yml")
  redirections["301"].each { |redir|
    r301 redir["old"], redir["new"]
  }
  redirections["obsolete"].each { |redir|
    r301 redir, "/"
  }

  r301 %r{^(.+).html$}, "$1"
  rewrite %r{^([^?]+)(\??)(.*)}, "$1.html$2$3", if: proc { |rack_env|
    rack_env["PATH_INFO"].present? && rack_env["PATH_INFO"] != "/" && rack_env["PATH_INFO"] !~ /\.(jpg|jpeg|png|gif|ico|eot|otf|ttf|woff|woff2|css|js|xml|txt)$/i
  }
end

use Rack::Cors do
  if ENV["ALLOWED_CHANGELOG_FEED_CONSUMERS"].present?
    allowed_origins = ENV["ALLOWED_CHANGELOG_FEED_CONSUMERS"].split(",")

    allow do
      origins(*allowed_origins)
      resource "/changelog/feed.xml", headers: :any, methods: :get
    end
  end
end

if ENV["FORCE_SSL"].present?
  use Rack::SslEnforcer
end

if ENV["CANONICAL_HOST"].present? && ENV["CANONICAL_HOST_DISABLED"].blank?
  canonical_hosts_ignore = ENV["CANONICAL_HOSTS_IGNORE"].present? ? ENV["CANONICAL_HOSTS_IGNORE"].split(",").map(&:strip) : []
  use Rack::CanonicalHost, ENV["CANONICAL_HOST"], ignore: canonical_hosts_ignore
end

if ENV["BASIC_AUTH_ENABLED"]
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    ENV["BASIC_AUTH"].split(":") == [username, password]
  end
end

use Rack::CommonLogger

run Rack::Jekyll.new
