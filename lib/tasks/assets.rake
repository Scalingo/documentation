require "yaml"
require "webpacker"
require "active_support/all"

ENV["NODE_ENV"] ||= ENV["JEKYLL_ENV"]
ENV["RAILS_ENV"] ||= ENV["JEKYLL_ENV"]

# Fake a few Rails stuff to be able to use the webpacker gem
class Rails
  def self.root
    Pathname.new(Dir.pwd)
  end

  def self.env
    ENV["RAILS_ENV"]
  end
end

Webpacker::Compiler.module_eval do
  def webpack_env
    env.merge("NODE_ENV" => @webpacker.env, "WEBPACKER_ASSET_HOST" => "")
  end
end

HOMEPAGE_URL = ENV["HOMEPAGE_URL"] || "https://scalingo.com/"

namespace :assets do
  desc "assets precompilation"
  task :precompile do
    Rake::Task["webpacker:compile"].execute
    system("yarn build:css", exception: true)
    system("jekyll build", exception: true)
  end
end

$stdout.sync = true

def ensure_log_goes_to_stdout
  old_logger = Webpacker.logger
  Webpacker.logger = ActiveSupport::Logger.new($stdout)
  yield
ensure
  Webpacker.logger = old_logger
end

namespace :webpacker do
  desc "Compile JavaScript packs using webpack for production with digests"
  task :compile do
    ensure_log_goes_to_stdout do
      if Webpacker.compile
        # Successful compilation!
      else
        # Failed compilation
        exit!
      end
    end
  end
end
