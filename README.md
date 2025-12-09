## CI/CD Pipeline for Elden Cake Application
This repository contains the source code and configuration files necessary to run a  Continuous Integration and Continuous Deployment pipeline for the "Elden Cake" website.

The pipeline is triggered by pushing a new Git version tag, resulting in a live container update on an Amazon EC2 instance.

[README-CI.md](https://github.com/WSU-kduncan/cicdf25-CoyRy/blob/main/README-CI.md)
* Continuous Integration: Contains the  Actions workflow used to build and push the Docker image to Docker Hub also Semantic Versioning.

[README-CD.md](https://github.com/WSU-kduncan/cicdf25-CoyRy/blob/main/README-CD.md)
* Continuous Deployment: Contains the final deployment steps, including the deployment script (`refresh_container.sh`), the justification for using GitHub as the secure payload sender, and the mechanism for validating that only authenticated requests can trigger a live deployment.