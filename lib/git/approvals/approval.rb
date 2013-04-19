require 'open3'

module Git
  module Approvals
    class Approval

      FORMATTERS = {
        :txt => lambda { |object|
          require 'awesome_print'
          object.awesome_inspect :plain => true, :indent => -2
        },
        :json => lambda { |string|
          require 'json'
          JSON.pretty_generate JSON.parse( string )
        }
      }

      def initialize( path, options={} ) # :nodoc:
        @path, @options = path, options

        # rewrite the extension for the file based on the format
        @path.chomp! File.extname( @path )
        @path << '.' << format.to_s
      end
      attr_reader :path, :options

      ##
      #
      def diff( string, &block )
        # Make sure the directory of the file exists.
        FileUtils.mkdir_p File.dirname( path )

        # Write the new string to the file.
        File.open path, 'w' do |f|
          f << FORMATTERS[ format ][ string ]
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
