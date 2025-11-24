class NotesController < ApplicationController
  def create
    @note = Note.new(notes_params)
    if @note.save
      redirect_to :schoolworks, notice: "Note was successfully created."
    else
      redirect_to :schoolworks, alert: @note.errors.full_messages
    end
  end

  def update
  end

  def destroy
  end

  private

  def notes_params
    params.expect(note: [ :content ])
      .merge(schoolwork_id: params["schoolwork_id"])
  end
end
