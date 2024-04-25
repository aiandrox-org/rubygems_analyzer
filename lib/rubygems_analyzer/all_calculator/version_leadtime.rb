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
          newer_created_at = Time.parse(newer['created_at'])
          older_created_at = Time.parse(older['created_at'])
          leadtime = newer_created_at - older_created_at

          # NOTE: 秒数で出力する
          puts "version_number: #{newer['number']}, leadtime: #{leadtime}"
        end
      end
      # versionsを取得して、数を数える
      # 2未満なら、nilを返す
      # 2以上なら、最新バージョンとその1つ前のバージョンのcreated_atの差分を求める
    end
  end
end
