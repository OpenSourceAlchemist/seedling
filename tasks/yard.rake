# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
desc 'Generate YARD documentation'
task :yard => :clean do
  sh("yardoc -o ydoc --protected -r #{PROJECT_README} lib/**/*.rb tasks/*.rake")
end
