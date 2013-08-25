require 'git/approvals/version'

module Git
  module Approvals
    autoload :Approval,              'git/approvals/approval'
    autoload :AwesomePrintFormatter, 'git/approvals/awesome_print_formatter'
    autoload :HTMLFormatter,         'git/approvals/html_formatter'
    autoload :JSONFormatter,         'git/approvals/json_formatter'
    autoload :PlainFormatter,        'git/approvals/plain_formatter'
    autoload :SassFormatter,         'git/approvals/sass_formatter'
    autoload :UglifierFormatter,     'git/approvals/uglifier_formatter'
    autoload :Utils,                 'git/approvals/utils'
  end
end
