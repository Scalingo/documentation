Time.zone = "Europe/Paris"

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  ignore ".*.swp"
end

# HACK HAML 4
Haml::Filters.remove_filter('Markdown')
Haml::Filters.register_tilt_filter('Markdown', template_class: Tilt::RedcarpetTemplate::Redcarpet2)
# END HACK

require "lib/middleman/blog/blog_data.rb"

set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir,  'assets/fonts'

activate :syntax
set :haml, { :ugly => true, :format => :html5 }
set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true

page "/sitemap.xml", :layout => false
activate :directory_indexes
activate :blog do |blog|
  blog.sources = "{category}/{title}.html"
  blog.permalink = "{category}/{title}.html"
end

# Build-specific configuration
configure :build do
  activate :minify_css
  activate :minify_javascript
  # Enable cache buster
  # activate :asset_hash
end

activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method = :git
end
