json.extract! person, :id, :first_name, :last_name, :age, :height, :weight, :body_fat, :created_at, :updated_at
json.url person_url(person, format: :json)
