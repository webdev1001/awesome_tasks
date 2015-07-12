class Timelog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  belongs_to :invoiced_by_user, class_name: "User"

  has_one :project, through: :task
  has_many :invoice_lines, dependent: :restrict_with_error

  has_one :project, through: :task
  has_one :organization, through: :project

  validates_presence_of :task, :user
  validate :validate_time_set

  scope :not_invoiced, -> { where("timelogs.invoiced IS NULL OR timelogs.invoiced = 0") }
  scope :with_transport_length, -> { where("timelogs.transport_length > 0") }

  def hours
    Baza::Dbtime.new(time.strftime("%H:%M:%S")).hours_total if time
  end

  def hours_transport
    Baza::Dbtime.new(time_transport.strftime("%H:%M:%S")).hours_total if time_transport
  end

private

  def validate_time_set
    if hours == 0.0 && hours_transport == 0.0
      errors.add(:time, :is_blank_together_with_transport)
    end
  end
end
