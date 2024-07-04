class Public::JobsController < ApplicationController
  def index
    @jobs = Job.active.filter_by_valid_date.filter_by_params(jobs_filter)
    @status = 200
    @message = "OK"
  end

  def show
    @job = Job.active.filter_by_valid_date.where(id: params[:id].to_i).last
    unless @job.blank?
      @status = 200
      @message = "OK"
    else
      @status = 404
      @message = "Not found"
    end
  end

  private

  def jobs_filter
    return {} if params[:filter].blank?
    params.require(:filter).permit(:title, :description, :status, :skills)
  end
end
