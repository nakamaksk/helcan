class Person < ActiveRecord::Base
  include ActiveRecord::Bitemporal

  def name
    last_name + first_name
  end
end
