require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  test "the truth" do
    recruiter = Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    job = Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)
    candidate = Candidate.create(name: "Candidate Test", email: "candidate@mail.com")

    submission = Submission.new
    assert_not submission.valid?
    submission.job_id = job.id
    submission.candidate_id = candidate.id
    assert submission.valid?
    assert submission.save

    submission = Submission.new
    submission.job_id = job.id
    submission.candidate_id = candidate.id
    assert_not submission.valid?

    assert true
  end
end
