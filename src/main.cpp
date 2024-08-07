#include "gtk4-layer-shell.h"
#include <gtkmm-4.0/gtkmm.h>

static void
activate(GtkApplication *app, void *_data)
{
    (void)_data;

    GtkWindow *gtk_window = GTK_WINDOW(gtk_application_window_new(app));

    gtk_layer_init_for_window(gtk_window);

    gtk_layer_set_layer(gtk_window, GTK_LAYER_SHELL_LAYER_TOP);

    gtk_layer_auto_exclusive_zone_enable(gtk_window);

    gtk_layer_set_margin(gtk_window, GTK_LAYER_SHELL_EDGE_TOP, 10);
    gtk_layer_set_margin(gtk_window, GTK_LAYER_SHELL_EDGE_BOTTOM, 10);

    static const gboolean anchors[] = {TRUE, FALSE, FALSE, TRUE};

    gtk_layer_set_anchor(gtk_window, GTK_LAYER_SHELL_EDGE_BOTTOM, TRUE);

    GtkWidget *label = gtk_label_new("");
    gtk_label_set_markup(GTK_LABEL(label),
                         "<span font_desc=\"12.0\">"
                         "GTK Layer\nShell example!"
                         "</span>");

    gtk_window_set_child(gtk_window, label);
    gtk_window_present(gtk_window);
}

int main(int argc, char **argv)
{
    GtkApplication *app = gtk_application_new("com.github.wmww.gtk4-layer-shell.example", G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return status;
}
