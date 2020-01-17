class StudentSerializer < ActiveModel::Serializer
  attributes :id, :name, :father_name, :mother_name, :birth_date, :image
end
