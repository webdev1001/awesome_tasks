class Knjtasks::Email_check < Knj::Datarow
  def self.checked_id?(d, email_id_str)
    data = d.db.query("SELECT id FROM Email_check WHERE email_id_str = '#{d.db.esc(email_id_str)}' LIMIT 1").fetch
    return true if data
    return false
  end
end