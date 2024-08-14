# Jenkins-Kubernetes

Jetkins --> pipeline --> docker --> dockerhub --> kubernetes

I will pull a simple Flask project from GitLab or GitHub via Jenkins. Then, I will build the project with Docker (the project includes a Dockerfile!), and push the built image to Docker Hub. Locally, I use the "kind" tool for Kubernetes. I will also activate my manifest files, i.e., .yaml files associated with the Docker Hub repository of the pushed project, through Jenkins in the same way. My goal is to automate all these processes.


## Main Pipeline
[Jenkins Pipeline](https://github.com/zbrtsn/Jenkins-Kubernetes/blob/main/jenkins-pipeline)

## Explanation

```
environment {
        registryCredential = 'dockerhub-credentials' // all the docker hub username and password are in here
        GIT_REPO_URL = 'https://mtgit.mediatriple.net/zubeyir.tosun/basic-to-do-flask2.git' // just classic repo url
        DOCKERHUB_REPO = 'pyouck/basic_todo_flask'
        KUBE_CONFIG = '/home/zub/.kube/config' // Adjust the path to your kubeconfig
    }
```
Here, we define our global variables. <br>
Additionally, if we have created credentials, we can also define them globally here.

<br>

```
stage('Clone Git Repository') {
            steps {
                git url: "${GIT_REPO_URL}", branch: 'latest'
            }
        }
```
In the variables section, it pulls the repository from the Git URL based on the branch name we provided.

<br>

```
stage('Build Docker Image') {
            steps {
                script {
                    dir('.') {
                        // Build the Docker image with --no-cache
                        sh 'docker build -t ${DOCKERHUB_REPO}:test --no-cache .'
                    }
                }
            }
        }
```
It builds the repository that it pulls.

<br>

```
stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        sh 'docker push ${DOCKERHUB_REPO}:test'
                    }
                }
            }
        }
```
Here, registryCredential contains the Docker Hub account username and password under the credential named dockerhub-credentials. This allows the docker.withRegistry code to connect to Docker Hub, which is pre-installed with a Jenkins plugin. After logging in, it pushes the built image with the "test" tag to the name specified in DOCKERHUB_REPO.

<br>





## Credential

## Related Projects

Here are some related projects;

[Basic Flask Project](https://github.com/zbrtsn/basic-to-do-flask.git)

  
