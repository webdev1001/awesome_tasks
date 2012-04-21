args = {
  "host" => $validate_login["_SERVER"]["HTTP_HOST"]
}

if $validate_login["_SERVER"]["HTTPS"] or $validate_login["_SERVER"]["HTTP_SSL_ENABLED"]
  args["ssl"] = true
  args["port"] = 443
  args["validate"] = false
end

http = Knj::Http.new(args)
http.cookies["KnjappserverSession"] = $validate_login["_COOKIE"]["KnjappserverSession"]
data = http.get("/?show=users_login")

if data["data"].to_s.index("<form method=\"post\" action=\"?show=user_login") == nil
  print JSON.generate(
    "Enabled" => true
  )
else
  print JSON.generate(
    "Enabled" => false
  )
end
