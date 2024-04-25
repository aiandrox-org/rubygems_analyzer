# frozen_string_literal: true

require_relative 'gems_page'
require_relative 'client/nokogiri'

module RubygemsAnalyzer
  class GetRubyGems
    RUBYGEMS_URL = 'https://rubygems.org/gems'

    def self.call
      new.call
    end

    def initialize
      @client = Client::Nokogiri.new
      @current_letter = 'A'
      @current_page = 1
      @gems = []
    end

    def call
      loop do
        doc = client.get(url)
        gem_page = GemsPage.new(doc)
        gems << gem_page.gems

        if gem_page.next_page?
          self.current_page = current_page + 1
        elsif current_letter == 'Z'
          # Zの最後のページまで取得したら終了
          break
        else
          self.current_letter = current_letter.next
          self.current_page = 1
        end
        sleep 1
      end
      gems
    end

    private

    attr_accessor :client, :current_letter, :current_page, :gems

    def url
      "#{RUBYGEMS_URL}?letter=#{current_letter}&page=#{current_page}"
    end
  end
end
