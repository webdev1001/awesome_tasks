class Organization < ActiveRecord::Base
  has_many :projects, dependent: :restrict_with_error
  has_many :invoices, dependent: :restrict_with_error
  has_many :creditor_invoices, dependent: :restrict_with_error, foreign_key: :creditor_id, class_name: "Invoice"

  validates :email, email: true, allow_blank: true

  scope :customers, -> { where(customer: true) }
  scope :creditors, -> { where(creditor: true) }
end
