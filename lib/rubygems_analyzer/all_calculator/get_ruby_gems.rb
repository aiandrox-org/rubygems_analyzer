# frozen_string_literal: true

require_relative 'gems_page'
require_relative '../client/nokogiri'

module RubygemsAnalyzer
  module AllCalculator
    class GetRubyGems
      def self.call(alphabets: ('A'..'Z').to_a)
        new(alphabets).call
      end

      def initialize(alphabets)
        @alphabets = alphabets
      end

      def call
        @alphabets.each do |letter|
          gems = GetRubyGemsPerLetter.call(letter)
          # CSVに出力する処理を書く
        end
      end
    end

    class GetRubyGemsPerLetter
      RUBYGEMS_URL = 'https://rubygems.org/gems'

      def self.call(letter)
        new(letter).call
      end

      def initialize(letter)
        @client = Client::Nokogiri.new
        @letter = letter
        @current_page = 1
        @gems = []
      end

      def call
        loop do
          doc = client.get(url)
          gem_page = GemsPage.new(doc)
          gems << gem_page.gems

          break unless gem_page.next_page?

          self.current_page = current_page + 1

          sleep 1
        end
        gems
      end

      private

      attr_accessor :client, :letter, :current_page, :gems

      def url
        "#{RUBYGEMS_URL}?letter=#{letter}&page=#{current_page}"
      end
    end
  end
end
