class Recruiter < ApplicationRecord
    has_secure_password

    has_many :jobs
    has_many :submissions, through: :jobs
    has_many :candidates, through: :submissions

    validates :name, :email, :password_digest, presence: true
    validates :email, uniqueness: true

    def self.create_by_params(params)
        recruiter = Recruiter.new({
            name: params["name"],
            email: params["email"],
            password: params["password"],
            password_confirmation: params["password"]
        })

        return recruiter if recruiter.save
        return nil
    end
end
