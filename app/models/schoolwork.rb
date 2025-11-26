class Schoolwork < ApplicationRecord
  include Discard::Model

  # Associations
  belongs_to :subject
  has_many :notes, dependent: :destroy
  has_many_attached :files

  # Enums
  enum :schoolwork_type, {
    assignment: 0,
    exam: 1,
    quiz: 2,
    project: 3,
    report: 4
  }

  enum :status, {
    not_started: 0,
    in_progress: 1,
    completed: 2,
    submitted: 3
  }

  enum :priority, {
    low: 0,
    medium: 1,
    high: 2
  }

  # Validations
  validates :title, presence: true
  validates :schoolwork_type, presence: true
  validates :status, presence: true
  validates :priority, presence: true
  validates :due_date, presence: { message: ->(object, data) { "is required for #{object.schoolwork_type} type" } }, if: :requires_due_date?
  validates :grade, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, allow_nil: true }

  validate :acceptable_files

  # Scopes
  scope :kept, -> { undiscarded.joins(:subject).merge(Subject.kept) } # Ensures that only those that schoolworks with archived Subject wont be shown
  scope :due_soon, -> { where("due_date <= ?", 3.days.from_now).where("due_date >= ?", Time.current) }
  scope :overdue, -> { where("due_date < ?", Time.current).where.not(status: [ :completed, :submitted ]) }
  scope :by_priority, -> { order(priority: :desc) }
  scope :by_due_date, -> { order(due_date: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :set_submitted_at, if: :will_save_change_to_status?

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "due_date", "grade", "id", "priority", "schoolwork_type", "status", "subject_id", "submitted_at", "title", "updated_at", "discarded_at", "archived_status" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "files_attachments", "files_blobs", "notes", "subject" ]
  end

  ransacker :title_or_description do
    Arel.sql("CONCAT(title, ' ', COALESCE(description, ''))")
  end

  ransacker :archived_status, formatter: proc { |value|
    case value
    when "active"   then 0
    when "archived" then 1
    end
  } do |parent|
    # status = active → discarded_at IS NULL
    # status = archived → discarded_at IS NOT NULL
    # status = all → no filtering (we handle this in controller)
    Arel.sql("CASE WHEN discarded_at IS NULL THEN 0 ELSE 1 END")
  end

  # Instance methods
  def kept?
    undiscarded? && subject.kept?
  end

  def overdue?
    due_date.present? && due_date < Time.current && !completed? && !submitted?
  end

  def due_soon?
    due_date.present? && due_date <= 3.days.from_now && due_date >= Time.current
  end

  def completed?
    status.in?(%w[completed submitted])
  end

  def progress_percentage
    case status
    when "not_started" then 0
    when "in_progress" then 50
    when "completed", "submitted" then 100
    else 0
    end
  end

  def status_badge_class
    case status
    when "not_started" then "badge-ghost"
    when "in_progress" then "badge-info"
    when "completed" then "badge-success"
    when "submitted" then "badge-primary"
    end
  end

  def priority_badge_class
    case priority
    when "low" then "badge-ghost"
    when "medium" then "badge-warning"
    when "high" then "badge-error"
    end
  end

  def requires_due_date?
    schoolwork_type.in?(%w[assignment exam quiz project])
  end

  private

  def acceptable_files
    return unless files.attached?

    acceptable_types = %w[
      application/pdf
      image/png
      image/jpeg
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.openxmlformats-officedocument.presentationml.presentation
      application/msword
      application/vnd.ms-powerpoint
    ]

    files.each do |file|
      unless file.byte_size <= 10.megabytes
        errors.add(:files, "#{file.filename} is too large (maximum is 10MB)")
      end

      unless acceptable_types.include?(file.content_type)
        errors.add(:files, "#{file.filename} must be PDF, Word, PowerPoint, or image")
      end
    end
  end

  def set_submitted_at
    if status == "submitted" && submitted_at.nil?
      self.submitted_at = Time.current
    elsif status != "submitted"
      self.submitted_at = nil
    end
  end
end
