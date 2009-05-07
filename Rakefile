begin; require 'rubygems'; rescue LoadError; end

require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'time'
require 'date'
require "lib/seedling"

PROJECT_SPECS = FileList[
  'spec/**/*.rb'
]

PROJECT_MODULE = 'Seedling'
PROJECT_README = 'README'
#PROJECT_RUBYFORGE_GROUP_ID = 3034
PROJECT_COPYRIGHT = [
  "#          Copyright (c) #{Time.now.year} The Rubyists rubyists@rubyists.com",
  "# Distributed under the terms of the MIT license."
]

# To release the monthly version do:
# $ PROJECT_VERSION=2009.03 rake release
IGNORE_FILES = [/\.gitignore/]

GEMSPEC = Gem::Specification.new{|s|
  s.name         = 'seedling'
  s.author       = "Kevin Berry"
  s.summary      = "A lightweight tool to create new ruby library trees, with helpers to make gemming and maintaining a breeze."
  s.description  = s.summary
  s.email        = 'deathsyn@gmail.com'
  s.homepage     = 'http://github.com/deathsyn/seedling'
  s.platform     = Gem::Platform::RUBY
  s.version      = (ENV['PROJECT_VERSION'] || (begin;Object.const_get(PROJECT_MODULE)::VERSION;rescue;Date.today.strftime("%Y.%m.%d");end))
  s.files        = `git ls-files`.split("\n").sort.reject { |f| IGNORE_FILES.detect { |exp| f.match(exp)  } }
  s.has_rdoc     = true
  s.require_path = 'lib'
  s.bindir = "bin"
  s.executables = ["seedling"]
  s.rubyforge_project = "seedling"

  s.post_install_message = <<MESSAGE.strip
============================================================

Thank you for installing Name Parse!
Begin by planting your ruby project with 
# seedling plant /path/to/new/project

============================================================
MESSAGE
}

Dir['tasks/*.rake'].each{|f| import(f) }

task :default => [:bacon]

CLEAN.include %w[
  **/.*.sw?
  *.gem
  .config
  **/*~
  **/{data.db,cache.yaml}
  *.yaml
  pkg
  rdoc
  ydoc
  *coverage*
]
