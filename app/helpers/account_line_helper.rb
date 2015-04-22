module AccountLineHelper
  def link_to_account_line(account_line)
    link_to account_line.text, account_account_line_path(account_line.account, account_line)
  end
end
