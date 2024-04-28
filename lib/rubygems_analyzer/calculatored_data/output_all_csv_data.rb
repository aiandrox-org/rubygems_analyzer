# frozen_string_literal: true

require 'csv'

require_relative 'get_ruby_gems_from_csv'

module RubygemsAnalyzer
  module CalculatoredData
    class OutputAllCsvData
      def self.call
        new.call
      end

      def call
        all_file_names = Dir.glob('lib/rubygems_analyzer/calculatored_data/*.csv')
        alphabets = all_file_names.map { _1.split('/').last.split('.').first }
        data = GetRubyGemsFromCsv.call(alphabets:)
        write_to_file(data)
      end

      def write_to_file(gems)
        CSV.open('lib/rubygems_analyzer/all_data.csv', 'a') do |csv|
          gems.each do |gem|
            csv_row = [
              gem.name,
              gem.average_version_leadtime,
              gem.version_count,
              gem.version,
              gem.downloads,
              gem.star_count,
              gem.source_url
            ]
            csv << csv_row
          end
        end
      end
    end
  end
end
