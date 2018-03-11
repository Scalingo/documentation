module Jekyll
  class ConditionaltrackersBlock < Liquid::Block

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      source = super
      if ENV['JEKYLL_ENV'] != 'development' && ENV['DISABLE_TRACKERS'].blank?
        source
      else
        ""
      end
    end
  end
end

Liquid::Template.register_tag('conditionaltrackers', Jekyll::ConditionaltrackersBlock)
