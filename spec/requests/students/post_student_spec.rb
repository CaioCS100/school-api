require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'post a student route', type: :request do
  before do
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    post '/students', params: set_student_params, headers: @auth_params
  end

  it 'returns the student name' do
    expect(get_element_attribute(response, 'name')).to eq('Arthur')
  end

  it 'returns the father\'s name of student' do
    expect(get_element_attribute(response, 'father-name')).to eq('Pai do Arthur')
  end

  it 'returns the mother\'s name of student' do
    expect(get_element_attribute(response, 'mother-name')).to eq('Mãe do Arthur')
  end

  it 'returns the birth date of student' do
    expect(get_element_attribute(response, 'birth-date')).to eq('2000-12-12')
  end

  it 'returns the path of image of student if exist' do
    expect(get_element_attribute(response, 'image')).to eq(nil)
  end

  it 'returns a created status' do
    expect(response).to have_http_status(:created)
  end

  it 'return student not authenticated' do
    post '/students'

    expect(response).to have_http_status(:unauthorized)
  end

  it 'expect return 4 types of students errors' do
    post '/students', headers: @auth_params
    expect(element_size(response, 'errors')).to eq(4)
  end

  it 'return a unprocessable entity' do
    post '/students', headers: @auth_params

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

  def set_student_params
    {
      data: {
        type: 'students',
        'attributes': {
          name: 'Arthur',
          'father-name': 'Pai do Arthur',
          'mother-name': 'Mãe do Arthur',
          'birth-date': '2000-12-12'
        }
      }
    }
  end
end
