# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
desc 'install all possible dependencies'
task :setup => :gem_installer do
  GemInstaller.new do
    # core

    # spec
    gem 'bacon'
    gem 'rcov'

    # doc
    gem 'yard'

    setup
  end
end
