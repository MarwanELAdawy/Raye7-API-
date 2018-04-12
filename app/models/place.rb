# Model Place
class Place < ApplicationRecord
  validates :name, :longitude, :latitude, presence: true
  has_many :trips
end