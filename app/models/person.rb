class Person < ActiveRecord::Base
  include ActiveRecord::Bitemporal

  def name
    last_name + first_name
  end

  def age
    (Date.today.strftime('%Y%m%d').to_i - birth_date.strftime('%Y%m%d').to_i ) / 10000
  end
end
