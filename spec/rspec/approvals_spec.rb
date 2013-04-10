require 'spec_helper'
require 'rspec/approvals'

describe 'RSpec integration' do

  it 'provides the correct approval directory' do
    approval_directory.should == './spec/rspec/approvals_spec'
  end
  it 'provides the correct approval filename' do
    approval_filename.should == 'provides_the_correct_approval_filename'
  end
  it 'provides the correct approval path' do
    approval_path.should == './spec/rspec/approvals_spec/provides_the_correct_approval_path'
  end

  describe '#verify' do

    around do |example|
      # make the approvals directory
      `mkdir -p #{approval_directory}`
      # add some content to the file
      `echo "IT WERKS" > #{approval_path}`
      # add the file to the repo
      `git add #{approval_path}`
      # run the example
      example.run
      # clean up the file
      `git rm -rf #{approval_path}`
    end

    it 'passes when unchanged' do
      verify { "IT WERKS\n" }
    end
    it 'fails when changed' do
      expect { verify { "IT BROKE\n" } }.to raise_error( RSpec::Expectations::ExpectationNotMetError )
    end
  end
end
