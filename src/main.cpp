#include "window.hpp"

int main(int argc, char **argv)
{
    auto app = Gtk::Application::create("org.codeberg.ARKye03.Eelie");
    return app->make_window_and_run<DockWindow>(argc, argv);
}