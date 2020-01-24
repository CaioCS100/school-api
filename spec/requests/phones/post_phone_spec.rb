require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'post a phones route', type: :request do
  before do
    @student = FactoryBot.create(:random_student)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    post "/students/#{@student.id}/phone", params: set_phone_params, headers: @auth_params
  end

  it 'returns the created attributes of Phone' do
    expect(get_element_attribute(response, 'number')).to eq('999999999')
    expect(get_element_attribute(response, 'number-owner')).to eq('Home')
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end

  it 'return student not authenticated' do
    post "/students/#{@student.id}/phone", params: set_phone_params

    expect(response).to have_http_status(:unauthorized)
  end

  it 'expect return 2 types of addresses errors' do
    post "/students/#{@student.id}/phone", headers: @auth_params

    expect(element_size(response, 'errors')).to eq(2)
  end

  it 'return a unprocessable entity' do
    post "/students/#{@student.id}/phone", headers: @auth_params

    expect(response).to have_http_status(:unprocessable_entity)
  end

  private

  def get_element_attribute(response, attribute_name)
    parse_json(response)['data'][0]['attributes'][attribute_name]
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

  def set_phone_params
    {
      data: {
        type: 'phones',
        'attributes': {
          number: '999999999',
          'number-owner': 'Home'
        }
      }
    }
  end
end
