# frozen_string_literal: true

require 'csv'

require_relative 'gems_page'
require_relative '../client/rubygems'

module RubygemsAnalyzer
  module AllCalculator
    class AddFirstPublishedToCsv
      def self.call(alphabets: ('A'..'Z').to_a)
        new(alphabets).call
      end

      def initialize(alphabets)
        @alphabets = alphabets.map(&:upcase)
      end

      def call
        @alphabets.each do |letter|
          AddFirstPublishedPerLetter.call(letter)
        end
      end
    end

    class AddFirstPublishedPerLetter
      def self.call(letter)
        new(letter).call
      end

      def initialize(letter)
        @letter = letter
      end

      def call
        table = CSV.table("lib/rubygems_analyzer/calculatored_data/#{letter}.csv", headers: false)
        file_path = "lib/rubygems_analyzer/new_calculatored_data/#{letter}.csv"
        table.each do |row|
          client = Client::Rubygems.new(row[0])
          row.push(client.versions.last['created_at'])
          puts row
          File.open(file_path, 'a') { |f| f.puts(row.to_csv) }
        end
      end

      private

      attr_accessor :client, :letter
    end
  end
end

RubygemsAnalyzer::AllCalculator::AddFirstPublishedToCsv.call
