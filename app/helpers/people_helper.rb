module PeopleHelper
  def fat_level(person)
    class_name =
      if person.fat_alert?
        'text-danger'
      elsif person.thin_alert?
        'text-primary'
      else
        ''
      end
    tag.span person.fat_level, class: class_name
  end
end
