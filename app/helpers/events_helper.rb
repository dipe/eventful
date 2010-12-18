module EventsHelper

  def attribute_detail(name, value)
    label = content_tag(:span, :class => "label") do
      Event.human_attribute_name(name) + ':'
    end
    content_tag(:p, :id => name) do
      label + " " + value
    end
  end
end
