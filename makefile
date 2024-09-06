target=./build/src/com.github.ARKye03.Eelie

run:
	ninja -C build
	$(target)

build:
	ninja -C build

