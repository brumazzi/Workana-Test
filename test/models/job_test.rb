require 'test_helper'

class JobTest < ActiveSupport::TestCase
  test "the truth" do
    recruiter = Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    job = Job.new

    assert_not job.valid?
    job.title = "Title"
    assert_not job.valid?
    job.description = "qwerty"
    assert_not job.valid?
    job.recruiter_id = recruiter.id
    assert job.valid?

    assert job.save
  end
end
