class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    @subjects = Subject.all
  end

  # GET /subjects/1 or /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = Subject.new

    respond_to do |format|
      format.html
      format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "modal_container",
            partial: "subjects/form",
            locals: { subject: @subject }
          )
        end
    end
  end

  # GET /subjects/1/edit
  def edit
    respond_to do |format|
      format.html
      format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "modal_container",
            partial: "subjects/form",
            locals: { subject: @subject }
          )
        end
    end
  end

  # POST /subjects or /subjects.json
  def create
    @subject = Subject.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to :subjects, notice: "Subject was successfully created." }
        format.json { render :index, status: :created, location: @subject }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "modal_container",
            partial: "subjects/form",
            locals: { subject: @subject }
          )
        end
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: "Subject was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @subject }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "modal_container",
            partial: "subjects/form",
            locals: { subject: @subject }
          )
        end
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy!
    @subject_count = Subject.count

    respond_to do |format|
      format.html { redirect_to subjects_path, notice: "Subject was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = Subject.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subject_params
      params.expect(subject: [ :name, :description ])
    end
end
