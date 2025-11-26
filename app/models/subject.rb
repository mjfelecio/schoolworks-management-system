class Subject < ApplicationRecord
  include Discard::Model

  has_many :schoolworks, dependent: :destroy

  validates :name, presence: true

  scope :alphabetical, -> { order(name: :asc) }

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "name", "description", "created_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "schoolworks" ]
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
