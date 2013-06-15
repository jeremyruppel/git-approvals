require 'open3'
require 'tilt'

module Git
  module Approvals

    ##
    #
    class Approval
      include Git::Approvals::Utils

      def initialize( path, options={} ) # :nodoc:
        @path = transform_filename( path, options )
      end
      attr_reader :path

      ##
      # Diffs the given string with this approval file. If the
      # file has not been checked in, this method will raise an
      # exception. Otherwise, the supplied block will only be
      # called if the diff fails, meaning there are differences.
      def diff( string, &block )
        # Make sure the directory of the file exists.
        FileUtils.mkdir_p File.dirname( path )

        # Write the new string to the file.
        File.open path, 'w' do |f|
          f << Tilt.new( path ).render( string )
        end

        # If the file hasn't been checked in, raise an error.
        sh "git ls-files #{path} --error-unmatch" do |err|
          raise Errno::ENOENT, path
        end

        # If the file has changed, call the block.
        sh "git diff --exit-code #{path}" do |err|
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
    Tilt.register Tilt::PlainTemplate,   ''
    Tilt.register AwesomePrintFormatter, 'txt'
    Tilt.register JSONFormatter,         'json'
    Tilt.register UglifierFormatter,     'js'
    Tilt.register SassFormatter,         'css'
  end
end
