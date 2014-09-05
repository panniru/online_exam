class InstructionsController < ApplicationController
  before_action :set_instruction, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /instructions
  def index
    page = params[:page].present? ? params[:page] : 1
    if params[:exam_id].present? and params[:exam_id] != 'all'
      @exam = Exam.find(params[:exam_id])
      @instructions = Instruction.belongs_to_all_and_exam(params[:exam_id]).paginate(:page => page)
    else
      @instructions = Instruction.all.paginate(:page => page)
    end
  end

  # GET /instructions/1
  def show
  end

  # GET /instructions/new
  def new
    @instruction = Instruction.new do |instruction|
      instruction.exam_id = params[:exam_id] if params[:exam_id].present?
    end
  end

  # GET /instructions/1/edit
  def edit
  end

  # POST /instructions
  def create
    @instruction = Instruction.new(instruction_params) do |inst|
      inst.defined_by = current_user.id
    end
    
    if @instruction.save
      redirect_to instructions_path(:exam_id => @instruction.exam_id), notice: 'Instruction was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /instructions/1
  def update
    if @instruction.update(instruction_params)
      redirect_to instructions_url(:exam_id => @instruction.exam_id), notice: 'Instruction was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /instructions/1
  def destroy
    exam_id = @instruction.exam_id
    @instruction.destroy
    redirect_to instructions_url(:exam_id => exam_id), notice: 'Instruction was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instruction
      @instruction = Instruction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def instruction_params
      params.require(:instruction).permit(:description, :exam_id, :defined_by)
    end
end
