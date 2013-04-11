require 'spec_helper'

describe Git::Approvals::Utils do

  describe '#filenameify' do
    {
      'Foo'     => 'foo',
      'Foo Bar' => 'foo_bar'
    }.each do |original, filename|
      it 'converts "%s" to "%s"' % [ original, filename ] do
        described_class.filenamify( original ).should == filename
      end
    end
  end
end
