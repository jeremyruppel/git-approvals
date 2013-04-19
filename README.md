# Git::Approvals

Simple git-powered approval tests.

## Installation

Add this line to your application's Gemfile:

    gem 'git-approvals'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-approvals

## Usage

>  TODO describe standalone usage

### With RSpec

In your spec_helper.rb or wherever, simply `require 'rspec/approvals'`.
Now you can use the `verify` expectation in your specs:

`spec/foo_spec.rb`

``` ruby
require 'spec_helper'

describe Foo do

  example 'bar' do
    verify { Foo.bar }
  end
end
```

The result of `Foo.bar` will be written to `spec/foo_spec/foo/bar.txt`.
The test will fail because the file is not checked in to your git repo,
meaning you haven't approved it yet, so add it to approve it:

`git add spec/foo_spec/foo_bar.txt`

Another test run shows that the test now passes. On the next test run, the
same file will be written out. If git says the file has changed, the
test will fail.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
