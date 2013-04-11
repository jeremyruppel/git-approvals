module Git
  module Approvals
    module Utils

      def filenamify( string )
        string.downcase.gsub( /\W+/, '_' ).gsub( /^_|_$/, '' )
      end
      module_function :filenamify
    end
  end
end
