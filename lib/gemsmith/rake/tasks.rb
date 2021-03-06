# frozen_string_literal: true

require "rake"
require "gemsmith/gem/specification"
require "gemsmith/errors/base"
require "gemsmith/errors/specification"
require "gemsmith/rake/builder"
require "gemsmith/rake/publisher"

module Gemsmith
  module Rake
    # Provides Rake tasks for use in all gems built by this gem.
    class Tasks
      include ::Rake::DSL

      def self.default_gem_spec
        Dir.glob("#{Dir.pwd}/*.gemspec").first
      end

      def self.setup
        new.install
      end

      def initialize gem_spec: Gem::Specification.new(self.class.default_gem_spec),
                     builder: Rake::Builder.new,
                     publisher: Rake::Publisher.new
        @gem_spec = gem_spec
        @builder = builder
        @publisher = publisher
      end

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def install
        desc "Update README (table of contents)"
        task :doc do
          builder.doc
        end

        desc "Clean gem artifacts"
        task :clean do
          builder.clean
        end

        task :validate do
          builder.validate
        end

        desc "Build #{gem_spec.package_file_name} package"
        task build: %i[clean doc validate] do
          builder.build gem_spec
        end

        desc "Install #{gem_spec.package_file_name} package"
        task install: :build do
          builder.install gem_spec
        end

        desc "Build, tag as #{gem_spec.version_label} (#{signed_label}), " \
             "and push #{gem_spec.package_file_name} to RubyGems"
        task publish: :build do
          publisher.publish
        end
      end

      private

      attr_reader :gem_spec, :builder, :publisher

      def signed_label
        publisher.signed? ? "signed" : "unsigned"
      end
    end
  end
end
