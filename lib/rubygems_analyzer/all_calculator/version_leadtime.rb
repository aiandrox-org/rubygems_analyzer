# frozen_string_literal: true

require_relative '../client/rubygems'

module RubygemsAnalyzer
  module AllCalculator
    class VersionLeadtime
      attr_reader :gem_name, :client

      def self.call(gem_name:, client:)
        new(gem_name, client).call
      end

      def initialize(gem_name, client)
        @gem_name = gem_name
        @client = client
      end

      def call
        versions = client.versions
        return [0] if versions.size < 2

        leadtimes = []
        versions.each_cons(2) do |(newer, older)|
          leadtime = calculate_version_leadtime(newer, older)

          leadtimes << leadtime
        end

        leadtimes
      end

      private

      def calculate_version_leadtime(newer, older)
        newer_created_at = Time.parse(newer['created_at'])
        older_created_at = Time.parse(older['created_at'])
        newer_created_at - older_created_at
      end
    end
  end
end
