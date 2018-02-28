require "pry"

module Dirname
  class Generator < Jekyll::Generator
    FORWARD_SLASH = "/".freeze

    def directory_hash(path, name=nil)
      url_path = path.gsub("_posts", "")
      matchedPage = @all_posts.detect{|x|
        x.url == url_path
      }
      data = {
        'title' => matchedPage ? (matchedPage.data['nav'] || matchedPage.title) : path.split('/').compact.last.capitalize,
        'type'  => 'dir',
        'url'   => matchedPage ? matchedPage.url : path.gsub('_posts', ''),
        'index' => matchedPage && matchedPage.data['index'] && matchedPage.data['index']
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
            'url'   => matchedPage ? matchedPage.url : "UNMATCHED PAGE",
            'index' => matchedPage && matchedPage.data['index'] && matchedPage.data['index']
          }
        end
      end
      children = data['children']
      # In case of multiple entries with the same title, keep the one which is
      # a dir. Assuming the other ones is a "fake" file whose only purpose is to
      # customize index or title attributes of the dir entry
      children = children.group_by{|x| x['title']}.inject([]){|memo, x|
        ary = x.last
        if ary.length == 1
          memo << ary.first
        else
          memo << ary.detect{|x| x['type'] == "dir"} || ary.first
        end
        memo
      }
      # Sort by index
      children = children.sort_by!{|a,b|
        index_a = a && a['index']
        index_b = b && b['index']
        index_a && index_b ? index_a <=> index_b : index_a ? -1 : 1
      }
      data['children'] = children
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
