## why Docker

Docker was first shown as a public demo by Solomon Hykes on PyCon US 2013. He worked for a cloud-provider company using Linux Containers (LXC) to rapidly deploy application servers for its customers. At the time, LXC was a known technology (which is still being used today), although it never got widely adopted due to its rather complex nature.

Docker became an almost universal development tool mainly because of the simplifications it provides (compared to LXC). Some more (recent) history:

- This is a recording of the (noticeably short) [first live demonstration of Docker](https://youtu.be/wW9CAH9nSLs?si=u3emCPU2JhJ6qhnl).
- In [this presentation](https://youtu.be/3N3n9FzebAA?si=yQeME3UlTj4BS4or) Solomon Hykes explains why he felt the need to develop Docker.

## containerization

Essentially, the goal of containerization is the same as virtualization: isolating applications from each other and the hardware. Isolation can have multiple drivers: security, portability, uniform deployment, testing ...

Vrtualization is achieved through a hypervisor running different parallel (guest) operating systems called *virtual machines*, while container platforms such as Docker run isolated applications bundled with all components required for them to operate properly: *containers*. These containers do *not* include a full-blown operating system, instead sharing the required features of the host kernel, much like LCX. This means containers are a more light-weight and flexible solution than virtual machines.

![Virtualization versus Containerization](assets/virtualization-vs-containers_transparent.png)

Bear in mind that Docker is not the only containerization platform - you can also use LXC, CRI-O or Podman - but it is by far the most popular one.

## concepts

We will now highlight some of the core concepts of Docker, providing general information and demonstrating some of the most useful commands.

More detailed information can be found in the official [DockerDocs](https://docs.docker.com/get-started/docker-overview/). The paragraphs below mainly serve as a summary of these docs. It's strongly suggested to try out the steps from the Introduction, as this is the best way to familiarize yourself with the concepts and commands of Docker.

### containers

A container is a packaged version of an application, including all its dependencies. It is a small, standalone, deployable unit able to run in semi-isolation on a host system. Docker containers are created using images.

### images & layers

Images can be regarded as templates with instructions on how to create containers at run-time. You could call images the static version of containers: the same image can be used to create multiple run-time containers. Most container images are not tied to a container platform and can be used within other framework. Meaning you can f.e. use Docker images to start Podman containers.

Images can specify a wide range of options for the container(s) to be created, ranging from the contained application and its files to the networking and storage options. Most of these options affect the file system within the container, each such a change is called an *image layer*.

Container images are composed of these layers, starting from a base image and adding an additional layer to the image for each configuration change to the file system.Examples of base images are [the Python image](https://hub.docker.com/_/python) and [the MongoDB image](https://hub.docker.com/r/mongodb/mongodb-community-server). Possible layers that can be added to these base images to create a new image can be f.e. source code files of an application you want to run and configuration files for its settings.

Note that images are immutable: once layers have been added to an image they can not be changed or removed. You can still use the image as a base for a new image, with additional layers. This is generally done using Dockerfiles.

### Dockerfiles

Dockerfiles are text files used to create container images. They contain a fixed set of commands for the Docker image builder, dictating which base image should be used and which additional image layers should be added.

Some of the most common instructions in a Dockerfile include:

- `FROM <image>` - this specifies the base image that the build will extend.
- `WORKDIR <path>` - this instruction specifies the "working directory" or the path in the image where files will be copied and commands will be executed.
- `COPY <host-path> <image-path>` - this instruction tells the builder to copy files from the host and put them into the container image.
- `RUN <command>` - this instruction tells the builder to run the specified command.
- `ENV <name> <value>` - this instruction sets an environment variable that a running container will use.
- `EXPOSE <port-number>` - this instruction sets configuration on the image that indicates a port the image would like to expose.
- `CMD ["<command>", "<arg1>"]` - this instruction sets the default command a container using this image will run.

Example of a Dockerfile:

```console
FROM python:3.12
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY src ./src
EXPOSE 5000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```

To read through all of the instructions or go into greater detail, check out the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

### volumes

Since containers are rather light-weight, they can be deployed and destroyed relatively quickly. Keep in kind that containers are ephemeral by nature, meaning its file system is deleted upon deleting the container. If you want your container data to be persistent, you can use volumes.

Volumes provide persistent storage to docker containers using a sort of link to storage outside the container. Docker can create and manage these volumes, allowing you to link them to containers when required. 

Example of linking a persistent volume called `log-data` to the container directory `/logs`. The volume will effectively be mounted at this point in the container file system.

```console
docker run -d -p 80:80 -v log-data:/logs docker/welcome-to-docker
```

### Docker Compose

Starting and managing multiple containers can become cumbersome if done manually. That's where Docker Compose comes in. Compose allows you to bundle all containers you want to manage as one within a YAML file, allowing you to start or destroy all of them with a single command (`docker compose up`). For example, this command can allow you to spin up a completely containerized LAMP-stack given the correct Docker Compose file.

