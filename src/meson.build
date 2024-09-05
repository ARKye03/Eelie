extra_dirs = include_directories('Modules')

executable(
    project_name,
    sources: [
        'main.cpp',
        'Modules/window.cpp',
        'Modules/window.hpp',
        'Modules/AppButton.cpp',
        'Modules/AppButton.hpp',
    ],
    dependencies: [
        dependency('gtk4'),
        dependency('gtkmm-4.0'),
        dependency('sigc++-3.0'),
        dependency('gtk4-layer-shell-0'),
    ],
    include_directories: extra_dirs,
    install: true,
)