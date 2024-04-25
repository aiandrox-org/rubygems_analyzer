# frozen_string_literal: true

require_relative 'rubygems_analyzer/client/rubygems'

module RubygemsAnalyzer
  module AllCalculator
    class VersionLeadtime
      attr_reader :gem_name

      def self.call(gem_name:)
        new(gem_name).call
      end

      def initialize(gem_name)
        @gem_name = gem_name
      end

      def call
        client = Client::Rubygems.new(gem_name)
        versions = client.versions
        return nil if versions.size < 2

        # NOTE: バージョンの順番が必ずしも作成日時の順番と一致しないため、作成日時でソートする
        sorted_versions = versions.sort_by!{|version| version['created_at']}.reverse!
        sorted_versions.each_cons(2) do |(newer, older)|
          leadtime = calculate_version_leadtime(newer, older)

          puts "version_number: #{newer['number']}, leadtime: #{leadtime}sec"
        end
      end

      private

      def calculate_version_leadtime(newer, older)
        newer_created_at = Time.parse(newer['created_at'])
        older_created_at = Time.parse(older['created_at'])
        newer_created_at - older_created_at
      end
    end
  end
end
