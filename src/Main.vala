public class Gtk4Demo.DropDownApp : Gtk.Application {
    public DropDownApp () {
        Object (
            application_id: "github.aeldemery.gtk4_dropdown",
            flags : GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    public override void activate () {
        var win = this.active_window;
        if (win == null) {
            win = new Gtk4Demo.MainWindow (this);
        }
        win.present ();
    }
}

int main (string[] args) {
    var app = new Gtk4Demo.DropDownApp ();
    return app.run (args);
}