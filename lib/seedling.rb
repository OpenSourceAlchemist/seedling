require "pathname"
$LOAD_PATH.unshift(Pathname.new(__FILE__).dirname.expand_path.to_s)
module Seedling
end
require "seedling/version"
