json.users @followers do |user|
  json.avatar user.avatar
  json.name user.name
end