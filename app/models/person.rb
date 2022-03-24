class Person < ActiveRecord::Base
  include ActiveRecord::Bitemporal

  def name
    last_name + first_name
  end

  def age
    (Date.today.strftime('%Y%m%d').to_i - birth_date.strftime('%Y%m%d').to_i ) / 10000
  end

  def height_m
    height / 100
  end

  # BMI ＝ 体重kg ÷ (身長m)2
  # 適正体重 ＝ (身長m)2 ×22
  def bmi
    weight / (height_m)**2
  end
end
