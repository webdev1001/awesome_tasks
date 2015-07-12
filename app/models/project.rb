class Project < ActiveRecord::Base
  belongs_to :user_added, class_name: "User"
  belongs_to :organization

  has_many :tasks, dependent: :restrict_with_error
  has_many :user_project_links, dependent: :destroy
  has_many :users, through: :user_project_links
  has_many :project_autoassigned_users, dependent: :destroy
  has_many :autoassigned_users, through: :project_autoassigned_users, source: :user

  validates_presence_of :organization

  state_machine :state, initial: :active do
    event :activate do
      transition [:finished, :inactive] => :active
    end

    event :deactivate do
      transition :active => :inactive
    end

    event :finish do
      transition [:active, :inactive] => :finished
    end
  end

  def self.translated_states
    return {
      t(".active") => "active",
      t(".inactive") => "inactive",
      t(".finished") => "finished"
    }
  end

  def translated_state
    Project.translated_states.each do |title, state_i|
      return title if state_i == state.to_s
    end

    return ""
  end
end
