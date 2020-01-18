class Student < ApplicationRecord
  validates :name, presence: { message: 'This field is required' }
  validates :father_name, presence: { message: 'This field is required' }
  validates :mother_name, presence: { message: 'This field is required' }
  validates :birth_date, presence: { message: 'This field is required' }
end
