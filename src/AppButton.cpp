#include "AppButton.hpp"
#include <giomm.h>
#include <iostream> // Include iostream for std::cout

AppButton::AppButton(const std::string &app_name)
{
    this->app_name = app_name;
    this->app_info = Gio::DesktopAppInfo::create(app_name);
    if (this->app_info)
    {
        this->icon.set(this->app_info->get_icon());
    }
    icon.set_pixel_size(40);
    set_css_classes({"app_button"});
    set_child(icon);
    signal_clicked().connect(sigc::mem_fun(*this, &AppButton::on_button_clicked));
}

void AppButton::on_button_clicked()
{
    if (this->app_info)
    {
        auto actions = this->app_info->list_actions();
        if (!actions.empty())
        {
            this->app_info->launch_action(actions[0], NULL);
        }
    }
}