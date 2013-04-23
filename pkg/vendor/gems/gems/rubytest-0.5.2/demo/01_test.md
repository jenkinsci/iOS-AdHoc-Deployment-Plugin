## Defining a Test

Any object in a test suite that responds to #call, will be executed as
a test. For instance, given an abtriray object defined as follows.

    test = Object.new

    def test.okay
      @okay
    end

    def test.call
      @okay = true
    end

If we pass this to a test runner as part of a test suite,

    runner = Test::Runner.new(:suite=>[test], :format=>'test')

    success = runner.run

We will see that the test was called.

    test.assert.okay

And testing was successful.

    success.assert == true

