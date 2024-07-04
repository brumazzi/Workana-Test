class ApplicationController < ActionController::API
  def authorized
    @current_recruiter = nil
    decoded_token = decode_token(request.headers['Authorization'])
    if decoded_token
      recruiter_id = decoded_token[0]['recruiter_id']
      @current_recruiter = Recruiter.find_by(id: recruiter_id)
    end

    @current_recruiter
  end

  def decode_token(bear_token)
    if bear_token
      token = bear_token.split(' ')[1]
      JWT.decode(token, 'secret', true, algorithm: 'HS256')
    end
  end

  def set_access_deined_if_not_authorized
    unless authorized
      @status = 403
      @message = "Access Deined"
    else
      @status = 200
      @message = "OK"
    end
  end

end
