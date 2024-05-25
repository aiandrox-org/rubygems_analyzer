# frozen_string_literal: true

require 'csv'

require_relative '../ruby_gem'

module RubygemsAnalyzer
  module CalculatoredData
    class GetRubyGemsFromCsv
      def self.call(alphabets: ('A'..'Z').to_a)
        new(alphabets).call
      end

      def initialize(alphabets)
        @alphabets = alphabets.map(&:upcase)
      end

      def call
        @alphabets.map do |letter|
          CSV.read("lib/rubygems_analyzer/new_calculatored_data/#{letter}.csv").map do |row|
            RubyGem.new(
              name: row[0],
              average_version_leadtime: row[1],
              version_count: row[2],
              version: row[3],
              downloads: row[4],
              star_count: row[5],
              source_url: row[6],
              published_at: row[7]
            )
          end
        end.flatten
      end
    end
  end
end
