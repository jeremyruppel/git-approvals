require 'tilt'

module Git
  module Approvals
    class PlainFormatter < Tilt::Template

      def self.engine_initialized?
        true
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        context.to_s
      end
    end
  end
end
