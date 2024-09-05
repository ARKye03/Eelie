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
    Gtk::Box hide_box;
    Gtk::Box show_box;
};

#endif // WINDOW_HPP