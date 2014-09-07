class UserReferences
  def initialize args
    @args = args
  end

  def parse_user_references
    replaces = {}

    @args[:text].scan(/(\[(.+?)\])/) do |match|
      key, username = match[0], match[1].strip
      next if replaces.key?(key)

      user = User.where(username: username).first
      next unless user

      replaces[key] = "[[USER:#{user.id}]]"
    end

    new_text = @args[:text]
    replaces.each do |key, val|
      new_text = new_text.gsub(key, val)
    end

    return new_text
  end

  def unparse_user_references args = {}
    replaces = {}

    @args[:text].scan(/(\[\[USER:(\d+)\]\])/) do |match|
      key, user_id = match[0], match[1].to_i
      next if replaces.key?(key)

      user = User.where(id: user_id).first
      next unless user

      if args[:html]
        replaces[key] = "<a href=\"/users/#{user.id}\">#{CGI.escape_html(user.username)}</a>"
      else
        replaces[key] = "[#{user.username}]"
      end
    end

    new_text = @args[:text]
    replaces.each do |key, val|
      new_text = new_text.gsub(key, val)
    end

    return new_text
  end
end
