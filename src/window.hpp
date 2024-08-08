#ifndef WINDOW_HPP
#define WINDOW_HPP

#include <gtkmm.h>
#include <string>

class DockWindow : public Gtk::Window
{
public:
    DockWindow();

private:
    Gtk::Box master_box;
    void LoadCss(const std::string &css_path);
};

#endif // WINDOW_HPP