# frozen_string_literal: true

require 'rubygems'
require 'gems'

module RubygemsAnalyzer
  class RubygemsClient
    attr_reader :gem_name

    def initialize(gem_name)
      @gem_name = gem_name.to_s
    end

    def total_downloads_count
      gem['downloads']
    end

    # 先頭が最新バージョン
    def versions
      Gem.versions(gem_name)
    end

    def source_code_uri
      gem['source_code_uri']
    end

    # バージョンのcreated_atの差分を求められる
    def leadtime_between_versions
    end

    private

    def gem
      @gem ||= Gems.info(gem_name)
    end
  end

  # TODO: スター数、ファイル数、コード行数はGitHubから取得してくる必要がある
end
