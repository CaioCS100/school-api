require 'rails_helper'
require_relative '../../factory/factories.rb'

describe 'put a student route', type: :request do
  before(:each) do
    @student = FactoryBot.create(:random_student)
  end

  it 'update a student' do
    student_object = {
      id: @student.id,
      name: 'Junior',
      'father-name': 'Pai do Junior',
      'mother-name': 'Mãe do Junior',
      'birth-date': '2010-01-30'
    }

    put "/students/#{@student.id}", params: set_student_params(student_object)

    select_updated = Student.find(@student.id)

    expect(response).to have_http_status(:ok)
    expect(select_updated.name).to eq(student_object[:name])
    expect(select_updated.father_name).to eq(student_object[:'father-name'])
    expect(select_updated.mother_name).to eq(student_object[:'mother-name'])
    expect(select_updated.birth_date).to eq(student_object[:'birth-date'].to_date)
  end

  it 'return a not found' do
    student_object = {
      id: @student.id,
      name: 'Junior',
      'father-name': 'Pai do Junior',
      'mother-name': 'Mãe do Junior',
      'birth-date': '2010-01-30'
    }

    put '/students/30', params: set_student_params(student_object)

    expect(response).to have_http_status(:not_found)
  end

  it 'return a unprocessable entity' do
    student_object = {
      id: @student.id,
      name: '',
      'father-name': '',
      'mother-name': '',
      'birth-date': ''
    }

    put "/students/#{@student.id}", params: set_student_params(student_object)

    expect(response).to have_http_status(:unprocessable_entity)
  end

  private

  def get_element_attribute(response, attribute_name)
    parsed_response = JSON.parse(response.body)
    parsed_response['data']['attributes'][attribute_name]
  end

  def set_student_params(student_object)
    {
      data: {
        id: student_object[:id],
        type: 'students',
        'attributes': {
          name: student_object[:name],
          'father-name': student_object[:'father-name'],
          'mother-name': student_object[:'mother-name'],
          'birth-date': student_object[:'birth-date']
        }
      }
    }
  end
end
