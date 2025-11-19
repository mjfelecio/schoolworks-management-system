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
    @schoolwork.destroy!
    @schoolwork_count = Schoolwork.count

    respond_to do |format|
      format.html { redirect_to :schoolworks, notice: "Schoolwork was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("schoolwork_#{@schoolwork.id}"),
            turbo_stream.replace("schoolwork_details", partial: "schoolworks/details_placeholder"),
            # TODO: Only replace with the no_schoolworks when count is zero after deletion
            # turbo_stream.replace("schoolworks_list_container", partial: "schoolworks/no_schoolworks"),
            turbo_stream.update("notice", "Schoolwork was successfully destroyed.")
          ]
        end
    end
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
