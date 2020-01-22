require 'rails_helper'
require_relative '../factory/factories.rb'

describe 'post a student route', type: :request do
  before do
    post '/students', params: get_params
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

  private

  def get_element_attribute(response, attribute_name)
    parsed_response = JSON.parse(response.body)
    parsed_response['data']['attributes'][attribute_name]
  end

  def get_params
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
