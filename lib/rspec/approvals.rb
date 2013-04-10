require 'git-approvals'

module RSpec

  class Approval < Git::Approvals::Approval

    def initialize( path )
      @path = path
    end
    attr_reader :path
  end

  module Approvals

    ##
    # Verifies that the result of the block is the same as the approved
    # version.
    def verify( &block )
      approval = RSpec::Approval.new( approval_path )
      approval << block.call
      approval.diff { |err| ::RSpec::Expectations.fail_with err }
    rescue Errno::ENOENT => e
      ::RSpec::Expectations.fail_with e.message
      EOS
    end

    ##
    # The path to the approval for this example
    def approval_path
      File.join approval_directory, approval_filename
    end

    ##
    # The approval filename
    def approval_filename
      example.description.downcase.gsub /\W+/, '_'
    end

    ##
    # The directory containing this spec's approvals
    def approval_directory
      example.file_path.sub /\.rb$/, ''
    end
  end

  ##
  #
  configure { |config| config.include RSpec::Approvals }
end
