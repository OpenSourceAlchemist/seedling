# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# The full text can be found in the LICENSE file included with this software
#
require File.expand_path("../../lib/fxc", __FILE__)
require FXC::ROOT/:model/:init

desc "migrate to latest version of db"
task :migrate do
  migrator = "sequel '#{DB.uri}' -E -m #{FXC::MIGRATION_ROOT}"
  puts %x{#{migrator}}
end
