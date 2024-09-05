#include "window.hpp"
#include "AppButton.hpp"
#include "gtk4-layer-shell.h"
#include <giomm.h>
#include <iostream>
#include <unordered_map>

DockWindow::DockWindow()
{
    gtk_layer_init_for_window(GTK_WINDOW(gobj()));
    gtk_layer_set_layer(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_LAYER_TOP);

    gtk_layer_set_margin(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_TOP, 10);
    // gtk_layer_set_margin(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_BOTTOM, 10);

    gtk_layer_set_anchor(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_BOTTOM, true);

    master_box.set_homogeneous(true);
    master_box.set_spacing(10);
    master_box.set_css_classes({"master_box"});
    master_box.set_visible(false);

    auto show_controller = Gtk::EventControllerMotion::create();
    show_controller->signal_enter().connect([this](double x, double y)
                                            {
                                                master_box.set_visible(true);
                                                gtk_layer_set_exclusive_zone(GTK_WINDOW(gobj()), -1); });

    Gtk::Box hide_box(Gtk::Orientation::VERTICAL);
    hide_box.set_css_classes({"event_box"});
    hide_box.append(master_box);

    auto hide_controller = Gtk::EventControllerMotion::create();
    hide_controller->signal_leave().connect([this]()
                                            {
                                                master_box.set_visible(false);
                                                gtk_layer_set_exclusive_zone(GTK_WINDOW(gobj()), 0); });

    auto show_box = Gtk::Box();
    show_box.set_css_classes({"mbox"});
    hide_box.append(show_box);
    hide_box.set_valign(Gtk::Align::END);
    show_box.add_controller(show_controller);
    hide_box.add_controller(hide_controller);

    std::unordered_map<std::string, int> dictionary;
    dictionary["thunar.desktop"] = 0;
    dictionary["discord.desktop"] = 1;
    dictionary["code.desktop"] = 2;
    dictionary["brave-browser.desktop"] = 3;

    for (auto &[key, value] : dictionary)
    {
        auto app_button = Gtk::make_managed<AppButton>(key);
        master_box.append(*app_button);
    }
    set_title("Dock");
    set_name("dockpp");
    gtk_layer_set_namespace(GTK_WINDOW(gobj()), "dockpp");

    std::string css = Glib::getenv("HOME");
    css += "/.config/eelie/main.css";

    LoadCss(css);
    set_child(hide_box);
}

void DockWindow::LoadCss(const std::string &css_path)
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