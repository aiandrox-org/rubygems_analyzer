# frozen_string_literal: true

module RubygemsAnalyzer
  class RubyGem
    def initialize(name:, average_version_leadtime:, version_count:, version:, downloads:, star_count:, source_url:,
                   published_at:)
      @name = name
      @average_version_leadtime = average_version_leadtime
      @version_count = version_count
      @version = version
      @downloads = downloads.to_i
      @star_count = star_count
      @source_url = source_url
      @published_at = published_at
    end

    attr_reader :name, :average_version_leadtime, :version_count, :version, :downloads, :star_count, :source_url,
                :published_at
  end
end
