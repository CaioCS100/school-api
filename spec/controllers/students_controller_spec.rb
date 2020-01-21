require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  it 'This request should show all students in system' do
    get :index
    expect(response.status).to have_http_status(:ok)
  end
end
