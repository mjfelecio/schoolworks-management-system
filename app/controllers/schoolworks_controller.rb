class SchoolworksController < ApplicationController
  before_action :set_subjects, only: [ :edit, :new, :show ]
  before_action :set_schoolworks, only: [ :index ]
  before_action :set_schoolwork, only: [ :show, :edit ]

  def index
  end

  def show
    @notes = @schoolwork.notes
    @note = Note.new
  end

  def new
    @schoolwork = Schoolwork.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_schoolwork
    @schoolwork = Schoolwork.find(params[:id])
  end

  def set_schoolworks
    @schoolworks = Schoolwork.all
  end

  def set_subjects
    @subjects = Subject.all
  end
end
