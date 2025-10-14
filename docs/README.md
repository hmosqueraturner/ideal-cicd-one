# ideal-cicd-one
* Ideal Pipeline for CICD 1 - Jenkins, Java, Docker, Terraform, Ansible &amp; Azure

* Un ejemplo completo de un pipeline de CI/CD con Jenkins, utilizando Groovy,
* GitHub como sistema de control de versiones (SCM),
* Maven para construir una aplicación Java
* Docker, Kubernetes,
* Terraform para la Infraestructura como Código (IaC),
* Ansible para la configuración del sistema y el despliegue en Azure Cloud

| Module           | Description        | Status |
|:-----------------|:-------------------|:-------|
| 0. Jenkins       | Jenkins Pipeline   | wip    |
| 1. SCM           | GitHub Checkout    | ok     |
| 2. Build         | Maven package      | ok     |
| 3. Test          | Junit Test         | ok     |
| 4. Lint          | SonarQube & Gate   | Wip    |
| 5. Publish       | Nexus Push         | ok     |
| 6. Image Build   | Docker & Registry  | ok     |
| 7. Provisioning  | SonarQube - Gate   | Wip    |
| 8. Deploy        | Ansible Deploy     | wip    |
| 9. Notify        | Slack - JIRA       | Todo   |
