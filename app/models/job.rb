class Job < ApplicationRecord
  enum status: [:active, :inactive]

  belongs_to :recruiter

  has_many :submissions

  validates :title, :description, presence: true

  before_save ->() { self.status = :active if self.status.nil? }

  scope :filter_by_params, ->(params) {
    query = all
    params.each do |key, value|
      if key.to_s == "skills"
        skills_split = value.split(',').map { |v| "%#{v}%" }
        query_sql = "lower(jobs.skills) like lower(?)" + " or lower(jobs.skills) like lower(?) "*(skills_split.size-1)
        query = query.where(query_sql, *skills_split)
      else
        query = query.where("lower(jobs.#{key}) like ?", "%#{value.downcase}%") if value.is_a? String
      end
    end
    query
  }

  scope :filter_by_valid_date, -> () { where("start_date <= ? and end_date >= ?", Time.now, Time.now) }
end
