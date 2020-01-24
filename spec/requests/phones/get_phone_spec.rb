require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'get a phone route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @phones = FactoryBot.create_list(:random_phone, 3)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    get "/students/#{@student.id}/phones", headers: @auth_params
  end

  it 'returns student not authenticate' do
    get "/students/#{@student.id}/phones"

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns all phones' do
    expect(get_objects_size(response)).to eq(3)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
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
