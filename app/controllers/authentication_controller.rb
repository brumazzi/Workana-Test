class AuthenticationController < ApplicationController
  def login
    recruiter = Recruiter.find_by(email: params[:email])

    if recruiter && recruiter.authenticate(params[:password])
      @token = encode_token(recruiter_id: recruiter.id)
      @status = 200
      @message = "OK"
    else
      @status = 403
      @message = 'Invalid email or password'
    end
  end

  def register
    recruiter = Recruiter.find_by_email(recruiter_params[:email])

    if recruiter.present?
      @status = 401
      @message = "e-mail has used"
    else
      recruiter = Recruiter.create_by_params(recruiter_params)
      if recruiter.nil?
        @status = 400
        @message = "Bad request"
      else
        @token = encode_token(recruiter_id: recruiter.id)
        @status = 200
        @message = "OK"
      end
    end
  end

  private

  def recruiter_params
    params.require(:data).permit(:name, :email, :password)
  end

  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end
end
