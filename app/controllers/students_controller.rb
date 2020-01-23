class StudentsController < ApplicationController
  include ErrorSerializer

  before_action :set_student, only: [:show, :update, :destroy]
  before_action :authenticate_login!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /students
  def index
    page_number = params[:page] ? params[:page][:number] : 1
    per_page = params[:page] ? params[:page][:size] : 5

    render json: Student.all.page(page_number).per(per_page)
  end

  # GET /students/1
  def show
    render json: @student
  end

  # POST /students
  def create
    @student = Student.new(student_params)

    if @student.save
      render json: @student, status: :created, location: @student
    else
      render json: ErrorSerializer.serialize(@student.errors), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /students/1
  def update
    if @student.update(student_params)
      render json: @student
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  def destroy
    @student.destroy
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def student_params
    # :father_name, :mother_name, :birth_date
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: [:id, :name,
          :"father-name", :"mother-name", :"birth-date", :image])
  end
end
