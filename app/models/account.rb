class Account < ActiveRecord::Base
  has_many :account_lines, dependent: :restrict

  validates_presence_of :name
end
