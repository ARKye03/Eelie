#include "AppButton.hpp"
#include <giomm.h>
#include <iostream>
#include <cstdio>
#include <libgen.h>

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
    // Extract the base name of the executable
    char *app_name_copy = strdup(app_name.c_str());
    std::string base_name = basename(app_name_copy);
    free(app_name_copy);

    std::string command = "pgrep -x " + base_name + " > /dev/null";
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
            auto launch_context = Gio::AppLaunchContext::create();
            try
            {
                std::vector<Glib::RefPtr<Gio::File>> files; // Create an empty list of files
                this->app_info->launch(files, launch_context);
            }
            catch (const Glib::Error &ex)
            {
                std::cerr << "Failed to launch application: " << ex.what() << std::endl;
            }
        }
    }
}