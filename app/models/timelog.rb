class Timelog < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  belongs_to :invoiced_by_user, class_name: "User"

  has_one :project, through: :task
  has_many :invoice_lines, dependent: :restrict_with_error

  validates_presence_of :task, :user

  scope :not_invoiced, ->{ where("timelogs.invoiced IS NULL OR timelogs.invoiced = 0") }
end
