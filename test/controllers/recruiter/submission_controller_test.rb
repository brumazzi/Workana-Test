require 'test_helper'

class Recruiter::SubmissionControllerTest < ActionDispatch::IntegrationTest
  # test "should get show" do
  #   get recruiter_submission_show_url
  #   assert_response :success
  # end

  # test "should get create" do
  #   get recruiter_submission_create_url
  #   assert_response :success
  # end

  test "should get create without autorization" do
    post(recruiters_submissions_url, as: :json, params: { data: { } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 403
  end

  test "should get create but invalid" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    post(recruiters_submissions_url, as: :json, headers: { "Authorization" => "Bear #{token}" }, params: { data: { candidate: { name: "Candidate", email: "candidate@mail.com" } } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 400
  end

  test "should get create" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    job = Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)

    post(recruiters_submissions_url, as: :json, headers: { "Authorization" => "Bear #{token}" }, params: { data: { job_id: job.id, candidate: { name: "Candidate", email: "candidate@mail.com" } } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
  end

  test "should get show without autorization" do
    get(recruiters_submission_url(0), as: :json)
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 403
  end

  test "should get show but invalid" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    get(recruiters_submission_url(0), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 404
  end

  test "should get show" do
    recruiter = Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    job = Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)
    submission = Submission.create_by_params(recruiter, { job_id: job.id, candidate: { name: "Candiate", email: "candidate@mail.com" } })
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    get(recruiters_submission_url(submission.id), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
  end

end
