# frozen_string_literal: true

require 'octokit'
require 'dotenv/load'

module RubygemsAnalyzer
  module Client
    class Github
      attr_reader :client

      def initialize
        @client = Octokit::Client.new(
          client_id: ENV.fetch('GITHUB_OAUTH_CLIENT_ID'),
          client_sercret: ENV.fetch('GITHUB_OAUTH_CLIENT_SECRET')
        )
      end

      def get_star(repo_name:)
        begin
          client.repository(repo_name)[:stargazers_count]
        rescue Octokit::NotFound
          0
        end

        sleep 0.4
      end
    end
  end
end
