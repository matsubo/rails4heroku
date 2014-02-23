json.array!(@todos) do |todo|
  json.extract! todo, :id, :name
  json.url todo_url(todo, format: :json)
end
