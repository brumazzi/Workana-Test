require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "login with non exist recruiter" do
    post(login_url(params: {email: "test@local.com", password: "123456"}), as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body["status"]}" if parsed_body["status"] == 200
  end

  test "register recruiter" do
    post(register_url, params: {data: { name: "Recruiter Test", email: "test@local.com", password: "123456" }}, as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body["status"]}" unless parsed_body["status"] == 200
  end

  test "login with exist recruiter" do
    post(register_url, params: {data: { name: "Recruiter Test", email: "test@local.com", password: "123456" }}, as: :json)
    post(login_url, params: {email: "test@local.com", password: "123456"}, as: :json)

    parsed_body = JSON.parse(response.body)

    raise "#{parsed_body["status"]}" unless parsed_body["status"] == 200
  end
end
