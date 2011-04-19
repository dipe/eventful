module EventsHelper

  def attribute_detail(name, value)
    text = I18n.t("helpers.label.event.#{name}", :default => '').presence || Event.human_attribute_name(name)
    label = content_tag(:span, :class => "label") do
       text + ':'
    end
    content_tag(:p, :id => name) do
      label + " " + value
    end
  end

  def link_to_event_by_application_and_action(title, event)
    query = {
      :application => event.application,
      :controller => event.controller,
      :action => event.action
    }
    link_to(title, account_events_path({:query => query}))
  end

  def link_to_event_by_application_and_controller(title, event)
    query = {
      :application => event.application,
      :controller => event.controller
    }
    link_to(title, account_events_path({:query => query}))
  end

  def link_to_event_by_application_and_title(title, event)
    query = {
      :application => event.application,
      :title => event.title
    }
    link_to(title, account_events_path({:query => query}))
  end

  def link_to_event_by_application_and_node(title, event)
    query = {
      :application => event.application,
      :node => event.node
    }
    link_to(title, account_events_path({:query => query}))
  end
end
