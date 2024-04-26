# frozen_string_literal: true

require 'octkit'
require 'dotenv/load'

module RubygemsAnalyzer
  module Client
    class Github
      attr_reader :client

      def initialize
        @client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN', nil))
      end

      def get_star(repo_name:)
        client.repository(repo_name)[:stargazers_count]
      end
    end
  end
end
