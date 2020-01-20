class Phone < ApplicationRecord
  belongs_to :student

  validates :number, presence: { message: 'is required' }
  validates :number_owner, presence: { message: 'is required' }
end
