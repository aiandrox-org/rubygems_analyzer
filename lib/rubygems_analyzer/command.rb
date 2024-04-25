# frozen_string_literal: true

require 'yaml'
require_relative 'ruby_gem'
require_relative 'client/rubygems'

module RubygemsAnalyzer
  class Command
    def self.run(gem_name)
      new(gem_name).run
    end

    def initialize(gem_name)
      @gem_name = gem_name

      data = File.open(File.expand_path('lib/rubygems_analyzer/rubygems_stats.yml'), 'r') do |f|
        YAML.load(f)
      end['gem_stats']
      @ruby_gems = data.map { |gem| RubyGem.new(name: gem['name'], downloads: gem['downloads']) }
    end

    def run
      return puts 'No such gem' unless target_gem

      @ruby_gems.delete_if { _1.name == target_gem.name }
      @ruby_gems.push(target_gem)
      ordered_data = @ruby_gems.sort_by(&:downloads).reverse

      max_name_length = ordered_data.map { _1.name.length }.max
      scale_factor = ordered_data.map(&:downloads).max / 50 # is the max length of the graph

      ordered_data.each do |gem|
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

      client = Client::Rubygems.new(gem_name)
      @target_gem = RubyGem.new(name: gem_name, downloads: client.total_downloads_count)
    rescue Gems::NotFound
      @target_gem = nil
    end
  end
end
