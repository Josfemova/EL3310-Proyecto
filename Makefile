clean:
	rm -rf build;
	mkdir build;

build: clean
	(cd build; cmake .. ;make -j4)
