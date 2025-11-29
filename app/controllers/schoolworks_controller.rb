class SchoolworksController < ApplicationController
  before_action :set_subjects, only: [ :edit, :new, :create, :show ]
  before_action :set_schoolwork, only: [ :show, :edit, :update, :destroy, :remove_file, :restore ]

  def index
    q_params = params[:q]&.dup || {}

    # If "all" is selected → remove the predicate so Ransack doesn't apply it
    if q_params[:archived_status_eq] == "all"
      q_params.delete(:archived_status_eq)
    elsif q_params[:archived_status_eq].nil?
      q_params[:archived_status_eq] = "active"
    end

    @q = Schoolwork.joins(:subject).ransack(q_params)
    @q.sorts = "created_at desc" if @q.sorts.empty?
    @schoolworks = @q.result(distinct: true)
  end

  def show
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
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @schoolwork.errors, status: :unprocessable_content }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @schoolwork.update(schoolwork_params)
        @schoolwork.files.attach(params[:files])
        format.html { redirect_to :schoolworks, notice: "Schoolwork was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @schoolwork }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @schoolwork.errors, status: :unprocessable_content }
      end
    end
  end

  def destroy
    @was_archived = true if @schoolwork.kept?

    # Archive at first, then delete if already archived
    @schoolwork.kept? ? @schoolwork.discard : @schoolwork.destroy!

    @schoolworks_empty = Schoolwork.count.zero?

    respond_to do |format|
      format.html { redirect_to :schoolworks, notice: "Schoolwork was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
      format.turbo_stream
    end
  end

  def remove_file
    file = @schoolwork.files.find(params[:file_id])
    file.purge

    respond_to do |format|
      format.html { redirect_to :schoolworks, notice: "File was successfully destroyed.", status: :ok }
      format.json { status :ok }
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("attachments_list", partial: "schoolworks/attachments_list", locals: { schoolwork: @schoolwork }),
            turbo_stream.update("notice", "File was successfully destroyed.")
          ]
        end
    end
  end

  def restore
    @schoolwork.undiscard

    respond_to do |format|
        format.html { redirect_to @schoolwork, notice: "Schoolwork was successfully restored.", status: :see_other }
        format.json { render :show, status: :ok, location: @schoolwork }
        format.turbo_stream
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
        :file_id,
        files: []
      ])
    end
end
