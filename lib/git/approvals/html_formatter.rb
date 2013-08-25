require 'tilt'

module Git
  module Approvals
    class HTMLFormatter < Tilt::Template

      def self.engine_initialized?
        defined?(::Nokogiri)
      end

      def initialize_engine
        require_template_library 'nokogiri'
      end

      def prepare
      end

      def evaluate( context, locals, &block )
        Nokogiri::XML( context ).to_xhtml :indent => 2
      end
    end
  end
end
