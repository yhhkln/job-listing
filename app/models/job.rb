class Job < ApplicationRecord
  belongs_to :user
  has_many :votes
  has_many :voters, through: :votes, source: :user

  has_many :favorites
  has_many :users, through: :favorites, source: :user

  has_many :resumes

  has_many :comments

  mount_uploader :image, ImageUploader

  has_many :photos
  accepts_nested_attributes_for :photos

  scope :published, -> { where(is_hidden: false)}
  scope :recent, -> { order('created_at DESC') }
  def publish!
    self.is_hidden = false
    self.save
  end
  def hide!
    self.is_hidden = true
    self.save
  end
  validates :title,            presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: {greater_than: 0}
  validates :wage_upper_bound, numericality: {greater_than_or_equal_to: :wage_lower_bound, message: "上限不高于下限，你玩呢！"}
  # validates :wage_lower_bound, numericality: {less_than_or_equal_to: :wage_upper_bound, message: "薪水下限不能高于薪水上限"}

end
