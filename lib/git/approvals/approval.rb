require 'open3'
require 'pathname'
require 'tilt'

module Git
  module Approvals
    Tilt.register JSONFormatter,         'json'
    Tilt.register UglifierFormatter,     'js'
    Tilt.register AwesomePrintFormatter, 'txt'

    ##
    #
    class Approval < Pathname

      def initialize( path, options={} ) # :nodoc:
        @path, @options = path, options

        # rewrite the extension for the file based on the format
        @path.chomp! File.extname( @path )
        @path << '.' << format.to_s
      end
      attr_reader :path, :options

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
          f << Tilt.new( to_path ).render( string )
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

      ##
      # The format of this approval. Determines the file extension
      # and also the formatter to use when writing the approval file.
      def format
        options[ :format ] || :txt
      end
    end
  end
end
