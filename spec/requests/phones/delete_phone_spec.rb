require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'delete a phone route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @phones = FactoryBot.create_list(:random_phone, 2)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
  end

  it 'delete phone and expect http status no content' do
    delete "/students/#{@student.id}/phone/#{@phones.sample.id}", headers: @auth_params

    expect(response).to have_http_status(:no_content)
  end

  it 'delete a phone and check if exist student with one phone' do
    delete "/students/#{@student.id}/phone/#{@phones.sample.id}", headers: @auth_params

    expect(response).to have_http_status(:no_content)

    get "/students/#{@student.id}", headers: @auth_params

    expect(element_size(response, 'data')).to eq(1)
    expect(response).to have_http_status(:ok)
  end

  it 'delete a phone of a non-existent student' do
    student = Student.last

    delete "/students/#{student.id + 1}/phone/#{@phones.sample.id}", headers: @auth_params

    expect(response).to have_http_status(:not_found)
  end

  private

  def get_address_data(response)
    parse_json(response)['data']['relationships']['address']['data']
  end

  def element_size(response, attribute_name)
    parse_json(response)['data']['relationships']['phones'][attribute_name].length
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
