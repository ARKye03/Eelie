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

    auto hide_controller = Gtk::EventControllerMotion::create();
    hide_controller->signal_leave().connect([this]()
                                            {
        master_box.set_visible(false);
        gtk_layer_set_exclusive_zone(GTK_WINDOW(gobj()), 0); });

    hide_box.set_orientation(Gtk::Orientation::VERTICAL);
    hide_box.set_css_classes({"event_box"});
    hide_box.append(master_box);
    hide_box.set_valign(Gtk::Align::END);
    hide_box.add_controller(hide_controller);

    show_box.set_css_classes({"mbox"});
    show_box.add_controller(show_controller);
    hide_box.append(show_box);

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

    set_child(hide_box);
}