require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'delete a student route', type: :request do
  before(:each) do
    @student_one = FactoryBot.create(:random_student)
    @student_two = FactoryBot.create(:random_student)
  end

  it 'delete one student and expect http status no content' do
    delete "/students/#{@student_one.id}"

    expect(response).to have_http_status(:no_content)
  end

  it 'delete one student and check if exist another' do
    delete "/students/#{@student_one.id}"

    expect(response).to have_http_status(:no_content)

    get '/students'

    expect(element_size(response, 'data')).to eq(1)
    expect(get_first_data_attribute(response, 'name')).to eq(@student_two.name)
    expect(get_student_key(response)).to match_array(student_array_elements)
    expect(response).to have_http_status(:ok)
  end

  private

  def get_first_data_attribute(response, attribute_name)
    parse_json(response)['data'][0]['attributes'][attribute_name]
  end

  def element_size(response, attribute_name)
    parse_json(response)[attribute_name].length
  end

  def get_student_key(response)
    parse_json(response)['data'][0]['attributes'].keys
  end

  def parse_json(response)
    JSON.parse(response.body)
  end

  def student_array_elements
    %w[birth-date father-name image mother-name name]
  end
end
