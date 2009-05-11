#!/usr/bin/env ruby
require 'optparse'
### This module offers the functionality to create.
module Seedling
  module Bin
    class Cmd # This class contains the command methods {{{
      #include Helpers
      attr_accessor :command

      def initialize(args = nil)
        args ||= ARGV
        raise "arguments must be an array!" unless args.respond_to?(:detect)
        @ourargs = args.dup
        @command = args.detect { |arg| arg.match(/^(?:--?)?(?:plant|create|h(?:elp)?|v(?:ersion)?|console)/) }
        if command.nil?
          @command = ""
        else
          args.delete(@command)
        end
        ARGV.replace(args)
      end

      # {{{ #run is called when we're interactive ($0 == __FILE__)
      def self.run(args = nil)
        cmd = new(args)
        case cmd.command
        when /^(?:--?)?(?:plant|create)$/
          cmd.create(cmd.command)
        when /^(?:--?)?console$/
          require "irb"
          require "irb/completion"
          cmd.include_seedling
          IRB.start
          puts "Seedling session has ended."
        when /^(?:--?)?h(elp)?$/
          puts cmd.usage
        when /^(?:--?)?v(ersion)?$/
          cmd.include_seedling
          puts Seedling::VERSION
          exit
        when /^$/
          puts "Must supply a valid command"
          puts cmd.usage
          exit 1
        else
          puts "#{command} not implemented"
          puts cmd.usage
          exit 1
        end
      end # }}}

      def include_seedling # {{{
        begin
          $LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/../lib')
          require 'seedling'
        rescue LoadError
          $LOAD_PATH.shift

          begin
            require 'rubygems'
          rescue LoadError
          end
          require 'seedling'
        end
      end # }}}

      def usage # {{{
        txt = [
          "\n  Usage:", 
          "seedling <plant|create|console> PROJECT [options]\n",
          "Commands:\n",
          " plant   - Creates a new prototype Seedling application in a directory named PROJECT in",
          "           the current directory.  seedling create foo would make ./foo containing a",
          "           seedling prototype.\n",
          " create  - Synonymous with plant.\n",
          " console - Starts an irb console with seedling (and irb completion) loaded.",
          "           ARGV is passed on to IRB.\n\n"
        ].join("\n\t")

        txt <<  "* All commands take PROJECT as the directory the seedling lives in.\n\n"
        txt << start_options.to_s << "\n"
        txt << create_options.to_s << "\n"
        #if is_windows?
          #txt << %x{ruby #{rackup_path} --help}.split("\n").reject { |line| line.match(/^Usage:/) }.join("\n\t")
        #else
          #txt << %x{#{rackup_path} --help}.split("\n").reject { |line| line.match(/^Usage:/) }.join("\n\t")
        #end
      end # }}}

      def al_root
        require "pathname"
        dir = nil
        if ARGV.size == 1
          dir = Pathname.new(ARGV.shift)
        elsif ARGV.size > 1
          $stderr.puts "Unknown options given #{ARGV.join(" ")}"
          puts usage
          exit 1
        end
        if dir.nil? or not dir.directory?
          dir = Pathname.new(ENV["PWD"]).expand_path
          $stderr.puts "Path to seedling tree not given or invalid, using #{dir}"
        end
        Object.const_set("AL_ROOT", dir.expand_path.to_s)
        Dir.chdir(AL_ROOT)
      end

      ### Methods for commands {{{
      def plant_options(opts = {})
        @plant_opts ||= OptionParser.new do |o|
          o.banner = "Create Options"
          o.on("-f", "--force", "Force creation if dir already exists") { |yn| opts[:force] = true }
          o.on("-a", "--amend", "Update a tree") { |yn| opts[:amend] = true }
        end
      end
      
      def plant(command) # {{{
        create_options(opts = {}).parse!(ARGV)
        unless ARGV.size == 1
          $stderr.puts "Invalid options given: #{ARGV.join(" ")}"
          exit 1
        end
        project_name = ARGV.shift
        if project_name.nil?
          $stderr.puts "Must supply a valid project name, you gave none."
          puts usage
          exit 1
        end
        include_seedling
        Seedling::Create.plant(project_name, opts)
      end # }}}

      ### End of command methods }}}
    end # }}}
  end
end

if $0 == __FILE__
  Seedling::Bin::Cmd.run(ARGV)
end
