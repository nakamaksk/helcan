# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

if Rails.env.development? || Rails.env.test?
  # テスト用データ
  person = Person.where(
    last_name: "test",
    first_name: "taro",
  ).first

  if person.nil?
    Timecop.freeze("2022/01/01") do
      person = Person.create(
        last_name: "test",
        first_name: "taro",
        birth_date: '1990-01-01',
        weight: 70.0,
        height: 170,
        body_fat: 20.0,
        goal: '7/31までに65kgまで減量する！'
        )
      end
  end

  # 毎日、-2.0, -1.5 .. 2.0の体重差で登録する
  INCREASE_AND_DECREASE_WIGHTS = (-2.0..2.0).step(0.5).map.to_a

  ("2022/01/02".to_date.."2022/01/31".to_date).each do |date|
    Timecop.freeze(date) do
      person.update(weight: person.weight + INCREASE_AND_DECREASE_WIGHTS.sample)
    end
  end
end
