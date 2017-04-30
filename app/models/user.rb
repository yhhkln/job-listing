class User < ApplicationRecord
  has_many :jobs
  has_many :resumes
  has_many :comments

  has_many :votes
  has_many :voted_jobs, :through => :votes, :source => :job

  has_many :favorites
  has_many :jobs, through: :favorites, source: :job

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  def admin?
    is_admin
  end
  def is_voter_of?(job)
    voted_jobs.include?(job)
  end
  def upvote!(job)
    voted_jobs << job
  end
  def downvote!(job)
    voted_jobs.delete(job)
  end
end
