class Label < ApplicationRecord
  has_and_belongs_to_many :users
  validates :name, uniqueness: {
    scope: :color,
    message: 'A label already exists with that name and color.'
  }
end
