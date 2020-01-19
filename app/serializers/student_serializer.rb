class StudentSerializer < ActiveModel::Serializer
  attributes :id, :name, :father_name, :mother_name, :birth_date, :image

  link(:self) { student_path(object) }

  has_one :address do
    link(:related) { student_address_path(object) }
  end

  has_many :phones do
    link(:related) { student_path(object) }
  end
end
