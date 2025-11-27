### Project 4: Continuous Integration Project Overview

## Part 4: Project Description & Diagram
## Project Goal:
### The  goal of this project is to implement Continuous Integration  pipeline using GitHub Actions and Semantic Versioning. This process ensures that every code release, triggered by a Git tag, automatically builds a verified Docker container image and pushes it to DockerHub with recoverable version tags. This provides reliable version tracking and a mechanism for easy rollback to stable builds.

## What Tools are Used in this Project and What are Their Roles?
* GitHub: Hosts the code repository and Git tags.
* GitHub Actions: Continuous Integration Engine, executes the automated workflow.
* Docker: Containerization, used to define the application's environment (Dockerfile) an run the image locally for testing.
* DockerHub: Stores the final versioned container images 
* Docker/metadata-action: Automatically parses Git tags to create the required semantic tags
* GitHub Secrets: Secure Authentication, Securely stores the DockerHub username and Personal Access Token.

## Diagram
![Diagram](Project4.png)

## Resources
* https://docs.github.com/en/actions/get-started/quickstart
    * Used this for help with setting up GitHub Actions
* https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets
    * Used this for help with setting up Secrets
* https://github.com/marketplace/actions/build-and-push-docker-images
    * Used this for help with the `docker-ci.yml`
* https://docs.docker.com/build/ci/github-actions/manage-tags-labels/
    * Used this for help with setting up the tags / labels for github actions in `docker-ci.yml`
* https://semver.org/
    * Used this for help with the versioning specification.

## Part 1- Docker container image

### Explanation and links to web site content:
### Cake Website with the theme of the game Elden Ring
* ([web-content](https://github.com/WSU-kduncan/cicdf25-CoyRy/tree/main/web-content))

### Explanation of and link to Dockerfile:
### `FROM httpd:2.4` Specifies the base image that the new image will be built upon, which is Appache HTTP Server v 2.4. 
### `COPY  . /usr/local/apache2/htdocs/` copies web content into the default document root for Apache.
* https://github.com/WSU-kduncan/cicdf25-CoyRy/blob/main/web-content/Dockerfile

### Instructions to build and push container image to your DockerHub repository:
* use the command `docker build -t coryan/elden-cake:latest .`
* Login and Push: Use the PAT as your password during login.
    * `docker login` 
    * `docker push coyryan/elden-cake:latest`

## Part 2- GitHub Actions and DockerHub
### 1. Configuring GitHub Repository Secrets

### PAT Creation: A Personal Access Token is required for secure, non-interactive authentication. Create one on DockerHub under Account Settings > Security > Personal Access Tokens. The recommended scope is Read & Write to allow the CI process to be able to push and pull images.

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

* Workflow File Link: 
    * https://github.com/WSU-kduncan/cicdf25-CoyRy/blob/main/.github/workflows/docker-ci.yml

### 3. Testing & Validating
## How to Test the Workflow
### To test that your workflow performed its task successfully, monitor the GitHub Actions tab after pushing a commit to the main branch:

* Trigger the Workflow: Push a commit to your repository's main branch (e.g., update the README or your application code).

* Monitor the Run: Navigate to the Actions tab in your GitHub repository.

* Check Status: Click on the most recent run named "Docker CI Build and Push" (or whatever you named your workflow).

* Verify Success: Ensure that all steps within the build_and_push_image job complete with a green check mark (✅). This confirms the image was built locally on the runner and successfully authenticated and pushed to DockerHub.
## How to Verify the Image in DockerHub
* Check Tags on DockerHub: Visit your repository page on DockerHub. You should see two new tags:

    * latest (the most recent stable version).

    * A tag matching the Git commit SHA (a long alphanumeric string) that triggered the build.

### To verify that the image works when a container is run using the image:
* Run the Container locally,  Use the following commands:
`docker pull coyryan/elden-cake:latest`
`docker run -d -p 8080:80 --name elden-site-test coyryan/elden-cake:latest`
* Go to : `http://localhost:8080/` should be able to see the website content, which verifies its working.
* Link to Your DockerHub Repository:  https://hub.docker.com/r/coyryan/elden-cake

### Part 3 - Semantic Versioning
## 1. Generating Tags
* How to see tags in a git repository:
    * `git tag`
* How to generate a tag in a git repository to Github:
    * `git tag -a v1.0.0 -m "Comment"`
* How to push a tag in a git repository to Github:
    * `git push origin v1.0.0`

## 2. Semantic Versioning Container Images with GitHub Actions 
* Explanation of workflow trigger: 
    * The workflow is now triggered only when a Git tag matching the pattern `v*.*.*` like v1.0.0 is pushed to GitHub.
* Explanation of workflow steps: 
    * The workflow now includes the `docker/metadata-action@v5` which automatically extracts the version from the Git tag  and formats the three required Docker tags. These outputs are then passed to the `docker/build-push-action@v6`.
* DockerHub Tags: The image is pushed with the following tags:

    * latest (Only generated on a major release,  v1.0.0).

    * major (1).

    * major.minor (1.0).

    * major.minor.patch (1.0.0).

## Explanation  of values that need updated if used in a different repository:

* Changes in workflow: The images: value in the docker/metadata-action must be updated to the new DockerHub repository path (NEW_USER/NEW_IMAGE).

* Changes in repository: The new repository must have the DOCKER_USERNAME and DOCKER_TOKEN secrets configured.

* Link to workflow file in your GitHub repository: 
    * https://github.com/WSU-kduncan/cicdf25-CoyRy/blob/main/.github/workflows/docker-ci.yml

## 3. Testing and Validating
### Test that Your Workflow Did its Tasking:
* Trigger the Workflow by creating and pushing a new tag like `git tag -a v1.0.2 -m "comment"`then  `git push origin v1.0.2`
* Check the Actions tab on Github, Should see a green check mark that confirms the build succeeded.

## Verify the image in DockerHub works:
* Use the following commands:   
    * `docker pull coyryan/elden-cake:1.0.1`
    * `docker run -d -p 8080:80 --name elden-site coyryan/elden-cake:1.0.1`
    * Go to : `http://localhost:8080/` should be able to see the website content, which verifies its working.
* Link to Dockerhub with tags:
    * https://hub.docker.com/r/coyryan/elden-cake/tags