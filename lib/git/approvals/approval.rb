require 'open3'

module Git
  module Approvals
    class Approval

      class << self

        ##
        # Registers a new formatter block by name. The block
        # is expected to return a deterministic string
        # representation of an object.
        def register_formatter( name, &block )
          formatters[ name.to_sym ] = block
        end

        ##
        # Looks up the formatter named `name` and attempts to
        # format `object`. Raises a helpful error message if
        # a formatter's soft dependency cannot be loaded.
        def format( name, object )
          formatters[ name ][ object ]
        end

        protected

        ##
        # The hash of registered formatters by name.
        def formatters
          @formatters ||= { }
        end
      end

      ##
      # The `txt` format requires the `awesome_print` gem.
      # It is suitable for formatting most native ruby types.
      register_formatter :txt do |object|
        require 'awesome_print'
        object.awesome_inspect :plain => true, :indent => -2
      end

      ##
      # The `json` format requires the `json` library.
      # It is suitable for formatting JSON strings.
      register_formatter :json do |object|
        require 'json'
        JSON.pretty_generate JSON.parse( object )
      end

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
          f << self.class.format( format, string )
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
