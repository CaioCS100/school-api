class AddressesController < ApplicationController
  include ErrorSerializer

  before_action :set_student, only: [:show, :create, :update, :destroy]
  before_action :authenticate_login!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET students/1/address
  def show
    render json: @student.address.nil? ? {} : @student.address
  end

  # POST students/1/address
  def create
    @student.address = Address.new(address_params)

    if @student.save
      render json: @student.address, status: :created, location: student_address_path(@student)
    else
      render json: ErrorSerializer.serialize(@student.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT students/1/address
  def update
    if @student.address.update(address_params)
      render json: @student.address
    else
      render json: ErrorSerializer.serialize(@student.errors), status: :unprocessable_entity
    end
  end

  # DELETE students/1/address
  def destroy
    @student.address.destroy
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def address_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:id, :cep, :street,
      :number, :city, :uf, :complement, :student_id])
  end
end
