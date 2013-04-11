module Git
  module Approvals
    module Utils

      ##
      # Converts a string into a string that can be used as a filename.
      def filenamify( string )
        string
          .gsub( /([a-z])([A-Z])/, '\1_\2' )
          .gsub( /\W+/, '_' )
          .gsub( /^_|_$/, '' )
          .downcase
      end
      module_function :filenamify
    end
  end
end
