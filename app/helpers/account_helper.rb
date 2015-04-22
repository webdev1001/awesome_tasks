module AccountHelper
  def link_to_account(account)
    link_to account.name, account_path(account)
  end
end
