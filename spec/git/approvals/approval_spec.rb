require 'spec_helper'

describe Git::Approvals::Approval do

  describe '#initialize' do
    context 'straight up' do
      subject { described_class.new 'foo/bar.txt' }
      its( :path ){ should == 'foo/bar.txt' }
    end
    context 'with options' do
      subject { described_class.new 'foo/bar.txt', :format => :json, :filename => 'baz' }
      its( :path ){ should == 'foo/baz.json' }
    end
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

  describe 'Tilt mappings' do
    subject { Tilt.mappings }
    it { should include( ''     => [ Git::Approvals::PlainFormatter ] ) }
    it { should include( 'txt'  => [ Git::Approvals::AwesomePrintFormatter ] ) }
    it { should include( 'css'  => [ Git::Approvals::SassFormatter ] ) }
    it { should include( 'json' => [ Git::Approvals::JSONFormatter ] ) }
    it { should include( 'js'   => [ Git::Approvals::UglifierFormatter ] ) }
  end

  describe 'formats' do
    it 'formats strings' do
      approval = described_class.new './spec/fixtures/string.txt'
      approval.diff( 'IT WERKS' ){ |diff| fail diff }
    end
    it 'formats arrays' do
      approval = described_class.new './spec/fixtures/array.txt'
      approval.diff( [ :foo, :bar, :baz ] ){ |diff| fail diff }
    end
    it 'formats hashes' do
      approval = described_class.new './spec/fixtures/hash.txt'
      approval.diff( { :foo => 'bar', :quux => 'bar' } ){ |diff| fail diff }
    end
    it 'formats json' do
      approval = described_class.new './spec/fixtures/hash.json'
      approval.diff( '{"foo":"bar","baz":"quux"}' ){ |diff| fail diff }
    end
    it 'formats javascript' do
      approval = described_class.new './spec/fixtures/asset.js'
      approval.diff( <<-EOS ){ |diff| fail diff }
      // Comments are preserved
      (function(){return {status:"IT WERKS"};})();
      EOS
    end
    it 'formats css' do
      approval = described_class.new './spec/fixtures/asset.css'
      approval.diff( <<-EOS ){ |diff| fail diff }
      // Comments are preserved
      html,body{font-family:"Helvetica Neue";}
      EOS
    end
  end
end
