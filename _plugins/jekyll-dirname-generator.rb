module Dirname
  class Generator < Jekyll::Generator
    FORWARD_SLASH = "/".freeze

    def directory_hash(path, name=nil)
      matchedPage = @all_posts.detect{|x| x.path.ends_with?(path) }
      data = {
        'title' => matchedPage ? (matchedPage.data['nav'] || matchedPage.title) : path.split('/').compact.last.capitalize,
        'type'  => 'dir',
        'url'   => matchedPage ? matchedPage.url : path.gsub('_posts/', '')
      }
      data['children'] = children = []
      Dir.foreach(path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          children << directory_hash(full_path, entry)
        else
          matchedPage = @all_posts.detect{|x|
            x.path.ends_with?(full_path)
          }
          children << {
            'title' => matchedPage ? (matchedPage.data['nav'] || matchedPage.title) : nil,
            'type'  => "file",
            'url'   => matchedPage ? matchedPage.url : "UNMATCHED PAGE"
          }
        end
      end
      return data
    end

    def generate(site)
      site.posts.docs.each{|post|
        path = post.path
        dirname = if path.end_with?(FORWARD_SLASH)
          path
        else
          path_dir = File.dirname(path)
          path_dir.end_with?(FORWARD_SLASH) ? path_dir : "#{path_dir}/"
        end
        post.data['dirname'] = dirname
        categories = dirname.gsub(Dir.pwd + "/_posts/", "").split("/").delete_if{|x| x.blank?}
        post.data['category'] = nil
        post.data['categories'] = categories
        post.data['permalink'] = nil
      }

      @all_posts = site.posts.docs
      tree = directory_hash('_posts/')
      site.data['tree'] = tree['children']
    end
  end
end
