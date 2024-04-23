# frozen_string_literal: true

module RubygemsAnalyzer
  class Command
    def self.run(argument)
      puts "Hello, \e[35m\"#{argument}\"\e[0m"
    end

    def self.draw_bar_chart(data)
      max_key_length = data.keys.max_by(&:length).length
      scale_factor = data.values.max / 50 # 50 is the max length of the graph

      data.each do |key, value|
        graph_length = value / scale_factor
        puts "#{key.ljust(max_key_length)} ┤\e[33m#{'■' * graph_length}\e[0m #{value}"
      end
    end
  end
end
