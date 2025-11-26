class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    # Duplicate params so modifying them doesn't break the original hash
    q_params = params[:q]&.dup || {}

    # If "all" is selected → remove the predicate so Ransack doesn't apply it
    if q_params[:archived_status_eq] == "all"
      q_params.delete(:archived_status_eq)
    elsif q_params[:archived_status_eq].nil?
      q_params[:archived_status_eq] = "active"
    end

    @q = Subject.ransack(q_params)

    @q.sorts = "created_at desc" if @q.sorts.empty?

    @subjects = @q.result(distinct: true)
  end

  # GET /subjects/1 or /subjects/1.json
  def show
    respond_to do |format|
      format.html
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace(
              "subject_details",
              partial: "subjects/details",
              locals: { subject: @subject }
            ),
            turbo_stream.replace(
              "schoolwork_list_container",
              partial: "subjects/schoolworks",
              locals: { subject: @subject }
            )
          ]
        end
    end
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

    # Check if list was empty BEFORE creating
    @was_empty = Subject.count.zero?

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
    @subject.discard!

    # Check if list is empty AFTER deleting
    @subjects_empty = Subject.count.zero?

    respond_to do |format|
      format.html { redirect_to subjects_path, notice: "Subject was successfully archived.", status: :see_other }
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
