class AddressSerializer < ActiveModel::Serializer
  attributes :id, :cep, :street, :number, :city, :uf, :complement
  has_one :student
end
