class Subject < ApplicationRecord
  include Discard::Model

  has_many :schoolworks, dependent: :destroy

  validates :name, presence: true

  scope :alphabetical, -> { order(name: :asc) }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "description", "created_at", "discarded_at", "archived_status", "id" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "schoolworks" ]
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

  # Helper method for stats
  def schoolwork_stats
    {
      total: schoolworks.count,
      not_started: schoolworks.not_started.count,
      in_progress: schoolworks.in_progress.count,
      completed: schoolworks.completed.count,
      submitted: schoolworks.submitted.count,
      overdue: schoolworks.overdue.count
    }
  end

  def completion_percentage
    total = schoolworks.count
    return 0 if total.zero?

    completed = schoolworks.where(status: [ :completed, :submitted ]).count
    (completed.to_f / total * 100).round
  end
end
