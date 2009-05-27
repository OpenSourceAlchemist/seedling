# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
desc 'install dependencies'
task :install_dependencies => [:gem_installer] do
  GemInstaller.new do
    setup_gemspec(GEMSPEC)
  end
end
