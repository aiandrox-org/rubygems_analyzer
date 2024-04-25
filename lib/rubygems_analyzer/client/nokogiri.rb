# frozen_string_literal: true

module RubygemsAnalyzer
  module Client
    class Nokogiri
      RUBYGEMS_URL = 'https://rubygems.org/gems'.freeze

      class << self
        def call
          html = parse_to_html
          html.css('body > main > div[class="l-wrap--b"] > a[class="gems__gem"]').map do |con|
            con.css('span > h2').text.split.first
          end
        end

        def parse_to_html
          Nokogiri::HTML.parse(fetch_page_content)
        end

        def fetch_page_content
          URI.open(RUBYGEMS_URL)
        end
      end
    end
    # TODO: スター数、ファイル数、コード行数はGitHubから取得してくる必要がある
  end
end
