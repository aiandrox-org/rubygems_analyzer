# frozen_string_literal: true

module RubygemsAnalyzer
  class RubyGem
    def initialize(name:, downloads:)
      @name = name
      @downloads = downloads
    end

    attr_reader :name, :downloads
  end
end
