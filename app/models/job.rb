class Job < ApplicationRecord
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
  validates :wage_lower_bound, numericality: { greater_than: 0}
end
