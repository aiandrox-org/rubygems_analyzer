# frozen_string_literal: true

require_relative 'rubygems_analyzer/version'
require_relative 'rubygems_analyzer/command'

module RubygemsAnalyzer
  class Error < StandardError; end

  class RubygemsClient
    attr_reader :gem_name

    def initialize(gem_name)
      @gem_name = gem_name.to_s
    end

    def total_downloads_count
      gem['downloads']
    end

    # 先頭が最新バージョン
    def versions
      Gem.versions(gem_name)
    end

    def source_code_uri
      gem['source_code_uri']
    end

    # バージョンのcreated_atの差分を求められる
    def leadtime_between_versions
    end

    private

    def gem
      @gem ||= Gems.info(gem_name)
    end
  end

  class FetchAllGemNames
    RUBYGEMS_URL = 'https://rubygems.org/gems'

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
