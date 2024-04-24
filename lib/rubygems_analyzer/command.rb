# frozen_string_literal: true

require 'yaml'

module RubygemsAnalyzer
  class Command
    def self.run(gem_name)
      data = File.open(File.expand_path('lib/rubygems_analyzer/rubygems_stats.yml'), 'r') { |f| YAML.load(f) }['gem_stats']
      ordered_data = data.sort_by { _1['star'] }.reverse

      target_gem_stats = data.find { _1['name'] == gem_name }
      return puts 'No such gem' unless target_gem_stats

      max_name_length = data.map { _1['name'].length }.max
      scale_factor = data.map { _1['star'] }.max / 50 # is the max length of the graph

      ordered_data.each do |gem|
        graph_length = gem['star'] / scale_factor
        color = gem['name'] == gem_name ? "\e[33m" : "\e[34m"
        graph_bar = "#{color}#{'■' * graph_length}\e[0m"
        puts "#{gem['name'].ljust(max_name_length)} ┤#{graph_bar} #{gem['star']}"
      end
    end
  end
end
