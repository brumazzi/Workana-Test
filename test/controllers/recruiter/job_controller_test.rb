require 'test_helper'

class Recruiter::JobControllerTest < ActionDispatch::IntegrationTest
  test "should get index without Autorization" do
    get(recruiters_jobs_url, as: :json)
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] == 200
  end

  test "should get index with Autorization" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    # test filter
    Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)
    Job.create(title: "Job 2", description: "Niban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "Python,Node", recruiter_id: Recruiter.last.id)
    Job.create(title: "Job 3", description: "Sanban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C++,Perl", recruiter_id: Recruiter.last.id)

    get(recruiters_jobs_url(params: { filter: { skills: "c,perl" } }), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
    raise "Query expect #{2} but receive #{parsed_body['data'].size}" if parsed_body["data"].size != 2

    get(recruiters_jobs_url(params: { filter: { description: "niban" } }), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
    raise "Query expect #{1} but receive #{parsed_body['data'].size}" if parsed_body["data"].size != 1
  end

  test "should get show without authorization" do
    get(recruiters_job_url(1), as: :json)
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 403
  end

  test "should get show but not found" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    get(recruiters_job_url(0), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 404
  end

  test "should get show" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    job = Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)

    get(recruiters_job_url(job), as: :json, headers: { "Authorization" => "Bear #{token}" })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
  end

  test "should get create without authorization" do
    post(recruiters_jobs_url, as: :json)
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 403
  end

  test "should get create" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    post(recruiters_jobs_url, as: :json, headers: { "Authorization" => "Bear #{token}" }, params: { data: { title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby" } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
  end

  test "should get update without authorization" do
    put(recruiters_job_url(0), as: :json)
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 403
  end

  test "should get update but not found" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    put(recruiters_job_url(0), as: :json, headers: { "Authorization" => "Bear #{token}" }, params: { data: { skills: "C,Ruby,Postgresql" } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 404
  end

  test "should get update" do
    Recruiter.create(name: "Recruiter Test", email: "recruiter@mail.com", password: "123456", password_confirmation: "123456")
    post(login_url, params: {email: "recruiter@mail.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)
    token = parsed_body["token"]
    raise "Access deined" if token.blank?

    job = Job.create(title: "Job 1", description: "Itchban", start_date: Time.now-1.day, end_date: Time.now+2.days, status: :active, skills: "C,Ruby", recruiter_id: Recruiter.last.id)

    put(recruiters_job_url(job), as: :json, headers: { "Authorization" => "Bear #{token}" }, params: { data: { skills: "C,Ruby,Postgresql" } })
    parsed_body = JSON.parse(response.body)
    raise "#{parsed_body['message']}" if parsed_body["status"] != 200
  end

end
