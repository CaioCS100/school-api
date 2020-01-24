require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'get a student route', type: :request do
  let!(:students) { FactoryBot.create_list(:random_student, 5) }

  before(:each) do
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
    get '/students', headers: @auth_params
  end

  it 'returns student not authenticate' do
    get '/students'

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns all students' do
    expect(get_objects_size(response)).to eq(5)
  end

  it 'returns one students' do
    student = Student.all.sample

    get "/students/#{student.id}", headers: @auth_params

    expect(get_id(response)).to eq(student.id.to_s)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end

  def get_id(response)
    parse_json(response)['data']['id']
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
