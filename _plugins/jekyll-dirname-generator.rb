module Dirname
  class Generator < Jekyll::Generator
    FORWARD_SLASH = "/".freeze

    def directory_hash(path, name=nil)
      url_path = path.gsub("_posts", "")
      page_for_dir = @all_posts.detect{|x|
        x.url == url_path
      }
      data = {
        'title' => page_for_dir && (page_for_dir.data['nav'] || page_for_dir.data['title']) ? (page_for_dir.data['nav'] || page_for_dir.data['title']) : path.split('/').compact.last.split("-").map(&:capitalize).join(" "),
        'type'  => 'dir',
        'url'   => page_for_dir ? page_for_dir.url : path.gsub('_posts', ''),
        'index' => page_for_dir && page_for_dir.data['index'] ? page_for_dir.data['index'] : nil
      }
      data['children'] = children = []
      Dir.foreach(path) do |entry|
        next if (entry == '..' || entry == '.')
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          children << directory_hash(full_path, entry)
        else
          matched_page = @all_posts.detect{|x|
            x.path.ends_with?(full_path)
          }
          children << {
            'title' => matched_page ? (matched_page.data['nav'] || matched_page.data['title']) : nil,
            'type'  => "file",
            'url'   => matched_page ? matched_page.url : "UNMATCHED PAGE",
            'index' => matched_page && matched_page.data['index'] ? matched_page.data['index'] : nil
          }
        end
      end
      children = data['children']

      if url_path != "/"
        if page_for_dir
          page_for_dir.data['layout'] = 'dir'
          # require "pry"
          # binding.pry
          page_for_dir.data['slug'] = url_path
          page_for_dir.data['links'] = data['children'].inject([]){|memo,obj|
            memo << {"url" => obj['url'], "title" => obj['title']}
            memo
          }
        else
          # relative_dir = File.dirname(path)
          # new_file_name = "2000-01-01-#{ File.basename(path) }.md"
          # new_page = Jekyll::Page.new(@site, Dir.pwd, relative_dir, new_file_name)
          # new_page.data['layout'] = 'dir'
          # @site.posts.docs << new_page
          # @site.pages << new_page
        end
      end

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

      @site = site
      @all_posts = site.posts.docs
      tree = directory_hash('_posts/')
      site.data['tree'] = tree['children']
    end
  end
end
