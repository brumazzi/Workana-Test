class Submission < ApplicationRecord
  belongs_to :job
  belongs_to :candidate

  validates :job_id, uniqueness: { scope: :candidate_id }

  def self.create_by_params(recruiter, params)
    return nil if recruiter.jobs.find_by_id(params[:job_id].to_i).blank?

    submission = Submission.new
    submission.job_id = params[:job_id].to_i
    if params[:candidate_id].to_i != 0
      submission.candidate_id = params[:candidate_id]
    else
      candidate = Candidate.new
      candidate.name = params[:candidate][:name]
      candidate.email = params[:candidate][:email]
      candidate.mobile_phone = params[:candidate][:mobile_phone]
      candidate.resume = params[:candidate][:resume]
      return nil unless candidate.save

      submission.candidate_id = candidate.id
    end

    unless submission.save
      candidate.delete if params[:candidate_id].to_i == 0
    end

    submission
  end
end
