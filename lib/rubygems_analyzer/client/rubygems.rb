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

      # 先頭が最新バージョン
      def versions
        Gems.versions(gem_name)
      end

      def version_count
        versions.count.size
      end

      def source_code_uri
        gem['source_code_uri']
      end

      # バージョンのcreated_atの差分を求められる
      def leadtime_between_versions; end

      private

      def gem
        @gem ||= Gems.info(gem_name)
      end
    end
  end
end
