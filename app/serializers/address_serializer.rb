class AddressSerializer < ActiveModel::Serializer
  attributes :id, :cep, :street, :number, :city, :uf, :complement

  has_one :student do
    link(:related) { student_path(object.student.id) }
  end
end
