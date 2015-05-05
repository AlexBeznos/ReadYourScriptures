module ApplicationHelper
  def active_menu(menu_item)
    menu_item == controller_name ? 'active' : ''
  end
end
