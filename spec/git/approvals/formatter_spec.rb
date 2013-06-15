require 'spec_helper'

shared_examples 'formatter' do |ext|
  let( :input  ){ File.read "./spec/fixtures/input#{ext}" }
  let( :output ){ "./spec/fixtures/output#{ext}" }

  it 'formats the input appropriately' do
    approval = Git::Approvals::Approval.new output
    approval.diff( input ){ |diff| fail diff }
  end
end

describe Git::Approvals::PlainFormatter do
  include_examples 'formatter', ''
end
describe Git::Approvals::JSONFormatter do
  include_examples 'formatter', '.json'
end
describe Git::Approvals::UglifierFormatter do
  include_examples 'formatter', '.js'
end
describe Git::Approvals::SassFormatter do
  include_examples 'formatter', '.css'
end
describe Git::Approvals::AwesomePrintFormatter do
  include_examples 'formatter', '.txt' do
    let( :input ){ { :foo => 'bar', :baz => [ 1, 2, 3 ] } }
  end
end
