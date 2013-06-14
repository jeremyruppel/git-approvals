require 'tilt'

module Git
  module Approvals
    class SassFormatter < Tilt::Template

      def self.engine_initialized?
        defined?(::Sass::Engine)
      end

      def initialize_engine
        require_template_library 'sass'
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        # TODO use locals as options to the formatter
        ::Sass::Engine.new( context, {
          :syntax     => :scss,
          :cache      => false,
          :read_cache => false,
          :style      => :expanded
        } ).render
      end
    end
  end
end
