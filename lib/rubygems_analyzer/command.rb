# frozen_string_literal: true

require 'yaml'
require_relative 'ruby_gem'

module RubygemsAnalyzer
  class Command
    def self.run(gem_name)
      data = File.open(File.expand_path('lib/rubygems_analyzer/rubygems_stats.yml'), 'r') do |f|
        YAML.load(f)
      end['gem_stats']
      ruby_gems = data.map { |gem| RubyGem.new(name: gem['name'], downloads: gem['downloads']) }
      ordered_data = ruby_gems.sort_by(&:downloads).reverse

      target_gem_stats = ruby_gems.find { _1.name == gem_name }
      return puts 'No such gem' unless target_gem_stats

      max_name_length = ruby_gems.map { _1.name.length }.max
      scale_factor = ruby_gems.map(&:downloads).max / 50 # is the max length of the graph

      ordered_data.each do |gem|
        graph_length = gem.downloads / scale_factor
        color = gem.name == gem_name ? "\e[33m" : "\e[34m"
        graph_bar = "#{color}#{'■' * graph_length}\e[0m"
        puts "#{gem.name.ljust(max_name_length)} ┤#{graph_bar} #{gem.downloads}"
      end
    end
  end
end
