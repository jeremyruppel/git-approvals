require 'spec_helper'

describe Git::Approvals::Utils do

  describe '#filenameify' do
    {
      'Foo'     => 'foo',
      'Foo Bar' => 'foo_bar',
      'FooBar'  => 'foo_bar',
      '#foo'    => 'foo',
      'foo#'    => 'foo'
    }.each do |original, filename|
      it 'converts "%s" to "%s"' % [ original, filename ] do
        described_class.filenamify( original ).should == filename
      end
    end
  end
end
