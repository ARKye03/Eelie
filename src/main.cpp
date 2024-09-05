#include "window.hpp"
#include <iostream>
#include <gtkmm.h>
#include <giomm.h>

void LoadCss(const std::string &css_path)
{
    auto css_provider = Gtk::CssProvider::create();
    try
    {
        css_provider->load_from_path(css_path);
        Gtk::StyleContext::add_provider_for_display(
            Gdk::Display::get_default(), css_provider, GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
    catch (const Gtk::CssParserError &ex)
    {
        std::cerr << "Error loading CSS file: " << ex.what() << std::endl;
    }
}

int main(int argc, char **argv)
{
    auto app = Gtk::Application::create("org.codeberg.ARKye03.Eelie");

    std::string css = Glib::getenv("HOME");
    css += "/.config/eelie/main.css";
    LoadCss(css);

    auto window = app->make_window_and_run<DockWindow>(argc, argv);

    return window;
}