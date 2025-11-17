class SchoolworksController < ApplicationController
  before_action :set_subjects, only: [ :edit, :new, :create, :show ]
  before_action :set_schoolwork, only: [ :show, :edit, :update, :destroy ]

  def index
      @schoolworks = Schoolwork.all
  end

  def show
    @note = Note.new
  end

  def new
    @schoolwork = Schoolwork.new
  end

  def create
    @schoolwork = Schoolwork.new(schoolwork_params)

    respond_to do |format|
      if @schoolwork.save
        format.html { redirect_to :schoolworks, notice: "Schoolwork was successfully created." }
        format.json { render :index, status: :created, location: @schoolwork }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @schoolwork.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @schoolwork.update(schoolwork_params)
        format.html { redirect_to @schoolwork, notice: "Schoolwork was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @schoolwork }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @schoolwork.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private

    def set_schoolwork
      @schoolwork = Schoolwork.find(params[:id])
    end

    def set_subjects
      @subjects = Subject.all
    end

    def schoolwork_params
      params.expect(schoolwork: [
        :files,
        :schoolwork_type,
        :title,
        :description,
        :due_date,
        :status,
        :priority,
        :grade,
        :submitted_at,
        :subject_id,
        files: []
      ])
    end
end
