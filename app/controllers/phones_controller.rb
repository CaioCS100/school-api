class PhonesController < ApplicationController
  include ErrorSerializer

  before_action :set_student, only: [:show, :create, :update, :destroy]
  before_action :authenticate_login!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET students/1/phones
  def show
    render json: @student.phones.nil? ? {} : @student.phones
  end

  # POST students/1/phone
  def create
    phone = Phone.new(phone_params)
    phone.student_id = @student.id

    if phone.save
      render json: @student.phones, status: :created, location: student_phone_path(@student)
    else
      render json: ErrorSerializer.serialize(phone.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT students/1/phone
  def update
    if params.key?(:data) && params[:data][:id].present? && params[:data][:attributes].present?
      phone = Phone.find(phone_params[:id])

      if phone.update(phone_params)
        render json: @student.phones
      else
        render json: ErrorSerializer.serialize(phone.errors), status: :unprocessable_entity
      end
    else
      render json: {errors: 'Please submit proper sign up data in request body.'}, status: :unprocessable_entity
    end
  end

  # DELETE students/1/phone
  def destroy
    Phone.find(params[:id]).destroy
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def phone_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:id, :number,
        :"number-owner", :student_id])
  end
end
