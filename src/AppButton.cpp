#include "AppButton.hpp"
#include <giomm.h>

AppButton::AppButton(const std::string &app_name)
{
    this->app_name = app_name;
    this->app_info = Gio::DesktopAppInfo::create(app_name);
    if (this->app_info)
    {
        this->icon.set(this->app_info->get_icon());
    }
    set_child(icon);
    signal_clicked().connect([this]()
                             {
        if (this->app_info)
        {
            auto actions = this->app_info->list_actions();
            if (!actions.empty())
            {
                this->app_info->launch_action(actions[0], NULL);
            }
        } });
}