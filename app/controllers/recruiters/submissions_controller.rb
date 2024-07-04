class Recruiters::SubmissionsController < ApplicationController
  before_action :set_access_deined_if_not_authorized

  def show
    @success = false
    if @current_recruiter
      @submission = @current_recruiter.submissions.find_by_id(params[:id])
      if @submission.blank?
        @status = 404
        @message = "Not found"
      else
        @success = true
      end
    end
  end

  def create
    @success = false
    if @current_recruiter
      @submission = Submission.create_by_params(@current_recruiter, submission_params)
      if @submission.blank?
        @status = 400
        @message = "Bad request"
      else
        @success = true
      end
    end
  end

  private

  def submission_params
    params.require(:data).permit(:job_id, :candidate_id, candidate: [:name, :email, :mobile_phone, :resume])
  end
end
