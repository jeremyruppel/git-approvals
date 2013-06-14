require 'tilt'

module Git
  module Approvals
    class UglifierFormatter < Tilt::Template

      def self.engine_initialized?
        defined?(::Uglifier)
      end

      def initialize_engine
        require_template_library 'uglifier'
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        # TODO use locals as options to the formatter
        Uglifier.compile context,
          :output => {
            :beautify     => true,
            :indent_level => 2,
            :comments     => :all,
            :space_colon  => true
          }
      end
    end
  end
end
