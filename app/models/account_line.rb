class AccountLine < ActiveRecord::Base
  belongs_to :account
  belongs_to :invoice

  validates_presence_of :account
end
