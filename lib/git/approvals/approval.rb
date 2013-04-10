require 'open3'

module Git
  module Approvals
    class Approval

      def initialize( path ) # :nodoc:
        @path = path
      end
      attr_reader :path

      ##
      #
      def diff( &block )
        sh "git ls-files #{path} --error-unmatch" do |err|
          raise Errno::ENOENT, path
        end
        sh "git diff --exit-code #{path}" do |err|
          block.call err
        end
      end

      ##
      #
      def <<( string )
        FileUtils.mkdir_p File.dirname( path )
        File.open path, 'w' do |f|
          f << string
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
  end
end
