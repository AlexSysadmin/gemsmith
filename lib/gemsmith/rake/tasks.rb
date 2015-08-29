require "bundler/gem_tasks"
require "gemsmith/rake/build"
require "gemsmith/rake/release"

module Gemsmith
  module Rake
    class Tasks
      include ::Rake::DSL

      def self.setup
        new.install
      end

      def install
        build = Gemsmith::Rake::Build.new
        release = Gemsmith::Rake::Release.new

        ::Rake::Task[:build].enhance [:clean, "readme:toc"]
        ::Rake::Task[:release].enhance { ::Rake::Task[:clean].invoke }

        namespace :readme do
          desc "Update README Table of Contents."
          task :toc do
            build.table_of_contents
          end
        end

        desc "Clean gem artifacts."
        task :clean do
          build.clean!
        end

        desc "Build, tag #{release.version_formatted} (signed), and push #{release.package_file_name} to RubyGems"
        task publish: [:clean, :build, "release:guard_clean"] do
          release.tag
          release.push
          ::Rake::Task["release:rubygem_push"].invoke
        end
      end
    end
  end
end