class Idea < ActiveRecord::Base
  belongs_to :category
  has_many :idea_images
  has_many :images, through: :idea_images
  accepts_nested_attributes_for :images, allow_destroy: true
end
