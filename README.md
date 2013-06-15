# Git::Approvals

Simple git-powered approval tests.

[![Build Status](https://travis-ci.org/jeremyruppel/git-approvals.png)](https://travis-ci.org/jeremyruppel/git-approvals)
[![Coverage Status](https://coveralls.io/repos/jeremyruppel/git-approvals/badge.png?branch=master)](https://coveralls.io/r/jeremyruppel/git-approvals?branch=master)

## Installation

Add this line to your application's Gemfile:

    gem 'git-approvals'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-approvals

## Background

[Approval tests][approvaltests] are a testing device popularized by Llewellyn Falco. The basic premise of an approval test is that the subject under test is captured and written to a file, thereby "approving" it. The test assertion is literally a diff of the approved file (expected) with the subject under test (actual). If there is a diff, the test fails because the result does not match the approved file.

For a more comprehensive background and use cases, see [this blog post][blog] I've written on the subject of approval tests.

**Git::Approvals** leverages `git` as a backend to make approval testing simple and the workflow familiar. Your project doesn't necessarily have to be version controlled by `git` to work, but the approved files must. This library assumes  a basic working knowledge of how to use `git`.

## Usage

### Standalone

You can use approval tests manually in Ruby if you wish. Suppose you have a file named `foo/bar.txt` that contains the string "baz". The `Approval#diff` method takes a string and a block. It will shell out to `git` and will diff the given string with the file and will call the block if there is a diff or an error occurs.

``` ruby
approval = Git::Approvals::Approval.new 'foo/bar.txt'
approval.diff( "baz" ){ |err| puts "fail" } # nothing
approval.diff( "qux" ){ |err| puts "fail" } # "fail"
```

The constructor method also accepts a hash of options, which are explained below.

### RSpec Integration

In your `spec_helper.rb` or wherever, simply `require 'rspec/approvals'`. You can now use the `verify` expectation in your specs:

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

The `verify` method accepts the same options hash as the Approval constructor.

### Options

The following options are supported:

- `:format`: specifies the format to use when writing out the approved file. The format is inferred from the extension of the approved file, but if you specify it here, it will change the extension to match. This option accepts any extension that is registered with [tilt][tilt].
- `:filename`: specifies the filename of the approved file.

### Formatters

**Git::Approvals** uses [tilt][tilt] to write out approved files, so any template format that tilt supports can be used. **Git::Approvals** adds the following formats in addition to the standard tilt templates:

- `txt` writes out a ruby object using [awesome_print][awesomeprint].
- `json` pretty-prints a json string using the standard JSON library.
- `js` pretty-prints JavaScript source using [uglifier][uglifier].
- `css` pretty-prints CSS source using [SASS][sass].

The format will be determined by checking the `:format` key of the options hash, then the extension of the approved filename, and finally will default to `txt`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[blog]: http://jeremyruppel.tumblr.com/post/52734828127/committed-for-your-approval
[tilt]: https://github.com/rtomayko/tilt
[approvaltests]: http://approvaltests.sourceforge.net/
[awesomeprint]: https://github.com/michaeldv/awesome_print
[uglifier]: https://github.com/lautis/uglifier
[sass]: https://github.com/nex3/sass
