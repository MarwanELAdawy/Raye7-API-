# Model Trip
class Trip < ApplicationRecord
  validates :departure_time, :seats, presence: true
  belongs_to :group, optional: true
  belongs_to :source, class_name: 'Place'
  belongs_to :destination, class_name: 'Place'
  has_many :places
  belongs_to :driver, class_name: 'User'
  has_many :guests
  has_many :users, through: :guests
  has_many :users
end