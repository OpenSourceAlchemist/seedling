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
  it "Should bring our library namespace in" do
    Seedling.should == Seedling
  end
end


