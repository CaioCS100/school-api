require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'put a address route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @address = FactoryBot.create(:random_address)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    @address_object = {
      id: @address.id,
      cep: '59069330',
      street: 'Rua Doutor Costa Ribeiro',
      number: '121',
      city: 'Natal',
      uf: 'RG',
      complement: 'editando complemento'
    }
    @incorrect_address_object = {
      id: @address.id,
      cep: '',
      street: '',
      number: '',
      city: '',
      uf: '',
      complement: ''
    }
  end

  it 'update a address' do
    put "/students/#{@student.id}/address", params: set_address_params(@address_object),
                                            headers: @auth_params

    address_updated = Student.find(@student.id).address

    expect(response).to have_http_status(:ok)
    expect(address_updated.cep).to eq(@address_object[:cep])
    expect(address_updated.street).to eq(@address_object[:street])
    expect(address_updated.number).to eq(@address_object[:number].to_i)
    expect(address_updated.city).to eq(@address_object[:city])
    expect(address_updated.uf).to eq(@address_object[:uf])
    expect(address_updated.complement).to eq(@address_object[:complement])
  end

  it 'return user not found' do
    put '/students/30/address', params: set_address_params(@address_object),
                                headers: @auth_params

    expect(response).to have_http_status(:not_found)
  end

  it 'should return error of address update blank form request' do
    put "/students/#{@student.id}/address", headers: @auth_params

    expect(parse_json(response)['errors']).to eq('Please submit proper sign up data in request body.')
  end

  it 'return a unprocessable entity' do
    put "/students/#{@student.id}/address", params: set_address_params(@incorrect_address_object),
                                            headers: @auth_params

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'expect return 5 types of addresses errors' do
    put "/students/#{@student.id}/address", params: set_address_params(@incorrect_address_object), 
                                            headers: @auth_params

    expect(element_size(response, 'errors')).to eq(5)
  end

  private

  def get_element_attribute(response, attribute_name)
    parsed_response = JSON.parse(response.body)
    parsed_response['data']['attributes'][attribute_name]
  end

  def element_size(response, attribute_name)
    parse_json(response)[attribute_name].length
  end

  def parse_json(response)
    JSON.parse(response.body)
  end

  def sign_in
    post '/auth/sign_in', params: { email: @login.email, password: @login.password }

    auth_params = {
      'access-token' => response.headers['access-token'],
      'client' => response.headers['client'],
      'uid' => response.headers['uid'],
      'token_type' => response.headers['token-type']
    }

    auth_params
  end

  def set_address_params(address_object)
    {
      data: {
        id: address_object[:id],
        type: 'addresses',
        'attributes': {
          cep: address_object[:cep],
          street: address_object[:street],
          number: address_object[:number],
          city: address_object[:city],
          uf: address_object[:uf],
          complement: address_object[:complement]
        }
      }
    }
  end
end
