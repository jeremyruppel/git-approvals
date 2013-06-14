require 'open3'
require 'pathname'
require 'tilt'

module Git
  module Approvals

    ##
    #
    class Approval < Pathname

      def initialize( path, options={} ) # :nodoc:
        @options = options

        path = Pathname( path )
        path = munge_format( path )
        path = munge_filename( path )

        super path.to_path
      end
      attr_reader :options

      ##
      # Makes sure the given pathname has an extension.
      def munge_format( path )
        ext = [ options[ :format ], path.extname, 'txt' ].detect do |arg|
          !arg.nil? && !arg.empty?
        end
        ext = ext.to_s
        ext = '.' + ext unless ext.start_with?( '.' )
        path.sub_ext ext
      end

      ##
      # Makes sure the given pathname has the correct filename.
      def munge_filename( path )
        if filename = options[ :filename ]
          dir, base = path.split
          dir.join( filename + base.extname )
        else
          path
        end
      end

      ##
      # Diffs the given string with this approval file. If the
      # file has not been checked in, this method will raise an
      # exception. Otherwise, the supplied block will only be
      # called if the diff fails, meaning there are differences.
      def diff( string, &block )
        # Make sure the directory of the file exists.
        dirname.mkpath

        # Write the new string to the file.
        open 'w' do |f|
          f << Tilt.new( to_path ).render( string )
        end

        # If the file hasn't been checked in, raise an error.
        sh "git ls-files #{to_path} --error-unmatch" do |err|
          raise Errno::ENOENT, to_path
        end

        # If the file has changed, call the block.
        sh "git diff --exit-code #{to_path}" do |err|
          block.call err
        end
      end

      ##
      # Shells out the given command. If the command exits with success,
      # does nothing. If the command does not exit with success, yields
      # the error output to the block.
      def sh( cmd )
        out, cmd = Open3.capture2e cmd
        yield out if !cmd.success?
      end
    end

    ##
    # Register all formatters as tilt templates.
    Tilt.register JSONFormatter,         'json'
    Tilt.register UglifierFormatter,     'js'
    Tilt.register AwesomePrintFormatter, 'txt'
  end
end
