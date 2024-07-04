require 'test_helper'

class Public::JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    Recruiter.create(name: "Recruiter Test", email: "local@local.com", password: "123456", password_confirmation: "123456")
    job = Job.create(title: "Job", description: "Description", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)

    get(public_jobs_url, as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body["status"]}" if parsed_body["status"] != 200
    raise "Job not found" if parsed_body["data"].size.zero?
  end

  test "should get show but not found" do
    get(public_job_url(10), as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body["status"]}" if parsed_body["status"] != 404
  end

  test "should get show" do
    Recruiter.create(name: "Recruiter Test", email: "local@local.com", password: "123456", password_confirmation: "123456")
    job = Job.create(title: "Job", description: "Description", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)

    get(public_job_url(job.id), as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body}" if parsed_body["status"] != 200
  end

end
