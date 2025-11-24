class NotesController < ApplicationController
  before_action :set_note, only: [ :edit, :update, :destroy ]

  def create
    @note = Note.new(note_params)
    schoolwork = Schoolwork.find(note_params[:schoolwork_id])

    # Check if list was empty BEFORE creating
    @was_empty = Note.count.zero?

    respond_to do |format|
      if @note.save
        format.html { redirect_to :schoolworks }
        format.json { render :index, status: :created, location: @note }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("notes_list", partial: "notes/note", locals: { note: @note }),
            turbo_stream.replace("notes_form", partial: "notes/form", locals: { schoolwork: schoolwork, note: Note.new })
          ]
        end
      else
        format.html { redirect_to :schoolworks, alert: @note.errors.full_messages, status: :unprocessable_entity }
        format.json { render json: @note.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def edit
    notes = @note.schoolwork.notes.order(updated_at: :desc)
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(
            "notes_list",
            partial: "notes/list",
            locals: { notes: notes }
          ),
          # Replace the note with editing variant
          turbo_stream.replace(
            "note_#{@note.id}",
            partial: "notes/note_editing",
            locals: { note: @note }
          ),
          turbo_stream.replace(
            "notes_form",
            partial: "notes/form",
            locals: { schoolwork: @note.schoolwork, note: @note }
          )
        ]
      end
    end
  end

  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("note_#{@note.id}"),
            turbo_stream.prepend(
              "notes_list",
              partial: "notes/note",
              locals: { note: @note }
            ),
            turbo_stream.replace(
              "notes_form",
              partial: "notes/form",
              locals: { schoolwork: @note.schoolwork, note: @note.schoolwork.notes.build }
            )
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend(
              "note_#{@note.id}",
              partial: "notes/note",
              locals: { note: @note }
            ),
            turbo_stream.replace(
              "notes_form",
              partial: "notes/form",
              locals: { schoolwork: @note.schoolwork, note: @note }
            )
          ]
        end
      end
    end
  end

  def destroy
    @note.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove("note_#{@note.id}")
        ]
      end
    end
  end

  private

  def set_note
    @note = Note.find(params.expect(:id))
  end

  def note_params
    params.expect(note: [ :content ])
      .merge(schoolwork_id: params["schoolwork_id"])
  end
end
