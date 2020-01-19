class Student < ApplicationRecord
  validates :name, presence: { message: 'is required' }
  validates :father_name, presence: { message: 'is required' }
  validates :mother_name, presence: { message: 'is required' }
  validates :birth_date, presence: { message: 'is required' }

  has_one :address
  has_many :phones
end
