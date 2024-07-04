require 'test_helper'

class RecruiterTest < ActiveSupport::TestCase
  test "the truth" do
    recruiter = Recruiter.new
    assert_not recruiter.valid?

    recruiter.name = "Recruiter"
    recruiter.email = "recruiter@mail.com"
    recruiter.password = "123456"
    recruiter.password_confirmation = "123456"

    assert recruiter.save

    # verify if recruiter exists and block
    recruiter = Recruiter.new

    recruiter.name = "Recruiter 2"
    recruiter.email = "recruiter@mail.com"
    recruiter.password = "123456"
    recruiter.password_confirmation = "123456"

    assert_not recruiter.save

    recruiter.email = "recruiter2@mail.com"
    assert recruiter.save
  end
end
