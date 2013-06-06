# v2.0.0

* Added Railtie best practices to README.
* Added Guard support.
* Converted/detailed the CONTRIBUTING guidelines per GitHub requirements.
* Updated the contribution details in the README template to point to the CONTRIBUTING template.
* Added spec focus capability.
* Added Gem Badge support.
* Added Code Climate support.
* Added Campfire notification support.
* Switched from HTTP to HTTPS when sourcing from RubyGems.
* Added Pry support.
* Cleaned up Guard gem dependency requirements.
* Added Guard support to gem generation.
* Upgraded to Ruby 2.0.0.

# v1.5.0

* Added auto-linking to GitHub Issues via README template.
* Relaxed Rails gem settings to 3.x.x.
* Switched gem dependency to Thor 0.x.x range.
* Switched gem dependency to Thor+ 0.x.x range.

# v1.4.0

* Added Travis CI templates for Rails build matrix that can support multiple version tests.
* Added vendor files to gemspec template so they are included when building a new gem (especially Rails related).
* Moved library requirements within the Rails conditional check so that requirements are only loaded if Rails is detected.
* Modified the RSpec development dependency so that if Rails is detected, the rspec-rails gem is included instead.
* Changed the Rails default version to 3.2.0.

# v1.3.0

* Specified Thor+ 0.2.x version dependency.
* Added Travis CI support.
* Added Travis CI template support (can be disable via your settings.yml or during new gem creation).
* Added the spec/tmp directory to the gitignore template.
* Added Gemsmith::Kit class with a supplementary utility method for obtaining .gitconfig values.
* Added github user support - Defaults to github config file or settings.yml.
* Updated RSpec format to better represent class and instance methods.
* Removed the -w option from gem binary and the binary template.
* No longer shell out to Git when referencing the gem/template files in gemspecs - This increases Rails boot performance.
* Switched Gemfile and Gemfile.tmp reference from "http://rubygems.org" to :rubygems.
* Moved documentation files to the extra_rdoc_files option for gem specifications
* Removed the packaging of test files.

# v1.2.0

* Updated README and README template with new layout for test instructions.
* Upgraded to Thor+ 0.2.0 and removed the settings_file, settings, and load_settings methods.
* Added Why You Should Use a BSD license to the README Best Practices section.
* Added the Best Practices While Cutting Gems to the Best Practices section of the README.
* Added the ruby warning and encoding option formats to the binary template.
* Removed the do block from RSpec template so that initial tests show pending instead of successful results.

# v1.1.0

* Fixed bug where args, options, and config were not being passed to super for CLI initialize for gem and gem template generation.
* Updated gemspec settings and removed rubygem requirements from spec helper.
* Defaulted RSpec output to documentation format for project and template generation.
* Added Ruby on Rails Gem Packaging to Best Practices section of README.
* Added the -o option for opening a gem in the default editor.
* Added RSpec documentation to README and README template.
* Added Tests, Contributions, and Credits section to README and README template.

# v1.0.0

* Upgraded to Ruby 1.9 and added Ruby 1.9 requirements.
* Upgraded Rails defaults to 3.1.x.
* Renamed ActionController and ActiveRecord class methods templates to be acts_as_* instead of is_*_enhanced.
* Changed gem specifications to use singular form of author and email.
* Added a gem_url setting (which is different from the author_url but does default to it).
* Added a Company header to the README template.
* Added the MIT license to the gemspec template.
* Added the post_install_message option for adding custom messages to gem install output.
* Simplified all TODO messages in the templates.
* Added Thor+ gem requirement.
* Removed the Utilities module and replaced all info and error messages with Thor+ actions.
* Added requirements and includes for the Thor+ gem when generating binary-enabled gem skeletons.
* Added the YAML requirement to the CLI template.

# v0.5.0

* Fixed bug with wrong definition of ActionView instance method include for main gem template.
* Changed the ActionView template behavior so that instance methods are auto-included.
* Renamed the execute methods for the install and upgrade generators to install and upgrade respectively.
* Added Rails version options. Default: 3.0.0.
* Added Ruby version option. Default: 1.9.2.
* Made the module namespace optional when building gems specifically for Rails.
* Relabeled the TODO helper text for all templates.

# v0.4.0

* Fixed bug with options not being supplied as second argument to write_inheritable_attribute for ActionController and ActiveRecord class method templates.
* Changed the -R option to -r for Rails and added the -s option for RSpec.
* Trimmed ERB whitespace from templates where apt.
* Cleaned up the source_root code for both the install and upgrade generator templates.
* Renamed the copy_files method to the execute method for both the install and upgrade generator templates.
* Moved desc method next to execution method for both the install and upgrade generator templates.
* Removed the banners from the install and upgrade generator templates since this is auto-generated by Thor.

# v0.3.0

* Added Best Practices section to the README.
* Added the -e (edit) option for editing gem settings in default editor.
* Added Thor utilities for info and error messaging.
* Removed the classify and underscore methods since their equivalents are found in the Thor::Util class.
* Removed the print_version method.
* Added Rails generator USAGE documentation for the install and update generator templates.
* Removed excess shell calls from the CLI template.
* Added Thor::Actions to CLI class template.
* Added "Built with Gemsmith" to README template.
* Updated README template so that Gemfile mention is only provided when Rails is enabled.

# v0.2.0

* Fixed typo in upgrade generator doc.
* Fixed README typo with command line options.
* Added Ruby on Rails skeleton generation support.
* Added RSpec skeleton generation support.
* Added a cli.rb template with basic Thor setup for binary skeletons.
* Added binary executable name to gemspec template for binary skeletons.
* Added gem dependencies to gemspec template for binary and RSpec skeletons.
* Added proper support for underscoring/camelcasing gem names and classes during skeleton generation.
* Added common setup options to the README template.
* Added Ruby on Rails requirements to the README template (only if the Rails options is used).
* Added Ruby on Rails generator templates for installs and upgrades.
* Added Git initialization, addition, and first commit message of all skeleton files during gem creation.
* Updated the gem description.
* Updated the documentation to include Bundler rake tasks.

# v0.1.0

* Initial version.