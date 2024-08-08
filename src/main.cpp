#include "gtk4-layer-shell.h"
#include <gtkmm-4.0/gtkmm.h>
#include <iostream>

class MyWindow : public Gtk::Window
{
public:
    MyWindow();

private:
    Gtk::Box master_box;
    void LoadCss(const std::string &css_path);
};

MyWindow::MyWindow()
{
    gtk_layer_init_for_window(GTK_WINDOW(gobj()));
    gtk_layer_set_layer(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_LAYER_TOP);

    gtk_layer_set_exclusive_zone(GTK_WINDOW(gobj()), true);

    gtk_layer_set_margin(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_TOP, 10);
    gtk_layer_set_margin(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_BOTTOM, 10);

    gtk_layer_set_anchor(GTK_WINDOW(gobj()), GTK_LAYER_SHELL_EDGE_BOTTOM, true);

    master_box.set_homogeneous(true);
    master_box.set_spacing(10);
    master_box.set_css_classes({"master_box"});

    set_child(master_box);

    Gtk::Button button1("Hello");
    Gtk::Button button2("World");
    master_box.append(button1);
    master_box.append(button2);

    set_title("Basic application");
    set_default_size(200, 200);

    LoadCss("styles/main.css");
}
void MyWindow::LoadCss(const std::string &css_path)
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
    return app->make_window_and_run<MyWindow>(argc, argv);
}
