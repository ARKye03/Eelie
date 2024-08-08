project(
    'org.codeberg.ARKye03.Eelie',
    ['cpp', 'c'],
    version: '0.1',
    meson_version: '>= 1.4.0',
    default_options: [
        'warning_level=2',
        'default_library=static',
        'optimization=3',
        'buildtype=release',
        'debug=false',
        'cpp_std=c++23',
    ],
)

project_name = meson.project_name()
gnome = import('gnome')

subdir('data')
subdir('src')