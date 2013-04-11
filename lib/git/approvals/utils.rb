module Git
  module Approvals
    module Utils

      def filenamify( string )
        string.downcase.gsub /\W+/, '_'
      end
      module_function :filenamify
    end
  end
end
