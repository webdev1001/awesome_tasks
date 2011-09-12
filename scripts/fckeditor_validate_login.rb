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
  print Knj::Php.json_encode(
    "Enabled" => true
  )
else
  print Knj::Php.json_encode(
    "Enabled" => false
  )
end