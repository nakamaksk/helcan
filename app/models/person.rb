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

  def fat_level
    case bmi
    when 0...18.5
      '低体重'
    when 18.5...25
      '普通体重'
    when 25...30
      '肥満（１度）'
    when 30...35
      '肥満（２度）'
    when 35...40
      '肥満（３度）'
    else
      '肥満（４度）'
    end
  end

  def fat_alert?
    bmi >= 25
  end

  def thin_alert?
    bmi < 18.5
  end

  # 日毎の体重取得
  # https://github.com/kufu/activerecord-bitemporal
  # OK : bitemporal_id で検索を行う
  # MEMO: id = bitemporal_id なの
  #       find_by(bitemporal_id: employee.id)
  #       でも動作するが employee.bitemporal_id と書いたほうが意図が伝わりやすい
  def weights_by_day
    Person.ignore_valid_datetime
          .where(bitemporal_id: bitemporal_id)
          .group_by_day(:valid_from)
          .maximum(:weight)
  end

  def hoge
    puts 'hoge'
  end

  def piyo
    puts 'hoge'
  end

  def foo
    puts 'foo'
  end
end