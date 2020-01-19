class Address < ApplicationRecord
  belongs_to :student

  validates :cep, presence: { message: 'is required' }
  validates :street, presence: { message: 'is required' }
  validates :number, presence: { message: 'is required' }
  validates :city, presence: { message: 'is required' }
  validates :uf, presence: { message: 'is required' }
end
