# frozen_string_literal: true

module RubygemsAnalyzer
  class Command
    def self.run(argument)
      puts "Hello, \e[35m\"#{argument}\"\e[0m"
    end
  end
end
