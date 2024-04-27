# frozen_string_literal: true

require_relative '../client/rubygems'
require_relative '../client/github'
require_relative 'version_leadtime'

module RubygemsAnalyzer
  class GemsPage
    def initialize(doc)
      @doc = doc
    end

    def gems
      doc.css('body > main > div.l-wrap--b > a.gems__gem').map do |con|
        name = con.at_css('span > h2').text.split.first
        version = con.at_css('.gems__gem__version').children.text
        downloads = con.at_css('.gems__gem__downloads__count').children.text.split.first
        downloads_count = downloads.gsub(/(\d{0,3}),(\d{3})/, '\1\2').to_i
        rubygems_client = Client::Rubygems.new(name)
        source_url = rubygems_client.source_code_uri || rubygems_client.homepage_uri

        {
          name:,
          average_version_leadtime: average_version_leadtime(gem_name: name, client: rubygems_client),
          version_count: rubygems_client.version_count,
          version:,
          downloads: downloads_count,
          star_count: get_star_count(source_url),
          source_url:
        }
      rescue StandardError
        puts name
        raise
      end
    end

    def next_page?
      !!doc.at_css('a:contains("Next")')
    end

    private

    attr_reader :doc

    def average_version_leadtime(gem_name:, client:)
      leadtimes = AllCalculator::VersionLeadtime.call(gem_name:, client:)
      return 0 if leadtimes.nil?

      leadtimes.sum / leadtimes.size
    end

    def get_star_count(source_url)
      repo_name = extract_repository_name_from(source_url)
      repo_name.empty? ? 0 : github_client.get_star(repo_name:)
    end

    # NOTE: owner/repo_nameの形式で返す
    def extract_repository_name_from(source_url)
      return '' if source_url.nil?

      if source_url.start_with?('https://github.com') || source_url.start_with?('http://github.com')
      if source_url.start_with?('https://github.com/') || source_url.start_with?('http://github.com/')
        URI.parse(source_url).path.split('/')[1..2].join('/')
      else
        ''
      end
    end

    def github_client
      @github_client ||= Client::Github.new
    end
  end
end
