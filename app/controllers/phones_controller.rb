class PhonesController < ApplicationController
  include ErrorSerializer
  
  before_action :set_student, only: [:show, :create, :update, :destroy]

  # GET students/1/phones
  def show
    render json: @student.phones
  end

  # POST students/1/phone
  def create
    @student.phones << Phone.new(phone_params)

    if @student.save
      render json: @student.phones, status: :created, location: student_phone_path(@student)
    else
      render json: ErrorSerializer.serialize(@student.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT students/1/phone
  def update
    phone = Phone.find(phone_params[:id])

    if phone.update(phone_params)
      render json: @student.phones
    else
      render json: ErrorSerializer.serialize(phone.errors), status: :unprocessable_entity
    end
  end

  # DELETE students/1/phone
  def destroy
    Phone.find(phone_params[:id]).destroy
  end

  private

  def set_student
    @student = Student.find(params[:student_id])
  end

  def phone_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:id, :number,
        :number_owner, :student_id])
  end
end
