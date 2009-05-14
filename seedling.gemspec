# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{seedling}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kevin Berry"]
  s.date = %q{2009-05-14}
  s.default_executable = %q{seedling}
  s.description = %q{A lightweight tool to create new ruby library trees, with helpers to make gemming and maintaining a breeze.}
  s.email = %q{deathsyn@gmail.com}
  s.executables = ["seedling"]
  s.files = ["README", "Rakefile", "bin/seedling", "lib/seedling.rb", "lib/seedling/bin.rb", "lib/seedling/extensions/inflector.rb", "lib/seedling/project_creator.rb", "lib/seedling/version.rb", "lib/templates/core/Rakefile.seed", "lib/templates/core/lib/library.rb.seed", "lib/templates/core/lib/library/version.rb.seed", "lib/templates/core/spec/helper.rb.seed", "lib/templates/core/tasks/authors.rake", "lib/templates/core/tasks/bacon.rake", "lib/templates/core/tasks/changelog.rake", "lib/templates/core/tasks/copyright.rake", "lib/templates/core/tasks/gem.rake", "lib/templates/core/tasks/gem_installer.rake", "lib/templates/core/tasks/install_dependencies.rake", "lib/templates/core/tasks/manifest.rake", "lib/templates/core/tasks/rcov.rake", "lib/templates/core/tasks/release.rake", "lib/templates/core/tasks/reversion.rake", "lib/templates/core/tasks/setup.rake.seed", "spec/helper.rb", "tasks/authors.rake", "tasks/bacon.rake", "tasks/changelog.rake", "tasks/copyright.rake", "tasks/gem.rake", "tasks/gem_installer.rake", "tasks/install_dependencies.rake", "tasks/manifest.rake", "tasks/rcov.rake", "tasks/release.rake", "tasks/reversion.rake", "tasks/setup.rake", "tasks/yard.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/deathsyn/seedling}
  s.post_install_message = %q{============================================================

Thank you for installing Name Parse!
Begin by planting your ruby project with 
# seedling plant /path/to/new/project

============================================================}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{seedling}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A lightweight tool to create new ruby library trees, with helpers to make gemming and maintaining a breeze.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
