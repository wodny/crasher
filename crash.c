#include <stdio.h>
#include <error.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

int main(int argc, char **argv) {
    GIOChannel *stdin_ch = g_io_channel_unix_new (STDIN_FILENO);
    if (stdin_ch == NULL)
        error (1, 0, "failed to create channel");

    unsigned int i = 0;
    gchar *filename;
    gsize terminator;
    GdkPixbufAnimation *anim;
    while (g_io_channel_read_line (stdin_ch, &filename, NULL, &terminator, NULL) == G_IO_STATUS_NORMAL) {
        filename[terminator] = '\0';
        printf ("%3u filename: %s\n", i, filename);
        anim = gdk_pixbuf_animation_new_from_file (filename, NULL);
        if (anim == NULL)
            error (1, 0, "failed to create animation");
        g_free (filename);
        // the killing machine
        //g_object_unref (anim);
        ++i;
    }

    return 0;
}
