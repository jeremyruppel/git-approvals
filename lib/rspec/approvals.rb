require 'git-approvals'

module RSpec
  module Approvals

    ##
    # Verifies that the result of the block is the same as the approved
    # version.
    def verify( options={}, &block )
      approval = Git::Approvals::Approval.new( approval_path, options )
      approval.diff( block.call ) do |err|
        ::RSpec::Expectations.fail_with err
      end
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
      parts = [ example, *example.example_group.parent_groups ].map do |ex|
        Git::Approvals::Utils.filenamify ex.description
      end
      File.join parts.to_a.reverse
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
