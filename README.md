# Dockerizing a Maven webapp

This project implements a complete CI/CD pipeline for deploying a Java web application using GitHub, Jenkins, Maven, Docker, Tomcat, and AWS EC2. The pipeline supports Dev and Prod environments through Jenkins parameters, enabling automated builds, containerization, and environment-specific deployments. Dev uses Docker Compose for testing, while Prod pulls the latest Docker image, removes old containers, and runs a fresh instance. Cleanup automation is included to remove old containers and images. Designed & Developed by Sak_Shetty under MIT License.

## Prerequisites
- Docker installed
- Maven (for local builds) or use multi-stage Docker build
- JDK version matching your app (example uses JDK 11)

## Project layout (typical)
- pom.xml
- src/main/java
- src/main/resources
- src/main/webapp (for WAR)
- target/ (build output)

## GitHub Badges Block
![Jenkins](https://img.shields.io/badge/CI-Jenkins-blue)
![Docker](https://img.shields.io/badge/Container-Docker-blue)
![Maven](https://img.shields.io/badge/Build-Maven-success)
![Tomcat](https://img.shields.io/badge/Server-Tomcat-orange)
![AWS](https://img.shields.io/badge/Cloud-AWS-ff9900)
![License](https://img.shields.io/badge/License-MIT-green)

---
