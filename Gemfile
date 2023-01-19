source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby "3.1.3"

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
gem "jekyll"
gem "webrick"
gem "liquid-c"
gem "liquid", "4.0.3"
gem "jekyll-sass-converter", "< 3.0"
# This is the default theme for new Jekyll sites. You may change this to anything you like.
# gem 'minima', '~> 2.0'

# If you want to use GitHub Pages, remove the 'gem 'jekyll'' above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem 'github-pages', group: :jekyll_plugins

# If you have any plugins, put them here!
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-sitemap"
  gem "jekyll-toc"
end

group :development, :test do
  gem "pry-nav"
  gem "pry-rails"

  ## Linting
  gem "rubocop"
  gem "standard"
end

gem "webpacker", "< 5"

gem "puma"
gem "rack", "< 3"
gem "rack-canonical-host"
gem "rack-jekyll", github: "adaoraul/rack-jekyll"
gem "rack-rewrite"
gem "rack-ssl-enforcer"
gem "rack-cors"
gem "psych", "< 4"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
