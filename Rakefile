require 'open-uri'
require 'nokogiri'

HOMEPAGE_URL = ENV['HOMEPAGE_URL'] || "https://scalingo.com/"

namespace :fetch_from_homepage do
  task :all do
    Rake::Task["fetch_from_homepage:header"].execute
    Rake::Task["fetch_from_homepage:footer"].execute
  end

  task :header do
    doc = Nokogiri::HTML(open(HOMEPAGE_URL))
    toolbar = doc.css("header.mdc-toolbar").to_xhtml
    sidebar = doc.css("aside").to_xhtml
    template_path = "_includes/header.html"
    File.open(template_path, 'w+') { |file|
      file.write(toolbar)
      file.write(sidebar)
    }
  end
  task :footer do
    doc = Nokogiri::HTML(open(HOMEPAGE_URL))
    footer = doc.css("footer").to_xhtml
    template_path = "_includes/footer.html"
    File.open(template_path, 'w+') { |file|
      file.write(footer)
    }
  end
end
