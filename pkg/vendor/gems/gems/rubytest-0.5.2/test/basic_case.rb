test = Object.new

def test.call
end

def test.to_s
  "Basic Test"
end

$TEST_SUITE << test

