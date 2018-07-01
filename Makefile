build-container:
	docker build -t tensorflow-cpu-py3.7.0 --build-arg PYTHON_VER="3.7.0" .
build:
	docker run -it --rm \
		-v `pwd`/scripts:/root/scripts \
		-v `pwd`/tensorflow:/root/tensorflow \
		-v `pwd`/out:/root/out \
		tensorflow-cpu-py3.7.0 \
		/root/scripts/build.sh
clean:
	rm -rf tensorflow/* tensorflow/.*
