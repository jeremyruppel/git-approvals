require 'tilt'

module Git
  module Approvals
    class JSONFormatter < Tilt::Template

      def self.engine_initialized?
        defined?(::JSON)
      end

      def initialize_engine
        require_template_library 'json'
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        # TODO use locals as options to the formatter
        JSON.pretty_generate( JSON.parse( context ) )
      end
    end
  end
end
