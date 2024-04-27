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
      rescue Faraday::ConnectionFailed
        retry
      rescue Octokit::TooManyRequests
        resets_in = client.rate_limit.resets_in
        puts "GitHub API rate limit exceeded. Retry after rate limit reset. resets_in: #{resets_in}"
        sleep resets_in
      end
    end
  end
end
