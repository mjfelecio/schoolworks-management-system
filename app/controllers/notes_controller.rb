class NotesController < ApplicationController
  def create
    @note = Note.new(notes_params)
    schoolwork = Schoolwork.find(notes_params[:schoolwork_id])

    # Check if list was empty BEFORE creating
    @was_empty = Note.count.zero?

    respond_to do |format|
      if @note.save
        format.html { redirect_to :subjects }
        format.json { render :index, status: :created, location: @note }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("notes_list", partial: "notes/note", locals: { note: @note }),
            turbo_stream.replace("notes_form", partial: "notes/form", locals: { schoolwork:, note: Note.new })
          ]
        end
      else
        format.html { redirect_to :schoolworks, alert: @note.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @note.errors.full_messages, status: :unprocessable_entity }
      end
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
