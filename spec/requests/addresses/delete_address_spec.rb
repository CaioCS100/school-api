require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'delete a address route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
    @address = FactoryBot.create(:random_address)
    @login = FactoryBot.create(:create_login)
    @auth_params = sign_in
  end

  it 'delete address and expect http status no content' do
    delete "/students/#{@student.id}/address", headers: @auth_params

    expect(response).to have_http_status(:no_content)
  end

  it 'delete a address and check if exist student without address' do
    delete "/students/#{@student.id}/address", headers: @auth_params

    expect(response).to have_http_status(:no_content)

    get "/students/#{@student.id}", headers: @auth_params

    expect(get_address_data(response)).to eq(nil)
    expect(response).to have_http_status(:ok)
  end

  it 'delete a address of a non-existent student' do
    student = Student.last

    delete "/students/#{student.id + 1}/address", headers: @auth_params

    expect(response).to have_http_status(:not_found)
  end

  private

  def get_address_data(response)
    parse_json(response)['data']['relationships']['address']['data']
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
