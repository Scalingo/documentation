Time.zone = "Europe/Paris"

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
  ignore ".*.swp"
end

class Tilt::RedcarpetTemplate::Redcarpet2
  def initialize(file, line, options)
    options = { :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :smartypants => true }
    super(file, line, options)
  end
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
set :markdown, :tables => true, :autolink => true, :gh_blockcode => true, :fenced_code_blocks => true, :smartypants => true, with_toc_data: true

require 'nokogiri'

helpers do
  def body_for(resource)
    resource.render(layout: nil)
  end

  def doc_for(resource)
    html = body_for(resource)
    Nokogiri::HTML::DocumentFragment.parse(html)
  end

  def toc_link(heading)
    heading_id = heading[:id] || "TBD"
    content_tag(:a, heading.text, href: "#" + heading_id)
  end

  def toc_item(heading)
    content_tag(:li, toc_link(heading))
  end

  def heading_nodes(resource)
    doc_for(resource).css('h2')
  end

  def table_of_contents(resource)
    list = heading_nodes(resource).map do |heading|
      toc_item(heading)
    end.join

    content_tag("div", content_tag("strong", "Page") + content_tag(:ul, list), class: "well toc")
  end
end

page "/sitemap.xml", :layout => false
activate :directory_indexes

activate :blog do |blog|
  require "lib/middleman/blog/blog_article.rb"
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
