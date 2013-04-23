# RELEASE HISTORY

## 0.5.2 / 2012-07-20

Courtier was renamed to RC. And the previous release overlooked the requirement
on RC altogether. This release corrects the issue making it optional. 

Changes:

* Make RC an optional requirement.


## 0.5.1 / 2012-04-30

This release adds support for Courtier-based confgiration.
You can now add `config 'rubytest'` entries into a project's
Config.rb file, instead of creating a separate stand-alone
config file just for test configuration.

Changes:

* Adds support for Courtier-based configuration.


## 0.5.0 / 2012-03-22

This release improves the command line interface, the handling of
configuration and provides a mechinism for adding custom test 
observers. The later can be used for things like mock library
verifcation steps.

Changes:

* Make CLI an actual class.
* Refactor configuration file lookup and support Confection.
* Add customizable test observer via new Advice class.


## 0.4.2 / 2012-03-04

Minor release to fix detection of pre-existance of Exception core
extensions.

Changes:

* Fix detection of Exception extension methods.


## 0.4.1 / 2012-02-27

RubyTest doesn't necessarily need to require 'brass' --albeit in the future
that might end up being a dependency. For now we'll leave it aside.

Changes:

* Remove requirement on brass.


## 0.4.0 / 2012-02-25

This release primarily consists of implementation tweaks. The most significant
change is in support of exception priorities, which justify the major verison bump.

Changes:

* Add preliminary support for exception priorities.
* Capture output for TAP-Y/J reporters.


## 0.3.0 / 2011-12-22

Technically this is a fairly minor release that improves backtrace output
and prepares the `LOAD_PATH` automtically if a `.ruby` file is present.
However, it is significant in that the name of the gem has been changed
from `test` to `rubytest`.

Changes:

* Change gem name to `rubytest`.
* Improve backtrace filtering in reporters.
* Setup `LOAD_PATH` based on .ruby file if present.


## 0.2.0 / 2011-08-10

With this release Ruby Test is essentially feature complete. Of course there
are plenty of tweaks and improvements yet to come, but Ruby Test is fully usable
at this point. Only one major aspect of the design remains in question --the
way per-testcase "before and after all" advice is handled. Other than that
the API fairly solid, even as this early state of development. Always helps
when you have a spec to go by!

Changes:

* Use Config class to look-up .test file.
* Support hard testing, topic and pre-case setup.
* Add autorun.rb runner script.
* Add a test reporter to use for testing Ruby Test itself.
* Improved dotprogess reporter's handling of omissions.
* Add unit selection to test runner.


## 0.1.0 / 2011-07-30

First release of Ruby Test.

Changes:

* It's Your Birthday!

