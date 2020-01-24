require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'get a address route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @address = FactoryBot.create(:random_address)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    get "/students/#{@student.id}/address", headers: @auth_params
  end

  it 'returns student not authenticate' do
    get "/students/#{@student.id}/address"

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns address related to student' do
    expect(get_student_link(response)).to eq("/students/#{@student.id}")
  end

  it 'return a empty address' do
    student_two = FactoryBot.create(:random_student)
    get "/students/#{student_two.id}/address", headers: @auth_params

    expect(response.body).to eq('{}')
  end

  it 'should return data with address attributes' do
    expect(get_element_attribute(response, 'cep')).to be_present
    expect(get_element_attribute(response, 'street')).to be_present
    expect(get_element_attribute(response, 'number')).to be_present
    expect(get_element_attribute(response, 'city')).to be_present
    expect(get_element_attribute(response, 'uf')).to be_present
    expect(get_element_attribute(response, 'complement')).to be_present
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  def get_element_attribute(response, attribute_name)
    parse_json(response)['data']['attributes'][attribute_name]
  end

  def get_student_link(response)
    parse_json(response)['data']['relationships']['student']['links']['related']
  end

  def get_objects_size(response)
    parse_json(response)['data'].length
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
end
