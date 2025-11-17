class SchoolworksController < ApplicationController
  def index
    @schoolworks = Schoolwork.all
  end

  def show
    @schoolwork = Schoolwork.find(params[:id])
    @notes = @schoolwork.notes
    @note = Note.new
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
