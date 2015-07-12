class AccountImportColumn < ActiveRecord::Base
  belongs_to :account_import

  validates_presence_of :account_import, :column_no, :column_type

  def self.column_types
    {
      t(".amount") => "amount",
      t(".text") => "text",
      t(".interest_at") => "interest_at",
      t(".booked_at") => "booked_at"
    }
  end
end
