json.items @items do |item|
  json.title  item.title
  json.store  item.store
  json.description  item.description
  json.user_id  item.user_id
end