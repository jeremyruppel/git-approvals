require 'spec_helper'

describe Git::Approvals::Approval do

  describe 'initialize' do
    subject { described_class.new './foo/bar.txt' }

    its( :path    ){ should == './foo/bar.txt' }
    its( :options ){ should == { } }
  end

  describe '#diff' do
    subject { described_class.new './foo/bar.txt' }

    before { FileUtils.stub :mkdir_p => true }
    before { File.stub :open => true }

    it 'raises an exception when the file is not checked in' do
      Open3.should_receive( :capture2e ).with( 'git ls-files ./foo/bar.txt --error-unmatch' ) do
        [ '', double( 'status', :success? => false ) ]
      end
      expect { |block| subject.diff '', &block }.to raise_error( Errno::ENOENT, 'No such file or directory - ./foo/bar.txt' )
    end
    it 'calls the block when the file has been changed' do
      Open3.should_receive( :capture2e ).with( 'git ls-files ./foo/bar.txt --error-unmatch' ) do
        [ '', double( 'status', :success? => true ) ]
      end
      Open3.should_receive( :capture2e ).with( 'git diff --exit-code ./foo/bar.txt' ) do
        [ 'error verbatim', double( 'status', :success? => false ) ]
      end
      expect { |block| subject.diff '', &block }.to yield_with_args( 'error verbatim' )
    end
    it 'does nothing when the file has not been changed' do
      Open3.should_receive( :capture2e ).with( 'git ls-files ./foo/bar.txt --error-unmatch' ) do
        [ '', double( 'status', :success? => true ) ]
      end
      Open3.should_receive( :capture2e ).with( 'git diff --exit-code ./foo/bar.txt' ) do
        [ '', double( 'status', :success? => true ) ]
      end
      expect { |block| subject.diff '', &block }.not_to yield_control
    end
  end

  describe 'formats' do
    it 'verifies plain old strings' do
      # binding.pry
      approval = Git::Approvals::Approval.new './spec/fixtures/string.txt'
      approval.diff( 'IT WERKS' ){ |diff| fail diff }
    end
  end
end
