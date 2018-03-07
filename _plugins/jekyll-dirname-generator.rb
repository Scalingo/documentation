module Dirname
  class Generator < Jekyll::Generator
    FORWARD_SLASH = "/".freeze

    def directory_hash(path, name=nil)
      url_path = path.gsub("_posts", "")
      matchedPage = @all_posts.detect{|x|
        x.url == url_path
      }
      data = {
        'title' => matchedPage && (matchedPage.data['nav'] || matchedPage.data['title']) ? (matchedPage.data['nav'] || matchedPage.data['title']) : path.split('/').compact.last.split("-").map(&:capitalize).join(" "),
        'type'  => 'dir',
        'url'   => matchedPage ? matchedPage.url : path.gsub('_posts', ''),
        'index' => matchedPage && matchedPage.data['index'] ? matchedPage.data['index'] : nil
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
            'title' => matchedPage ? (matchedPage.data['nav'] || matchedPage.data['title']) : nil,
            'type'  => "file",
            'url'   => matchedPage ? matchedPage.url : "UNMATCHED PAGE",
            'index' => matchedPage && matchedPage.data['index'] ? matchedPage.data['index'] : nil
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
      # Create index if not existent
      max_index = children.length + 1
      children = children.map{|x|
        x["index"] ||= max_index
        x
      }
      # Sort by index
      children = children.sort_by{|x|
        x['index']
      }
      data['children'] = children
      return data
    end

    def generate(site)
      site.posts.docs.each{|doc|
        path = doc.path
        dirname = if path.end_with?(FORWARD_SLASH)
          path
        else
          path_dir = File.dirname(path)
          path_dir.end_with?(FORWARD_SLASH) ? path_dir : "#{path_dir}/"
        end
        doc.data['dirname'] = dirname
        categories = dirname.gsub(Dir.pwd + "/_posts/", "").split("/").delete_if{|x| x.blank?}
        doc.data['category'] = nil
        doc.data['categories'] = categories
        doc.data['permalink'] = nil
      }

      @all_posts = site.posts.docs
      tree = directory_hash('_posts/')
      site.data['tree'] = tree['children']
    end
  end
end
