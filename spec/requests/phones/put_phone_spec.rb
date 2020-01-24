require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'put a phones route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @phone = FactoryBot.create(:random_phone)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    @phone_object = {
      id: @phone.id,
      number: '999999999',
      'number-owner': 'Home'
    }
    @incorrect_phone_object = {
      id: @phone.id,
      number: '',
      'number-owner': ''
    }
  end

  it 'update a phone' do
    put "/students/#{@student.id}/phone", params: set_phone_params(@phone_object),
                                           headers: @auth_params

    phone_updated = Phone.find(@phone.id)

    expect(response).to have_http_status(:ok)
    expect(phone_updated.number).to eq(@phone_object[:number])
    expect(phone_updated.number_owner).to eq(@phone_object[:'number-owner'])
  end

  it 'return user not found' do
    last_student = Student.last
    put "/students/#{last_student.id + 1}/phone", params: set_phone_params(@phone_object),
                                                  headers: @auth_params

    expect(response).to have_http_status(:not_found)
  end

  it 'should return error of phone update blank form request' do
    put "/students/#{@student.id}/phone", headers: @auth_params

    expect(parse_json(response)['errors']).to eq('Please submit proper sign up data in request body.')
  end

  it 'return a unprocessable entity' do
    put "/students/#{@student.id}/phone", params: set_phone_params(@incorrect_phone_object),
                                          headers: @auth_params

    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'expect return 2 types of phones errors' do
    put "/students/#{@student.id}/phone", params: set_phone_params(@incorrect_phone_object), 
                                          headers: @auth_params

    expect(element_size(response, 'errors')).to eq(2)
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

  def set_phone_params(phone_object)
    {
      data: {
        id: phone_object[:id],
        type: 'phones',
        'attributes': {
          number: phone_object[:number],
          'number-owner': phone_object[:'number-owner']
        }
      }
    }
  end
end
