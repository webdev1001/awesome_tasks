class UserRole < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :role
  validates_uniqueness_of :role, scope: :user
  validate :validate_role

  def self.translated_roles
    {
      _("Administrator") => "administrator",
      _("Organization administrator") => "organization_administrator"
    }
  end

  def translated_role
    UserRole.translated_roles.each do |title, role_i|
      return title if role_i == role.to_s
    end

    return ""
  end

private

  def validate_role
    errors.add(:role, _("is not allowed: %{role}", role: role)) unless UserRole.translated_roles.values.include?(role.to_s)
  end
end
