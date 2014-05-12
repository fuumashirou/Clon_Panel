module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s + "/" + association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, "#", class: "add_fields small button", data: { id: id, fields: fields.gsub("\n", "") })
  end

  def link_for(type, parent, model)
    if type == "edit"
      return link_to [type.to_sym, parent, model] do
        content_tag(:div, nil, class: type)
      end
    elsif type == "view"
      return link_to [parent, model] do
        content_tag(:div, nil, class: type)
      end
    elsif type == "delete" # En uso
      return link_to [parent, model], method: :delete, data: { confirm: "Estas seguro?" } do
        content_tag(:div, nil, class: type)
      end
    end
  end

  def timeago(time, options = {})
    options[:class] ||= "timeago"
    content_tag(:time, time.to_s, options.merge(datetime: time.getutc.iso8601)) if time
  end

end

class TrueClass
  def humanize
    I18n.t "boolean.yes", default: "Yes"
  end
end

class FalseClass
  def humanize
    I18n.t "boolean.no", default: "No"
  end
end

class String
  def to_boolean
    self.downcase == "true"
  end
end
