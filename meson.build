project (
    'github.aeldemery.gtk4_dropdown',
    'c', 'vala',
    version: '0.1.0',
)

sources = files (
    'src/Main.vala',
    'src/StringHolder.vala',
    'src/MainWindow.vala',
)

gnome = import ('gnome')

dependencies = [
    dependency ('gobject-2.0'),
    dependency ('glib-2.0'),
    dependency ('gtk4'),
    dependency ('pangocairo'),
]

executable (
    meson.project_name(),
    sources: sources,
    dependencies: dependencies,
    install: true,
)