
class DashboardController < ApplicationController
  def index
    # Alert counts
    @overdue_count = Schoolwork.overdue.count
    @due_soon_count = Schoolwork.due_soon.count

    # Stats for stat cards
    @total_schoolworks = Schoolwork.count
    @completed_count = Schoolwork.where(status: [ :completed, :submitted ]).count
    @in_progress_count = Schoolwork.in_progress.count
    @subjects_count = Subject.count

    # Upcoming schoolwork (next 7 days, not completed)
    @upcoming_schoolworks = Schoolwork
      .where("due_date >= ? AND due_date <= ?", Time.current, 7.days.from_now)
      .where.not(status: [ :completed, :submitted ])
      .includes(:subject)
      .order(due_date: :asc)
      .limit(5)

    # Recent activity (last 5 updated)
    @recent_schoolworks = Schoolwork
      .includes(:subject)
      .order(updated_at: :desc)
      .limit(5)

    # Subject progress stats
    @subjects_with_stats = Subject
      .left_joins(:schoolworks)
      .select(
        "subjects.*",
        "COUNT(schoolworks.id) as total_count",
        "COUNT(CASE WHEN schoolworks.status IN (2, 3) THEN 1 END) as completed_count"
      )
      .group("subjects.id")
      .order(name: :asc)
      .limit(6)

    # Priority distribution
    @priority_counts = Schoolwork
      .where.not(status: [ :completed, :submitted ])
      .group(:priority)
      .count
  end
end
