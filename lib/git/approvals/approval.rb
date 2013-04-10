require 'open3'

module Git
  module Approvals
    class Approval

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
      # Shells out the given command. If the command exits with success,
      # does nothing. If the command does not exit with success, yields
      # the error output to the block.
      def sh( cmd )
        out, cmd = Open3.capture2e cmd
        yield out if !cmd.success?
      end

      ##
      #
      def path
        File.join dirname, pathname
      end

      ##
      #
      def filename
        raise NotImplementedError, 'Subclasses must define #filename'
      end

      ##
      #
      def dirname
        raise NotImplementedError, 'Subclasses must define #dirname'
      end
    end
  end
end
