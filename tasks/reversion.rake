# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
desc "update version.rb"
task :reversion do
  File.open("lib/#{GEMSPEC.name}/version.rb", 'w+') do |file|
    file.puts("module #{PROJECT_MODULE}")
    file.puts('  VERSION = %p' % GEMSPEC.version.to_s)
    file.puts('end')
  end
end
