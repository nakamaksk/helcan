json.extract! person, :id, :last_name, :first_name, :birth_date, :height, :weight, :body_fat, :created_at, :updated_at
json.url person_url(person, format: :json)
