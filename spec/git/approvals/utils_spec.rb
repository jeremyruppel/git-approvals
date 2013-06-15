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

  describe '#transform_filename' do
    {
      [ 'foo'                                 ] => 'foo',
      [ 'foo',         { :format => :json }   ] => 'foo.json',
      [ 'foo',         { :format => 'json' }  ] => 'foo.json',
      [ 'foo.txt',     { :format => :json }   ] => 'foo.json',
      [ 'foo',         { :filename => 'bar' } ] => 'bar',
      [ 'foo.txt',     { :filename => 'bar' } ] => 'bar.txt',
      [ 'foo/foo.txt', { :filename => 'bar' } ] => 'foo/bar.txt'
    }.each do |args, filename|
      example 'with %s' % [ args.inspect ] do
        described_class.transform_filename( *args ).should == filename
      end
    end
  end
end
