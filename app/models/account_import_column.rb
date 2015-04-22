class AccountImportColumn < ActiveRecord::Base
  belongs_to :account_import

  validates_presence_of :account_import, :column_no, :column_type

  def self.column_types
    {
      _("Amount") => "amount",
      _("Text") => "text",
      _("Interest at") => "interest_at",
      _("Booked at") => "booked_at"
    }
  end
end
