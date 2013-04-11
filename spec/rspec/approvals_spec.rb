require 'spec_helper'
require 'rspec/approvals'

describe 'RSpec integration' do

  it 'provides the correct approval directory' do
    approval_directory.should == './spec/rspec/approvals_spec'
  end
  it 'provides the correct approval filename' do
    approval_filename.should == 'rspec_integration/provides_the_correct_approval_filename'
  end
  it 'provides the correct approval path' do
    approval_path.should == './spec/rspec/approvals_spec/rspec_integration/provides_the_correct_approval_path'
  end

  describe '#verify' do
    # make sure to clean up any failed fixtures
    after { `git checkout #{approval_directory}` }

    it 'passes when unchanged' do
      verify { 'IT WERKS' }
    end
    it 'fails when changed' do
      expect { verify { 'IT BROKE' } }.to raise_error( RSpec::Expectations::ExpectationNotMetError )
    end
  end
end
