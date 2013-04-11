require 'git/approvals/version'

module Git
  module Approvals
    autoload :Approval, 'git/approvals/approval'
    autoload :Utils,    'git/approvals/utils'
  end
end
