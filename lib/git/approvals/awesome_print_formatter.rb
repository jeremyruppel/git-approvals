require 'tilt'

module Git
  module Approvals
    class AwesomePrintFormatter < Tilt::Template

      def self.engine_initialized?
        defined?(::AwesomePrint)
      end

      def initialize_engine
        require_template_library 'awesome_print'
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        # TODO use locals as options to the formatter
        # TODO require awesome_print/inspector to not pollute kernel, etc
        context.awesome_inspect \
          :plain  => true,
          :indent => -2
      end
    end
  end
end

