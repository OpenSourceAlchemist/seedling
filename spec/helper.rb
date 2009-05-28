# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
require "pathname"
begin
  require "bacon"
rescue LoadError
  require "rubygems"
  require "bacon"
end

begin
  if (local_path = Pathname.new(__FILE__).dirname.join("..", "lib", "seedling.rb")).file?
    require local_path
  else
    require "seedling"
  end
rescue LoadError
  require "rubygems"
  require "seedling"
end

Bacon.summary_on_exit

describe "Spec Helper" do
  it "Should bring our library namespace in (remove this test once you have your own)" do
    Seedling.should == Seedling
  end
end


