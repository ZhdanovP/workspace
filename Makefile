image_name := neuralegion_workspace

work_base_dir := /projects

run:
	./docker_run.sh $(image_name) $(work_base_dir) 

build:
	docker build -t neuralegion_workspace .