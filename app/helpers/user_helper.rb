module UserHelper
  def link_to_user(user)
    return "[#{t(".no_user")}]" unless user

    name_str = user.name
    if name_str.blank?
      name_str = user.username
    end

    if name_str.blank?
      name_str = "[#{t(".no_name")}]"
    end

    if can? :show, user
      link_to user.name, user_path(user)
    else
      user.name
    end
  end
end
