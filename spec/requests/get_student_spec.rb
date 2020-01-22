require 'rails_helper'
require_relative '../factory/factories.rb'

describe 'get students route', type: :request do
  let!(:students) { FactoryBot.create_list(:random_student, 5) }

  before { get '/students' }

  it 'returns all students' do
    parsed_response = JSON.parse(response.body)
    expect(parsed_response['data'].length).to eq(5)
  end

  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end
