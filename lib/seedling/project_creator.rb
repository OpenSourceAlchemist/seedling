# Copyright (c) 2008-2009 The Rubyists, LLC (effortless systems) <rubyists@rubyists.com>
# Distributed under the terms of the MIT license.
# See the LICENSE file that accompanied this software for the full MIT License text
#
# Copyright (c) The Rubyists, LLC.
# Released under the terms of the MIT License
# 
# Some files in this distribution are copied from Michael Fellinger's
# Ramaze or Innate projects and are distributed under 
# Copyright (c) 2008 Michael Fellinger m.fellinger@gmail.com
# project_creator.rb is one of these files

require 'fileutils'
require 'pathname'
require 'find'
require 'erb'

module Seedling
  class ProjectCreator
    PROTO = [Pathname.new(__FILE__).dirname.expand_path.join("..", "templates", "core")]
    PROTO.unshift(Pathname.new(ENV["HOME"]).join(".seedling_skel")) if ENV["HOME"] # Guard against Windows
    attr_accessor :pot, :options

    def initialize(pot, options = {})
      @pot, @options = Pathname.new(pot), options
      @interactive = @options.keys.include?(:interactive) ? @options[:interactive] : true
    end

    def target
      pot.expand_path
    end

    def proto
      PROTO.map!{|pr| pr.expand_path }
      proto = options[:proto] ||= PROTO.find{|f| f.directory? }
      layout = options[:layout] || ""
      proto.join(layout).expand_path
    end

    def create_root?
      return true unless target.directory?
      return true if amend? or force?
      fatal "%p is a directory, choose different project name or use --amend/--force" % target
    end

    def got_proto?
      return true if proto.directory?
      fatal "Cannot create, %p doesn't exist, use --proto or create the proto directory" % proto
    end

    def create
      got_proto?

      puts("Found proto at: %p, proceeding...\n\n" % proto) if @interactive
      mkdir(relate('/')) if create_root?
      proceed
    end

    def proceed
      files, directories = partition{|path| File.file?(path) }
      proceed_directories(directories)
      proceed_files(files)
    end

    def proceed_files(files)
      files.each{|file| copy(file, relate(file)) }
    end

    def proceed_directories(dirs)
      dirs.each{|dir| mkdir(relate(dir)) }
    end

    def mkdir(dir)
      exists = File.directory?(dir)
      return if exists and amend?
      return if exists and not force?
      puts("mkdir(%p)" % dir) if @interactive
      FileUtils.mkdir_p(dir)
    end

    def copy(from, to)
      return unless copy_check(to)
      puts("copy(%p, %p)" % [from, to]) if @interactive
      FileUtils.cp(from, to)
      post_process(to)
    end

    def copy_check(to)
      exists = File.file?(to)
      return false if exists and amend?
      return false if exists and not force?
      return true
    end

    # Any file in the prototype directory named /\.seed$/
    # will be treated as an ERB template and parsed in the current 
    # binding.  the @options hash should be used for storing
    # values to be used in the templates
    def post_process(file)
      if File.basename(file.to_s).match(/library/)
        oldfile = file
        file = file.to_s.sub("library", @options[:lib_name_u])
        FileUtils.mv(oldfile, file)
      end
      if File.dirname(file.to_s).split("/").last == "library"
        origdir = File.dirname(file.to_s)
        dirarr = origdir.split("/")
        dirarr[dirarr.size-1] = @options[:lib_name_u]
        new_dir = File.join(dirarr)
        mkdir(new_dir)
        oldfile = file
        file = File.join(new_dir, File.basename(file))
        FileUtils.mv(oldfile, file)
        FileUtils.rmdir(origdir)
      end
      if file.to_s.match(/\.seed$/)
        out_file = Pathname.new(file.to_s.sub(/\.seed$/, ''))
        # Don't overwrite a file of the same name, unless they --force
        if copy_check(out_file)
          template = ::ERB.new(File.read(file))
          # This binding has access to any instance variables of
          # the ProjectCreator instance
          result = template.result(binding)
          File.open(file.to_s.sub(/\.seed$/,''), 'w+') do |io|
            io.puts result
          end
        end
        # Remove the seed file whether we copied or not
        FileUtils.rm_f(file)
      end
    end

    def relate(path)
      File.join(target, path.to_s.sub(proto.to_s, ''))
    end

    def amend?; options[:amend] end
    def force?; options[:force] end

    def fatal(message)
      warn message
      exit 1
    end

    def each
      Dir["#{proto}/**/*"].each{|path| yield(path) }
    end

    include Enumerable
  end
end
