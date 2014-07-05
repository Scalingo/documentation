module Middleman
  module Blog
    class BlogData
      def by_category(category)
        articles.select{|a| a.data["category"] == category}
      end

      def by_top_category(category)
        articles.select{|a| !a.data["subcategory"] and a.data["category"] == category}
      end
    end
  end
end
