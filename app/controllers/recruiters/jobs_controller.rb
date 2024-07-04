class Recruiters::JobsController < ApplicationController
  before_action :set_access_deined_if_not_authorized

  def index
    @jobs = @current_recruiter.jobs.filter_by_params(jobs_filter) if @current_recruiter
  end

  def show
    if @current_recruiter
      @job = @current_recruiter.jobs.find_by_id(params[:id])
      if @job.blank?
        @status = 404
        @message = "Not found"
      end
    end
  end

  def create
    @success = false
    if @current_recruiter
      @job = Job.new(
        title: job_params[:title],
        description: job_params[:description],
        start_date: job_params[:start_date],
        end_date: job_params[:end_date],
        status: job_params[:status],
        skills: job_params[:skills],
        recruiter_id: @current_recruiter.id
      )

      unless @job.save
        @status = 400
        @message = "Bad request"
      else
        @success = true
      end
    end
  end

  def update
    @success = false
    if @current_recruiter
      @job = Job.find_by_id(params[:id])
      if @job.blank?
        @status = 404
        @message = "Not found"
      elsif !@job.update(**job_params)
        @status = 400
        @message = "Bad request"
      else
        @success = true
      end
    end
  end

  private

  def jobs_filter
    params.require(:filter).permit(:title, :description, :status, :skills)
  end

  def job_params
    params.require(:data).permit(:title, :description, :start_date, :end_date, :status, :skills)
  end
end
