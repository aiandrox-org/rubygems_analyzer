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
          client_secret: ENV.fetch('GITHUB_OAUTH_CLIENT_SECRET')
        )
      end

      def get_star(repo_name:)
        client.repository(repo_name)[:stargazers_count]
      rescue Octokit::NotFound, Octokit::InvalidRepository
        0
      rescue Octokit::TooManyRequests => e
        puts e
        raise
      end
    end
  end
end
