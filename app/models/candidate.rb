class Candidate < ApplicationRecord
  has_many :submissions

  validates :name, :email, presence: true
  validates :email, uniqueness: true
end
