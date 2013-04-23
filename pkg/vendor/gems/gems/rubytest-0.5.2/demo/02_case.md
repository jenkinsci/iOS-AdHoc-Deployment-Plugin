## Defining a Test Case

Any object in a test suite that responds to #each, will be iterated over
and each entry run a test or another sub-case. For instance, given an abitrary
object defined as follows.

    test = Object.new

    def test.okay
      @okay
    end

    def test.call
      @okay = true
    end

And placed into an array.

    tests = [test]

If we pass this to a test runner as part of a test suite,

    runner = Test::Runner.new(:suite=>[tests], :format=>'test')

    success = runner.run

We will see that the test was called.

    test.assert.okay

And testing was successful.

    success.assert == true

