require File.expand_path("../helper", __FILE__)

describe "Seedling" do
  it "should set Seedling::ROOT" do
    Seedling::ROOT.class.should.equal Pathname
    Seedling::ROOT.should.not.be.nil
  end
end
