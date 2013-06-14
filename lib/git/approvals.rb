require 'git/approvals/version'

module Git
  module Approvals
    autoload :Approval,              'git/approvals/approval'
    autoload :AwesomePrintFormatter, 'git/approvals/awesome_print_formatter.rb'
    autoload :JSONFormatter,         'git/approvals/json_formatter.rb'
    autoload :UglifierFormatter,     'git/approvals/uglifier_formatter.rb'
    autoload :Utils,                 'git/approvals/utils'
  end
end
