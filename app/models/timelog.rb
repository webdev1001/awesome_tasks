class Timelog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  has_one :project, through: :task
  has_one :organization, through: :project

  validates_presence_of :task, :user

  scope :not_invoiced, ->{ where("timelogs.invoiced IS NULL OR timelogs.invoiced = 0") }

  def hours
    Baza::Dbtime.new(time.strftime("%H:%M:%S")).hours_total if time
  end

  def hours_transport
    Baza::Dbtime.new(time_transport.strftime("%H:%M:%S")).hours_total if time_transport
  end
end
