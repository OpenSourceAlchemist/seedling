require File.expand_path("../helper", __FILE__)
require "tempfile"
require Seedling::ROOT/:lib/:seedling/:bin

describe "Seedling::Bin::Cmd" do
  @tmpdir = if $DEBUG  
              dir = Dir.tmpdir + "/seedling_spec_#{Time.now.to_i}"
              Dir.mkdir(dir)
              Pathname(dir)
            else
              Pathname(Dir.mktmpdir)
            end
  @seedling_bin = "#{Seedling::ROOT/:bin/:seedling}"
  before do
    Dir.chdir @tmpdir
    (@tmpdir/:the_tree).rmtree if (@tmpdir/:the_tree).directory?
  end
  
  it "Should raise and show usage when called with no command is given" do
    lambda { Seedling::Bin::Cmd.run }.should.raise(RuntimeError).
      message.should.match /^Must supply a valid command\n\n#{Seedling::Bin::Cmd.new.usage}/
  end
  
  it "Should raise and show usage when asked to plant but no target is given" do
    lambda { Seedling::Bin::Cmd.run(["plant"]) }.should.raise(RuntimeError).
      message.should.match /^"Must supply a valid directory to install your project, you gave none.\n\n#{Seedling::Bin::Cmd.new.usage}/
  end

  it "Should plant a new tree (no extra arguments)" do
    Seedling::Bin::Cmd.run(["plant", "the_tree", "-q"])
    (@tmpdir/:the_tree).directory?.should.be.true
  end
end

describe "Seedling Planted Tree" do
  @tmpdir = if $DEBUG  
              dir = Dir.tmpdir + "/seedling_spec_#{Time.now.to_i}"
              Dir.mkdir(dir)
              Pathname(dir)
            else
              Pathname(Dir.mktmpdir)
            end

  before do
    Dir.chdir @tmpdir
    (@tmpdir/:the_tree).rmtree if (@tmpdir/:the_tree).directory?
  end

  it "Should allow loading the lib on a newly planted tree" do
    Seedling::Bin::Cmd.run(["plant", "the_tree", "-q"])
    lambda { require @tmpdir/:the_tree/:lib/:the_tree }.should.not.raise LoadError
    Object.const_defined?("TheTree").should.be.true
  end

  it "Should place a spec/helper.rb in place which passes one spec" do
    Seedling::Bin::Cmd.run(["plant", "the_tree", "-q"])
    output = %x{bacon #{@tmpdir/:the_tree/:spec/:helper}.rb }
    $?.should.equal 0
    output.should.match /1 specifications \(1 requirements\), 0 failures, 0 errors/m
  end
  
  it "Should set email properly" do
    Seedling::Bin::Cmd.run(["plant", "the_tree", "-q", "--email", "foo@bar.com"])
    rakelines = (@tmpdir/:the_tree/"Rakefile").readlines
    rakelines.detect { |l| l.match(/\s+s.email\s+=\s+"(.*)"/) }.should.not.be.nil
    $~[1].should.equal "foo@bar.com"
  end
end
