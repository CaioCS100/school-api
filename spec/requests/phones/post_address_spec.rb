require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'post a address route', type: :request do
  before do
    @student = FactoryBot.create(:random_student)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    post "/students/#{@student.id}/address", params: set_address_params, headers: @auth_params
  end

  it 'returns the building cep' do
    expect(get_element_attribute(response, 'cep')).to eq('57055000')
  end

  it 'returns the building street' do
    expect(get_element_attribute(response, 'street')).to eq('Av. Fernandes Lima')
  end

  it 'returns the building number' do
    expect(get_element_attribute(response, 'number')).to eq(12)
  end

  it 'returns the name of the city where the address is located' do
    expect(get_element_attribute(response, 'city')).to eq('Maceió')
  end

  it 'returns the Address uf' do
    expect(get_element_attribute(response, 'uf')).to eq('AL')
  end

  it 'returns the Address complement' do
    expect(get_element_attribute(response, 'complement')).to eq('É uma avenida')
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end

  it 'return student not authenticated' do
    post "/students/#{@student.id}/address", params: set_address_params

    expect(response).to have_http_status(:unauthorized)
  end

  it 'should return 5 errors' do
    post "/students/#{@student.id}/address", headers: @auth_params
    expect(element_size(response, 'errors')).to eq(5)
  end

  it 'return a unprocessable entity' do
    post "/students/#{@student.id}/address", headers: @auth_params

    expect(response).to have_http_status(:unprocessable_entity)
  end

  private

  def get_element_attribute(response, attribute_name)
    parse_json(response)['data']['attributes'][attribute_name]
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

  def set_address_params
    {
      data: {
        type: 'addresses',
        'attributes': {
          cep: '57055000',
          street: 'Av. Fernandes Lima',
          number: '12',
          city: 'Maceió',
          uf: 'AL',
          complement: 'É uma avenida'
        }
      }
    }
  end
end
