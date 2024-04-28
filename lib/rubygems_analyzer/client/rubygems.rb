# frozen_string_literal: true

require 'rubygems'
require 'gems'

module RubygemsAnalyzer
  module Client
    class Rubygems
      attr_reader :gem_name

      def initialize(gem_name)
        @gem_name = gem_name.to_s
      end

      def total_downloads_count
        gem['downloads']
      end

      def versions
        # NOTE: バージョンの順番が必ずしも作成日時の順番と一致しないため、作成日時でソートする
        Gems.versions(gem_name).sort_by { |version| version['created_at'] }.reverse
      rescue Net::OpenTimeout
        sleep 3
        retry
      end

      def version_count
        versions.size
      end

      def source_code_uri
        gem['source_code_uri']
      end

      def homepage_uri
        gem['homepage_uri']
      end

      private

      def gem
        @gem ||= Gems.info(gem_name)
      rescue Net::OpenTimeout
        sleep 3
        retry
      end
    end
  end
end
