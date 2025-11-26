## Project 4

## Part 1- Docker container image

### Explanation and links to web site content:
### Cake Website with the theme of the game Elden Ring
* ([web-content](https://github.com/WSU-kduncan/ceg3120f25-CoyRy/tree/main/Project3/web-content))

### Explanation of and link to Dockerfile:
### `FROM httpd:2.4` Specifies the base image that the new image will be built upon, which is Appache HTTP Server v 2.4. 
### `COPY  . /usr/local/apache2/htdocs/` copies web content into the default document root for Apache.
* https://github.com/WSU-kduncan/ceg3120f25-CoyRy/blob/main/Project3/web-content/Dockerfile

### Instructions to build and push container image to your DockerHub repository:
* use the command `docker build -t coryan/elden-cake:latest .`
* Login and Push: Use the PAT as your password during login.
    * `docker login` 
    * `docker push coyryan/elden-cake:latest`

## Part 2- GitHub Actions and DockerHub
### 1. Configuring GitHub Repository Secrets

### PAT Creation: A Personal Access Token (PAT) is required for secure, non-interactive authentication. Create one on DockerHub under Account Settings > Security > Personal Access Tokens. The recommended scope is Read & Write to allow the CI process to push images.

### Repository Secrets: The PAT and your username must be stored as Repository Secrets in your GitHub repository (Settings > Secrets and variables > Actions).

* Secret Descriptions:

    * DOCKER_USERNAME: Stores your DockerHub account username.

    * DOCKER_TOKEN: Stores the DockerHub Personal Access Token (PAT).

## 2. CI with GitHub Actions

### Workflow Trigger: The CI pipeline is configured to run automatically only when code is pushed to the main branch, as specified in the on: push: branches: ["main"] block of the YAML file.

* Workflow Steps Explanation:

    * actions/checkout@v4: Downloads the repository code onto the runner.

    * docker/setup-buildx-action@v3: Sets up Docker's Buildx component, which enables powerful build features like caching and multi-platform builds.

    * docker/login-action@v3: Authenticates the runner to DockerHub using the DOCKER_USERNAME and DOCKER_TOKEN secrets.

    * docker/build-push-action@v6: Builds the Docker image from the Dockerfile (in the current directory) and pushes it to DockerHub, tagging it with latest and the unique Git commit SHA (${{ github.sha }}).

## Configuration Changes for Reuse:

* In the workflow file (docker-ci.yml):

    * The image path/name under the tags input must be updated: YOUR_DOCKERHUB_USERNAME/YOUR_IMAGE_NAME. You will need to change YOUR_IMAGE_NAME if the repository name is different.

* In the repository:

    * The GitHub Repository Secrets (DOCKER_USERNAME and DOCKER_TOKEN) must be set up in the new repository.

* Workflow File Link: [Link to your .github/workflows/docker-ci.yml file in your repository]