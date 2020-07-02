public class Gtk4Demo.StringHolder : GLib.Object {
    public StringHolder (string title, string? icon = null, string? description = null) {
        this.title = title.dup();
        this.icon = icon;
        this.description = description;
    }

    public string title { get; set; }
    public string icon { get; set; }
    public string description { get; set; }
}