# Ruby Test

[Homepage](http://rubyworks.github.com/rubytest) /
[User Guide](http://wiki.github.com/rubyworks/rubytest) /
[Development](http://github.com/rubyworks/rubytest) /
[Issues](http://github.com/rubyworks/rubytest/issues)

## Description

Ruby Test is a universal test harness for Ruby that can be used by any Ruby
test framework. Ruby Test defines a simple specification for compliance, which
allows tests from various frameworks to all run 

Ruby Test defines a straight-forward specification that any test framework can 
easily support which allows Ruby Test to run the frameworks tests through a
single uniform user interface in a single pass.

## Specification

The universal access point for testing is the `$TEST_SUITE` global array. A test
framework need only add compliant test objects to `$TEST_SUITE`. 
Ruby Test will iterate through these objects. If a test object responds to
`#call`, it is run as a test procedure. If it responds to `#each` it is iterated
over as a test case with each entry handled in the same manner. All test 
objects must respond to `#to_s` so their description can be used in test
reports.

Any raised exception that responds to `#assertion?` in the affirmative is taken
to be a failed assertion rather than simply an error. Ruby Test extends the
Exception class to support this method for all exceptions.

A test framework may raise a `NotImplementedError` to have a test recorded
as *todo* --a _pending_ exception to remind the developer of tests that still
need to be written. The `NotImplementedError` is a standard Ruby exception
and a subclass of `ScriptError`. The exception can also set a priority level
to indicate the urgency of the pending test. Priorities of -1 or lower
will generally not be brought to the attention of testers unless explicitly 
configured to do so.

That is the crux of Ruby Test specification. Ruby Test supports some
additional features that can makes its usage even more convenient.
See the [Wiki](http://github.com/rubyworks/test/wiki) for further details.


## Usage

There are a few ways to run tests. First, there is a command line tool:

    $ rubytest

The command line tool takes various options, use `--help` to see them.
Be sure to load in your test framework or framework's Ruby Test adapter.

Preconfigurations can be defined in a `.test` file, e.g.

    Test.run 'default' do |r|
      r.format = 'progress'
      r.requires << 'lemon'
      r.files << 'test/*_case.rb'
    end

There is also a 'rubytest/autorun.rb' library script that can be loaded which
creates an `at_exit` runner, for which `test.rb` provides a nice shortcut:

    $ ruby -r test

There is also a Rake task.

    require 'rubytest/rake'

    Test::Rake::TestTask.new

A Detroit plugin is in the works and should be available soon.


## Installation

Ruby Test is available as Gem package.

    $ gem install rubytest


## Requirements

Ruby Test uses the [ANSI](http://rubyworks.github.com/ansi) gem for color output.

Because of the "foundational" nature of this library we will look at removing
this dependencies for future versions, but for early development the 
requirements does the job and does it well.


## Development

Ruby Test is still a "nuby" gem. Please feel OBLIGATED to help improve it ;-)

Ruby Test is a [RubyWorks](http://rubyworks.github.com) project. If you can't
contribue code, you can still help out by contributing to our development fund.


## Reference Material

[1] [Standard Definition Of Unit Test](http://c2.com/cgi/wiki?StandardDefinitionOfUnitTest)


## Copyrights

Copyright (c) 2011 Rubyworks

Made available according to the terms of the <b>FreeBSD license</b>.

See NOTICE.md for details.

