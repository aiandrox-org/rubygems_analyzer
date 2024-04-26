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
        begin
          client.repository(repo_name)[:stargazers_count]
        rescue Octokit::NotFound, Octokit::InvalidRepository
          0
        end

        # NOTE: GitHub APIのレート制限に引っかからないようにする
        sleep 1.4
      end
    end
  end
end
