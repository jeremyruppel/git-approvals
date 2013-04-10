require 'spec_helper'

describe Git::Approvals::Approval do

  describe '#filename' do
    it 'must be defined in subclasses' do
      expect { subject.filename }.to raise_error( NotImplementedError )
    end
  end

  describe '#dirname' do
    it 'must be defined in subclasses' do
      expect { subject.dirname }.to raise_error( NotImplementedError )
    end
  end

  describe '#diff' do
    before do
      dirname, filename = File.split __FILE__
      subject.stub :dirname  => dirname
      subject.stub :filename => filename
    end
    it 'raises an exception when the file does not exist' do
      expect { |block| subject.diff &block }.to raise_error( Errno::ENOENT )
    end
    it 'raises an exception when the file is not checked in' do
      expect { |block| subject.diff &block }.to raise_error( Errno::ENOENT )
    end
    it 'calls the block when the file has been changed' do

    end
    it 'does nothing when the file has not been changed' do

    end
  end
end
