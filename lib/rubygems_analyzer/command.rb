# frozen_string_literal: true

require_relative 'ruby_gem'
require_relative 'client/rubygems'
require_relative 'client/github'
require_relative 'calculatored_data/get_ruby_gems_from_csv'
require_relative 'all_calculator/version_leadtime'

module RubygemsAnalyzer
  module AllCalculator
    class Command
      def self.run(gem_name)
        new(gem_name).run
      end

      def initialize(gem_name)
        @gem_name = gem_name

        @ruby_gems = RubygemsAnalyzer::CalculatoredData::GetRubyGemsFromCsv.call(alphabets: ('A'..'Z').to_a)
      end

      def run
        return puts 'No such gem' unless target_gem

        @ruby_gems.delete_if { _1.name == target_gem.name }
        @ruby_gems.push(target_gem)
        ordered_data = @ruby_gems.sort_by(&:downloads).reverse
        target_gem_index = ordered_data.find_index(target_gem)

        data_group_close_to_target = ordered_data[target_gem_index - 5..target_gem_index + 5]

        max_name_length = data_group_close_to_target.map { _1.name.length }.max
        scale_factor = data_group_close_to_target.map(&:downloads).max / 50 # is the max length of the graph

        data_group_close_to_target.each do |gem|
          graph_length = gem.downloads / scale_factor
          color = gem.name == gem_name ? "\e[33m" : "\e[34m"
          graph_bar = "#{color}#{'■' * graph_length}\e[0m"
          puts "#{gem.name.ljust(max_name_length)} ┤#{graph_bar} #{gem.downloads}"
        end
      end

      private

      attr_reader :gem_name

      def target_gem
        return @target_gem if defined?(@target_gem)

        rubygems_client = Client::Rubygems.new(gem_name)
        github_client = Client::Github.new
        leadtimes = AllCalculator::VersionLeadtime.call(gem_name:, client: rubygems_client)
        source_url = rubygems_client.source_code_uri || rubygems_client.homepage_uri
        repo_name = extract_repository_name_from(source_url)
        @target_gem = RubyGem.new(
          name: gem_name,
          downloads: rubygems_client.total_downloads_count,
          source_url:,
          version: rubygems_client.versions.last,
          version_count: rubygems_client.version_count,
          average_version_leadtime: leadtimes.empty? ? 0 : leadtimes.sum / leadtimes.size,
          star_count: repo_name.empty? ? 0 : github_client.get_star(repo_name:)
        )
      rescue Gems::NotFound
        @target_gem = nil
      end

      # NOTE: owner/repo_nameの形式で返す
      def extract_repository_name_from(source_url)
        return '' if source_url.nil?
        return '' if source_url == 'https://github.com/' || source_url == 'http://github.com/'

        if source_url.start_with?('https://github.com/') || source_url.start_with?('http://github.com/')
          puts source_url
          begin
            URI.parse(source_url).path.split('/')[1..2].join('/')
          rescue URI::InvalidURIError
            ''
          end
        else
          ''
        end
      end
    end
  end
end
