# frozen_string_literal: true

require "spec_helper"

RSpec.describe Gemsmith::CLI do
  let(:options) { [] }
  let(:command_line) { Array(command).concat options }
  let :cli do
    lambda do
      load "gemsmith/cli.rb" # Ensures clean Thor `.method_option` evaluation per spec.
      described_class.start command_line
    end
  end

  shared_examples_for "a generate command" do
    let(:gem_name) { "tester" }
    let(:gem_dir) { Pathname.new File.join(temp_dir, gem_name) }
    let :files do
      files = Pathname.glob("#{gem_dir}/**/*", File::FNM_DOTMATCH).select(&:file?)
      files = files.map { |file| file.relative_path_from gem_dir }
      files = files.reject { |file| file.to_s =~ %r(^(\.git\/.+|\.tags|\.rubocop-http.*)$) }
      files.map(&:to_s)
    end

    context "with no options", :temp_dir do
      let :options do
        [
          gem_name,
          "--no-cli",
          "--no-rails",
          "--no-security",
          "--no-pry",
          "--no-guard",
          "--no-rspec",
          "--no-reek",
          "--no-rubocop",
          "--no-scss-lint",
          "--no-git-hub",
          "--no-code-climate",
          "--no-gemnasium",
          "--no-travis",
          "--no-patreon"
        ]
      end

      it "generates basic gem" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir temp_dir do
            cli.call

            expect(files).to contain_exactly(
              ".gitignore",
              ".ruby-version",
              "bin/setup",
              "lib/tester/identity.rb",
              "lib/tester.rb",
              "CHANGES.md",
              "CODE_OF_CONDUCT.md",
              "CONTRIBUTING.md",
              "Gemfile",
              "LICENSE.md",
              "README.md",
              "Rakefile",
              "tester.gemspec"
            )
          end
        end
      end
    end

    context "with CLI option only", :temp_dir do
      let :options do
        [
          gem_name,
          "--cli"
        ]
      end

      it "generates CLI gem" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir temp_dir do
            cli.call

            expect(files).to contain_exactly(
              ".gitignore",
              ".rubocop.yml",
              ".ruby-version",
              "bin/setup",
              "bin/tester",
              "lib/tester/identity.rb",
              "lib/tester/cli.rb",
              "lib/tester.rb",
              "spec/lib/tester/cli_spec.rb",
              "spec/support/shared_contexts/temp_dir.rb",
              "spec/spec_helper.rb",
              "CHANGES.md",
              "CODE_OF_CONDUCT.md",
              "CONTRIBUTING.md",
              "Gemfile",
              "Guardfile",
              "LICENSE.md",
              "README.md",
              "Rakefile",
              "tester.gemspec"
            )
          end
        end
      end
    end

    context "with all options (minus CLI)", :temp_dir do
      let :options do
        [
          gem_name,
          "--rails",
          "--security",
          "--pry",
          "--guard",
          "--rspec",
          "--reek",
          "--rubocop",
          "--scss-lint",
          "--git-hub",
          "--code-climate",
          "--gemnasium",
          "--travis",
          "--patreon"
        ]
      end
      let(:controllers_dir) { File.join gem_dir, "app", "controllers", gem_name }
      let(:mailers_dir) { File.join gem_dir, "app", "mailers", gem_name }
      let(:models_dir) { File.join gem_dir, "app", "models", gem_name }

      # FIX: This block should be removed once it is determined why `rails plugin new` doesn't run
      # via the `Generators::Rails#create_engine` within this spec.
      before do
        FileUtils.mkdir_p controllers_dir
        FileUtils.touch File.join(controllers_dir, "application_controller.rb")

        FileUtils.mkdir_p mailers_dir
        FileUtils.touch File.join(mailers_dir, "application_mailer.rb")

        FileUtils.mkdir_p models_dir
        FileUtils.touch File.join(models_dir, "application_record.rb")
      end

      it "generates full gem" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir temp_dir do
            cli.call

            expect(files).to contain_exactly(
              ".codeclimate.yml",
              ".gitignore",
              ".rubocop.yml",
              ".ruby-version",
              ".travis.yml",
              ".github/ISSUE_TEMPLATE.md",
              ".github/PULL_REQUEST_TEMPLATE.md",
              "bin/setup",
              "gemfiles/rails-5.0.x.gemfile",
              "app/controllers/tester/application_controller.rb",
              "app/mailers/tester/application_mailer.rb",
              "app/models/tester/application_record.rb",
              "lib/generators/tester/install/USAGE",
              "lib/generators/tester/install/install_generator.rb",
              "lib/generators/tester/upgrade/USAGE",
              "lib/generators/tester/upgrade/upgrade_generator.rb",
              "lib/tester/engine.rb",
              "lib/tester/identity.rb",
              "lib/tester.rb",
              "spec/support/shared_contexts/temp_dir.rb",
              "spec/rails_helper.rb",
              "spec/spec_helper.rb",
              "CHANGES.md",
              "CODE_OF_CONDUCT.md",
              "CONTRIBUTING.md",
              "Gemfile",
              "Guardfile",
              "LICENSE.md",
              "Rakefile",
              "README.md",
              "tester.gemspec"
            )
          end
        end
      end
    end

    context "with CLI and Rails Engine options only", :temp_dir do
      let :options do
        [
          gem_name,
          "--cli",
          "--rails"
        ]
      end

      it "generates basic gem" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir temp_dir do
            cli.call

            expect(files).to be_empty
          end
        end
      end

      it "prints error message" do
        ClimateControl.modify HOME: temp_dir do
          Dir.chdir temp_dir do
            result = -> { cli.call }
            expect(&result).to output(/.+is\snot\sallowed.+/).to_stdout
          end
        end
      end
    end
  end

  shared_examples_for "a config command", :temp_dir do
    let(:configuration_path) { File.join temp_dir, Gemsmith::Identity.file_name }
    before { FileUtils.touch configuration_path }

    context "with info option" do
      let(:options) { %w[-i] }

      it "prints configuration path" do
        Dir.chdir(temp_dir) do
          expect(&cli).to output("#{configuration_path}\n").to_stdout
        end
      end
    end

    context "with no options" do
      it "prints help text" do
        expect(&cli).to output(/Manage gem configuration./).to_stdout
      end
    end
  end

  shared_examples_for "a version command" do
    it "prints version" do
      expect(&cli).to output(/Gemsmith\s#{Gemsmith::Identity.version}\n/).to_stdout
    end
  end

  shared_examples_for "a help command" do
    it "prints usage" do
      expect(&cli).to output(/Gemsmith\s#{Gemsmith::Identity.version}\scommands:\n/).to_stdout
    end
  end

  describe ".source_root" do
    it "answers source root" do
      expect(described_class.source_root).to include("gemsmith/lib/gemsmith/templates")
    end
  end

  describe ".configuration", :temp_dir do
    let :defaults do
      {
        year: Time.now.year,
        github_user: "tester",
        gem: {
          name: "undefined",
          path: "undefined",
          class: "Undefined",
          platform: "Gem::Platform::RUBY",
          url: "https://github.com/tester/undefined",
          license: "MIT"
        },
        author: {
          name: "Test",
          email: "test@example.com",
          url: ""
        },
        organization: {
          name: "",
          url: ""
        },
        versions: {
          ruby: "2.0.0",
          rails: "5.0"
        },
        generate: {
          cli: false,
          rails: false,
          security: true,
          pry: true,
          guard: true,
          rspec: true,
          reek: true,
          rubocop: true,
          scss_lint: false,
          git_hub: false,
          code_climate: false,
          gemnasium: false,
          travis: false,
          patreon: false
        },
        publish: {
          sign: false
        }
      }
    end

    before do
      allow(Gemsmith::Git).to receive(:config_value).with("github.user").and_return("tester")
      allow(Gemsmith::Git).to receive(:config_value).with("user.name").and_return("Test")
      allow(Gemsmith::Git).to receive(:config_value).with("user.email")
        .and_return("test@example.com")
    end

    it "answers default settings" do
      ClimateControl.modify HOME: temp_dir do
        Dir.chdir(temp_dir) do
          stub_const "RUBY_VERSION", "2.0.0"
          expect(described_class.configuration.to_h).to eq(defaults)
        end
      end
    end
  end

  describe ".generators" do
    it "answers gem generators" do
      expect(described_class.generators).to contain_exactly(
        Gemsmith::Generators::Gem,
        Gemsmith::Generators::Documentation,
        Gemsmith::Generators::Rake,
        Gemsmith::Generators::CLI,
        Gemsmith::Generators::Ruby,
        Gemsmith::Generators::Rails,
        Gemsmith::Generators::Rspec,
        Gemsmith::Generators::Reek,
        Gemsmith::Generators::Rubocop,
        Gemsmith::Generators::SCSSLint,
        Gemsmith::Generators::CodeClimate,
        Gemsmith::Generators::Guard,
        Gemsmith::Generators::Travis,
        Gemsmith::Generators::Bundler,
        Gemsmith::Generators::Git,
        Gemsmith::Generators::Pragma,
        Gemsmith::Generators::GitHub
      )
    end
  end

  describe "--generate" do
    let(:command) { "--generate" }
    it_behaves_like "a generate command"
  end

  describe "-g" do
    let(:command) { "-g" }
    it_behaves_like "a generate command"
  end

  describe "--open" do
    let(:command) { "--open" }
    it "behaves like an open command"
  end

  describe "-o" do
    let(:command) { "-o" }
    it "behaves like an open command"
  end

  describe "--read" do
    let(:command) { "--read" }
    it "behaves like a read command"
  end

  describe "-r" do
    let(:command) { "-r" }
    it "behaves like a read command"
  end

  describe "--config" do
    let(:command) { "--config" }
    it_behaves_like "a config command"
  end

  describe "-c" do
    let(:command) { "-c" }
    it_behaves_like "a config command"
  end

  describe "--version" do
    let(:command) { "--version" }
    it_behaves_like "a version command"
  end

  describe "-v" do
    let(:command) { "-v" }
    it_behaves_like "a version command"
  end

  describe "--help" do
    let(:command) { "--help" }
    it_behaves_like "a help command"
  end

  describe "-h" do
    let(:command) { "-h" }
    it_behaves_like "a help command"
  end

  context "with no command" do
    let(:command) { nil }
    it_behaves_like "a help command"
  end
end
