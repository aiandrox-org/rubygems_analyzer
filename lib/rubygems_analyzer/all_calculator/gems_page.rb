# frozen_string_literal: true

require_relative '../client/rubygems'
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
          source_url:,
          average_version_leadtime: average_version_leadtime(gem_name: name, client: rubygems_client),
          version:,
          downloads: downloads_count
        }
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
  end
end
