class StudentsController < ApplicationController
  include ErrorSerializer

  before_action :set_student, only: [:show, :update, :destroy]
  before_action :authenticate_login!

  # GET /students
  def index
    render json: Student.all
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

  # Use callbacks to share common setup or constraints between actions.
  def set_student
    @student = Student.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def student_params
    params.require(:student).permit(:name, :father_name, :mother_name, :birth_date, :image)
  end
end
