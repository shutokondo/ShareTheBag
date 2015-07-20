json.users @users do |user|
  json.name user.name
  json.avatar user.avatar if user.avatar
end