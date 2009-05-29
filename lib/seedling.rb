# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
require "pathname"
require "date"

class Pathname
  def /(other)
    join(other.to_s)
  end
end

$LOAD_PATH.unshift((Pathname(__FILE__).dirname).expand_path.to_s)
module Seedling
  autoload :VERSION, "seedling/version"
  ROOT = (Pathname($LOAD_PATH.first)/"..").expand_path unless Seedling.const_defined?("ROOT")
  LIBDIR = ROOT/:lib
end
