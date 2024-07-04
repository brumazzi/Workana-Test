require 'test_helper'

class CandidateTest < ActiveSupport::TestCase
  test "the truth" do
    candidate = Candidate.new
    assert_not candidate.valid?

    candidate.name = "Candidate"
    candidate.email = "candidate@mail.com"

    assert candidate.save

    # verify if candidate exists and block
    candidate = Candidate.new

    candidate.name = "Candidate 2"
    candidate.email = "candidate@mail.com"

    assert_not candidate.save

    candidate.email = "candidate2@mail.com"
    assert candidate.save
  end
end
