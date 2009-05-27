# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
desc 'update manifest'
task :manifest do
  File.open('MANIFEST', 'w+'){|io| io.puts(*GEMSPEC.files) }
end
