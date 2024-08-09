#include "AppButton.hpp"
#include <giomm.h>
#include <iostream>
#include <cstdio> // Include cstdio for popen and pclose

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

bool AppButton::is_app_running(const std::string &app_name)
{
    std::string command = "pgrep -x " + app_name + " > /dev/null";
    int result = std::system(command.c_str());
    return result == 0;
}

void AppButton::on_button_clicked()
{
    if (this->app_info)
    {
        std::string exec = this->app_info->get_executable();
        if (is_app_running(exec))
        {
            std::cout << "Application " << exec << " is already running." << std::endl;
            return;
        }

        auto actions = this->app_info->list_actions();
        if (!actions.empty())
        {
            this->app_info->launch_action(actions[0], NULL);
        }
    }
}