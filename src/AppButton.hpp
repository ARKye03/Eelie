#ifndef APPBUTTON_HPP
#define APPBUTTON_HPP

#include <gtkmm.h>
#include <giomm.h>

class AppButton : public Gtk::Button
{
public:
    AppButton(const std::string &app_name);

private:
    Glib::RefPtr<Gio::DesktopAppInfo> app_info;
    std::string app_name;
    Gtk::Image icon;
};

#endif // APPBUTTON_HPP