public class Gtk4Demo.MainWindow : Gtk.ApplicationWindow {
    public MainWindow (Gtk.Application app) {
        Object (application: app);
    }

    private static Pango.FontMap font_map;
    private static Pango.FontFamily[] font_families;
    private static GLib.ListStore fonts_list;

    construct {
        build_font_family_names_list ();

        const string[] times = { "1 minute", "2 minutes", "5 minutes", "20 minutes" };
        const string[] many_times = {
            "1 minute", "2 minutes", "5 minutes", "10 minutes", "15 minutes", "20 minutes",
            "25 minutes", "30 minutes", "35 minutes", "40 minutes", "45 minutes", "50 minutes",
            "55 minutes", "1 hour", "2 hours", "3 hours", "5 hours", "6 hours", "7 hours",
            "8 hours", "9 hours", "10 hours", "11 hours", "12 hours"
        };
        const string[] device_titles = { "Digital Output", "Headphones", "Digital Output", "Analog Output" };
        const string[] device_icons = { "audio-card-symbolic", "audio-headphones-symbolic", "audio-card-symbolic", "audio-card-symbolic" };
        const string[] device_descriptions = {
            "Built-in Audio", "Built-in audio", "Thinkpad Tunderbolt 3 Dock USB Audio", "Thinkpad Tunderbolt 3 Dock USB Audio"
        };

        this.title = "Drop Downs";
        this.set_default_size (250, -1);
        // this.resizable = false;

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        with (box) {
            margin_start = margin_end = margin_bottom = margin_top = 10;
            hexpand = true;
        }
        this.set_child (box);

        var button = new Gtk.DropDown ();

        button.set_model (fonts_list);
        button.selected = 0;
        // The following don't work meanwhile :(
        Gtk.Expression expression;

        expression = new Gtk.CClosureExpression (typeof (string), null, null, (Callback) get_font_family_name, null, null);
        button.expression = expression;
        box.append (button);

        var spin = new Gtk.SpinButton.with_range (-1, fonts_list.get_n_items (), 1);
        spin.halign = Gtk.Align.START;
        spin.hexpand = true;
        button.bind_property ("selected", spin, "value", GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);
        box.append (spin);

        var check = new Gtk.CheckButton.with_label ("Enable search");
        check.hexpand = true;
        button.bind_property ("enable-search", check, "active", GLib.BindingFlags.SYNC_CREATE | GLib.BindingFlags.BIDIRECTIONAL);
        box.append (check);

        button = drop_down_new_from_strings (times, null, null);
        box.append (button);

        button = drop_down_new_from_strings (many_times, null, null);
        button.enable_search = true;
        expression = new Gtk.CClosureExpression (typeof (string), null, null, (Callback) get_string_title, null, null);
        button.expression = expression;
        box.append (button);

        button = drop_down_new_from_strings (device_titles, device_icons, device_descriptions);
        box.append (button);
    }

    void build_font_family_names_list () {
        font_map = Pango.cairo_font_map_get_default ();
        fonts_list = new GLib.ListStore (typeof (Pango.FontFamily));
        font_map.list_families (out font_families);
        foreach (var font in font_families) {
            fonts_list.append (font);
            print("Font: %s\n", font.get_name());
        }
    }

    string get_font_family_name (Pango.FontFamily font) {
        return font.get_name();
    }

    string get_string_title (StringHolder item) {
        return item.title;
    }

    void strings_setup_item_single_line (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        var image = new Gtk.Image ();
        var title = new Gtk.Label ("");
        title.xalign = 0.0f;

        box.append (image);
        box.append (title);

        list_item.set_data ("title", title);
        list_item.set_data ("image", image);
        list_item.set_child (box);
    }

    void strings_setup_item_full (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var image = new Gtk.Image ();
        var title = new Gtk.Label ("");
        title.xalign = 0.0f;

        var description = new Gtk.Label ("");
        description.xalign = 0.0f;
        description.add_css_class ("dim-label");

        var box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
        var box2 = new Gtk.Box (Gtk.Orientation.VERTICAL, 2);

        box.append (image);
        box.append (box2);

        box2.append (title);
        box2.append (description);

        list_item.set_data ("title", title);
        list_item.set_data ("image", image);
        list_item.set_data ("description", description);

        list_item.set_child (box);
    }

    void strings_bind_item (Gtk.SignalListItemFactory factory, Gtk.ListItem list_item) {
        var string_holder = list_item.get_item () as StringHolder;
        var title = list_item.get_data<Gtk.Label>("title");
        var image = list_item.get_data<Gtk.Image>("image");
        var description = list_item.get_data<Gtk.Label>("description");

        title.label = string_holder.title;
        if (image != null) {
            image.set_from_icon_name (string_holder.icon);
            image.visible = string_holder.icon != null;
        }
        if (description != null) {
            description.label = string_holder.description;
            description.visible = string_holder.description != null;
        }
    }

    Gtk.ListItemFactory strings_factory_new (bool full = true) {
        var factory = new Gtk.SignalListItemFactory ();
        if (full == true) {
            factory.setup.connect (strings_setup_item_full);
        } else {
            factory.setup.connect (strings_setup_item_single_line);
        }
        factory.bind.connect (strings_bind_item);
        return factory;
    }

    GLib.ListStore strings_model_new (string[] titles, string[] ? icons = null, string[] ? descriptions = null) {
        var list_store = new GLib.ListStore (typeof (StringHolder));
        var i = 0;
        foreach (var title in titles) {
            var string_holder = new StringHolder (
                title,
                icons != null ? icons[i] : null,
                descriptions != null ? descriptions[i] : null);
            list_store.append (string_holder);
            i++;
        }
        return list_store;
    }

    Gtk.DropDown drop_down_new_from_strings (string[] titles, string[] ? icons, string[] ? descriptions)
    requires ((icons == null || icons.length == titles.length) &&
              (descriptions == null || descriptions.length == titles.length))
    {
        var model = strings_model_new (titles, icons, descriptions);
        var factory = strings_factory_new (false);
        Gtk.ListItemFactory ? list_factory;

        if (icons != null || descriptions != null) {
            list_factory = strings_factory_new (true);
        } else {
            list_factory = null;
        }

        var drop_down = new Gtk.DropDown ();
        drop_down.model = model;
        drop_down.factory = factory;
        drop_down.list_factory = list_factory;

        return drop_down;
    }
}