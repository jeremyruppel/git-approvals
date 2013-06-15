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

      def transform_filename( str, options={} )

        if opt = options.delete( :format )
          str.chomp! File.extname( str )
          str << '.' << opt.to_s
        end

        if opt = options.delete( :filename )
          base = File.basename( str, File.extname( str ) )
          str.sub! /#{base}(?!\/)/, opt
        end

        str
      end
      module_function :transform_filename
    end
  end
end
