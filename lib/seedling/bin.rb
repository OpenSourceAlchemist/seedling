#!/usr/bin/env ruby
require 'optparse'
require "seedling/extensions/inflector"
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
          require "seedling/project_creator"
          cmd.plant(cmd.command)
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
        txt << plant_options.to_s << "\n"
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
          o.banner = "Planting Options"
          o.on("-nSUMMARY", "--summary SUMMARY", "Short description of this project") { |yn| opts[:summary] = yn }
          o.on("-dDESCRIPTION", "--description DESCRIPTION", "Longer description (Default: summary)") { |des| opts[:description] = des }
          o.on("-lLIBNAME", "--libname LIBNAME", "Library name (Default: path specifcation)") { |libname| opts[:lib_name] = libname }
          o.on("-vVER", "--version VER", "Initial version number (Default: 0.0.1)") { |ver| opts[:version] = ver }

          o.separator ""
          o.separator "Author Options"
          o.on("-sAUTHOR", "--summary AUTHOR", "Author's Name") { |yn| opts[:author_name] = yn }
          o.on("-sEMAIL", "--summary EMAIL", "Author's Email") { |yn| opts[:author_email] = yn }
          o.on("-uURL", "--url URL", "Project URL/homepage") { |url| opts[:project_url] = url }

          o.separator ""
          o.separator "Directory Creation Options"
          o.on("-f", "--force", "Force creation if dir already exists") { |yn| opts[:force] = true }
          o.on("-a", "--amend", "Update a tree") { |yn| opts[:amend] = true }
        end
      end
      
      def plant(command) # {{{
        plant_options(o = {}).parse!(ARGV)
        unless ARGV.size == 1
          $stderr.puts "Invalid options given: #{ARGV.join(" ")}"
          exit 1
        end
        project_root = ARGV.shift
        if project_root.nil?
          $stderr.puts "Must supply a valid directory to install your project, you gave none."
          puts usage
          exit 1
        end
        o[:lib_name] ||= Pathname.new(project_root).basename.to_s.classify
        o[:lib_name_u] ||= o[:lib_name].underscore
        opts = plant_defaults(o)
        # need to titleize this
        include_seedling
        Seedling::ProjectCreator.new(project_root, opts).create
      end # }}}

      private

      # Sets all of our default settings to make a sane rakefile, pulling from everywhere that makes sense
      def plant_defaults(o = {:lib_name => "Seedling"})
        # this shouldn't happen, but if so let's be descriptive
        raise "plant_defaults requires a :lib_name in the calling argument" unless o[:lib_name]
        o[:lib_name_u] = o[:lib_name].underscore
        [:author_name, :author_email].each do |opt|
          o[opt] = self.send(opt)
        end
        o[:summary] ||= "The #{o[:lib_name].classify.titleize} library, by #{o[:author_name]}"
        o[:description] ||= o[:summary]
        o[:version] ||= "0.0.1"
        o
      end

      def author_email
        gitted = %x{git config --global --get user.email}
        return gitted.to_s.strip if gitted.to_s.match(/\w/)
        return ENV["EMAIL"] if ENV["EMAIL"]
        return [ENV["LOGUSER"], ENV["HOSTNAME"]].join("@") if ENV["LOGUSER"] and ENV["HOSTNAME"]
        raise "Cannot find author email, please  use --email \"you@your.domain.com\" or set the EMAIL environment variable"
      end

      def author_name
        gitted = %x{git config --global --get user.name}
        return gitted.to_s.strip if gitted.to_s.match(/\w/)
        return ENV["NAME"] if ENV["NAME"]
        return ENV["LOGUSER"] if ENV["LOGUSER"]
        return Pathname.new(ENV["HOME"]).expand_path.basename.to_s if ENV["HOME"]
        raise "Cannot find author name, please  use --author \"Your Name\" or set the NAME or LOGUSER environment variables"
      end

      ### End of command methods }}}
    end # }}}
  end
end

if $0 == __FILE__
  Seedling::Bin::Cmd.run(ARGV)
end
