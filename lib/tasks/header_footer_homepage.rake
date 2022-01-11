require "open-uri"
require "nokogiri"

namespace :fetch_from_homepage do
  task all: [:drawer, :header, :footer]

  task :drawer do
    doc = fetch_homepage

    drawer = doc.css("aside.mdc-drawer")
    scrim = doc.css(".mdc-drawer-scrim")
    drawer = add_drawer_subnav(drawer)

    template_path = "_includes/drawer.html"
    File.open(template_path, "w+") { |file|
      file.write(drawer.to_xhtml)
      file.write(scrim.to_xhtml)
    }
  end

  task :header do
    doc = fetch_homepage

    toolbar = doc.css("header.scalingo-toolbar--custom")
    toolbar.css(".locale-chooser").remove

    template_path = "_includes/header.html"
    File.open(template_path, "w+") { |file|
      file.write(toolbar.to_xhtml)
      file.write(subnav)
    }
  end

  task :footer do
    doc = fetch_homepage
    footer = doc.css("footer").to_xhtml
    template_path = "_includes/footer.html"
    File.open(template_path, "w+") { |file|
      file.write(footer)
    }
  end

  # rubocop:disable Security/Open
  def fetch_homepage
    @homepage_content ||= begin
      uri = URI.parse(HOMEPAGE_URL)
      str = if uri.user || uri.password
        uri2 = uri.clone
        uri2.user = nil
        uri2.password = nil
        open(uri.to_s, http_basic_authentication: [uri.user, uri.password])
      else
        open(uri)
      end
      Nokogiri::HTML(str) do |config|
        config.strict.noblanks
      end
    end
  end
  # rubocop:enable Security/Open

  def add_drawer_subnav doc
    doc.css(".mdc-drawer nav > .mdc-list-item:nth-child(6)").after(drawer_subnav)
    doc
  end

  def subnav
    <<~HEREDOC
      <div class="mdc-top-app-bar mdc-top-app-bar--fixed mdc-top-app-bar--fixed-scrolled scalingo-toolbar--custom">
        <div class="mdc-top-app-bar__row">
          <div class="container subrow">
            <span class="mdc-top-app-bar__title">
              Resources for Developers
            </span>
          </div>
        </div>
        <div class="mdc-top-app-bar__row">
          <div class="container">
            <div class="d-flex justify-content-start">
              <nav class="mdc-tab-bar d-none d-md-flex">
                <div class="mdc-tab-scroller">
                  <div class="mdc-tab-scroller__scroll-area">
                    <div class="mdc-tab-scroller__scroll-content">

                      <a href="/" class="mdc-tab" role="tab" aria-selected="false">
                        <span class="mdc-tab__content">
                          <span class="mdc-tab__text-label">Guides</span>
                        </span>
                        <span class="mdc-tab-indicator">
                          <span class="mdc-tab-indicator__content mdc-tab-indicator__content--underline"></span>
                        </span>
                        <span class="mdc-tab__ripple"></span>
                      </a>

                      <a href="/samples" class="mdc-tab" role="tab" aria-selected="false">
                        <span class="mdc-tab__content">
                          <span class="mdc-tab__text-label">Samples</span>
                        </span>
                        <span class="mdc-tab-indicator">
                          <span class="mdc-tab-indicator__content mdc-tab-indicator__content--underline"></span>
                        </span>
                        <span class="mdc-tab__ripple"></span>
                      </a>

                      <a href="/cli" class="mdc-tab" role="tab" aria-selected="false">
                        <span class="mdc-tab__content">
                          <span class="mdc-tab__text-label">CLI</span>
                        </span>
                        <span class="mdc-tab-indicator">
                          <span class="mdc-tab-indicator__content mdc-tab-indicator__content--underline"></span>
                        </span>
                        <span class="mdc-tab__ripple"></span>
                      </a>

                      <a href="/changelog" class="mdc-tab" role="tab" aria-selected="false">
                        <span class="mdc-tab__content">
                          <span class="mdc-tab__text-label">Changelog</span>
                        </span>
                        <span class="mdc-tab-indicator">
                          <span class="mdc-tab-indicator__content mdc-tab-indicator__content--underline"></span>
                        </span>
                        <span class="mdc-tab__ripple"></span>
                      </a>

                      <a href="https://developers.scalingo.com" target="_blank" class="mdc-tab" role="tab" aria-selected="false">
                        <span class="mdc-tab__content">
                          <span class="mdc-tab__text-label">
                            API Reference
                            <i class="material-icons">open_in_new</i>
                          </span>
                        </span>
                        <span class="mdc-tab-indicator">
                          <span class="mdc-tab-indicator__content mdc-tab-indicator__content--underline"></span>
                        </span>
                        <span class="mdc-tab__ripple"></span>
                      </a>

                    </div>
                  </div>
                </div>
              </nav>
              <div class="search mdc-text-field mdc-text-field--with-leading-icon mdc-text-field--no-label">
                <i class="material-icons mdc-text-field__icon" tabindex="0">search</i>
                <input type="text" id="search-input" placeholder="Search" class="mdc-text-field__input">
              </div>
            </div>
          </div>
        </div>
      </div>
    HEREDOC
  end

  def drawer_subnav
    <<~HEREDOC
      <div class="mdc-list">
        <a href="/" data-index="0" class="mdc-list-item">
          Guides
        </a>
        <a href="/samples" data-index="1" class="mdc-list-item">
        Samples
        </a>
        <a href="/cli" data-index="2" class="mdc-list-item">
        CLI
        </a>
        <a href="/changelog" data-index="3" class="mdc-list-item">
        Changelog
        </a>
        <a href="https://developers.scalingo.com" target="_blank" data-index="4" class="mdc-list-item">
        API Reference
        <i class="material-icons">open_in_new</i>
        </a>
      </div>
    HEREDOC
  end

  # Don't know why but the default SVG button make the page scroll automatically
  # This hack is here to circumvent this problem by replacing the SVG by the same
  # glyph coming from the material design font icon
  def hack doc
    doc.css("button svg").first.replace('<i class="material-icons">menu</i>')
    doc
  end

  def add_scrim(txt)
    txt << '<div class="mdc-drawer-scrim"></div>'
  end
end
