module Jekyll
  class CategoryPage < Page
    def initialize(site, base, dir, name, title)
      @site = site
      @base = base
      @dir = dir

      @name = "#{name}.html"

      process(@name)
      read_yaml(File.join(base, "_layouts"), "dir.html")
      data["title"] = title
    end
  end
end

module Dirname
  class Generator < Jekyll::Generator
    def directory_hash(path)
      url_path = path.gsub("src/_posts", "")
      page_for_dir = @all_posts.detect { |x|
        x.url == url_path
      }
      data = {
        "title" => page_for_dir && (page_for_dir.data["nav"] || page_for_dir.data["title"]) ? (page_for_dir.data["nav"] || page_for_dir.data["title"]) : path.split("/").compact.last.split("-").map(&:capitalize).join(" "),
        "type" => "dir",
        "url" => page_for_dir&.url || url_path,
        "index" => page_for_dir&.data&.dig("index"),
      }
      @breadcrumb_hash[data["url"]] = data["title"]
      data["children"] = children = []
      Dir.foreach(path) do |entry|
        next if entry == ".." || entry == "."
        full_path = File.join(path, entry)
        if File.directory?(full_path)
          children << directory_hash(full_path)
        else
          matched_page = @all_posts.detect { |x|
            x.path.ends_with?(full_path)
          }
          child = {
            "title" => matched_page ? (matched_page.data["nav"] || matched_page.data["title"]) : nil,
            "type" => "file",
            "url" => matched_page ? matched_page.url : "UNMATCHED PAGE",
            "index" => matched_page && matched_page.data["index"] ? matched_page.data["index"] : nil,
          }
          children << child
          @breadcrumb_hash[child["url"]] = child["title"]
        end
      end
      children = data["children"]

      if url_path != "/"
        if page_for_dir
          page_for_dir.data["layout"] = "dir"
          page_for_dir.data["slug"] = url_path
          page_for_dir.data["links"] = data["children"].each_with_object([]) do |obj, memo|
            memo << {"url" => obj["url"], "title" => obj["title"]}
            @breadcrumb_hash[obj["url"]] = obj["title"]
          end
        else
          relative_dir = File.dirname path.gsub("_posts/", "")
          name = File.basename(path)
          title = data["title"]
          new_page = Jekyll::CategoryPage.new(@site, @site.source, relative_dir, name, title)
          new_page.data["links"] = data["children"].each_with_object([]) do |obj, memo|
            memo << {"url" => obj["url"], "title" => obj["title"]}
            @breadcrumb_hash[obj["url"]] = obj["title"]
          end
          @site.pages << new_page
        end
      end

      # In case of multiple entries with the same title, keep the one which is
      # a dir. Assuming the other ones is a "fake" file whose only purpose is to
      # customize index or title attributes of the dir entry
      children = children.group_by { |x| x["title"] }.each_with_object([]) { |x, memo|
        ary = x.last
        if ary.length == 1
          memo << ary.first
        else
          memo << ary.detect { |x| x["type"] == "dir" } || ary.first
        end
      }
      # Create index if not existing
      max_index = children.length + 1
      children = children.map { |x|
        x["index"] ||= max_index
        x
      }
      # Sort by index
      children = children.sort_by { |x|
        x["index"]
      }
      data["children"] = children
      return data
    end

    def generate(site)
      site.posts.docs.each do |doc|
        path = doc.path
        # only build custom variables for the top level _posts dir
        # aka the "regular doc"
        if doc.relative_path.start_with?("_posts")
          path_dir = File.dirname(path)
          dirname = path_dir.end_with?("/") ? path_dir : "#{path_dir}/"
          doc.data["dirname"] = dirname

          categories = dirname.gsub(Dir.pwd + "/src/_posts/", "").split("/").delete_if { |x| x.blank? }
          doc.data["categories"] = categories
          doc.data["category"] = nil
          doc.data["permalink"] = nil
        end
      end

      @site = site
      @all_posts = site.posts.docs
      @breadcrumb_hash = {}
      tree = directory_hash("src/_posts/")
      site.data["tree"] = tree["children"]
      site.data["breadcrumb_hash"] = @breadcrumb_hash
    end
  end
end
