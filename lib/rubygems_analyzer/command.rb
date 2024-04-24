# frozen_string_literal: true

require 'yaml'
require_relative 'ruby_gem'

module RubygemsAnalyzer
  class Command
    def self.run(gem_name)
      new(gem_name).run
    end

    def initialize(gem_name)
      @gem_name = gem_name
    end

    def run
      return puts 'No such gem' unless target_gem

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

    def ordered_data
      @ordered_data ||= begin
        data = File.open(File.expand_path('lib/rubygems_analyzer/rubygems_stats.yml'), 'r') do |f|
          YAML.load(f)
        end['gem_stats']
        ruby_gems = data.map { |gem| RubyGem.new(name: gem['name'], downloads: gem['downloads']) }
        ruby_gems.sort_by(&:downloads).reverse
      end
    end

    def target_gem
      @target_gem ||= ordered_data.find { _1.name == gem_name }
    end
  end
end
