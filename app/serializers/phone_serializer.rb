class PhoneSerializer < ActiveModel::Serializer
  attributes :id, :number, :number_owner

  belongs_to :student do
    link(:related) { student_path(object.student.id) }
  end
end
