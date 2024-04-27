# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'logger'

module RubygemsAnalyzer
  module Client
    class Nokogiri
      def initialize
        @logger = Logger.new($stdout)
      end

      def get(url)
        page_uri = URI.parse(url).open
        doc = ::Nokogiri::HTML.parse(page_uri)
        @logger.info("get: #{url}")
        doc
      rescue Net::OpenTimeout
        sleep 3
        retry
      end
    end
  end
end
