class Account < ActiveRecord::Base
  has_many :account_lines, dependent: :restrict_with_error

  validates_presence_of :name
end
