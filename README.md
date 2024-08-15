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

```
stage('Update Kubernetes Deployment') {
            steps {
                sh 'kubectl delete -f /home/zub/ProgramFiles/b_flask/k8s/kind/kind-deployment.yaml --kubeconfig=${KUBE_CONFIG}' // first deleting it for not making any mistakes. You don't have to do that.
                sh 'kubectl apply -f /home/zub/ProgramFiles/b_flask/k8s/kind/kind-deployment.yaml --kubeconfig=${KUBE_CONFIG}'

            }
        }

        stage('Run Flask Application') {
            steps {
                sh 'kubectl delete -f /home/zub/ProgramFiles/b_flask/k8s/kind/kind-service.yaml --kubeconfig=${KUBE_CONFIG}'
                sh 'kubectl apply -f /home/zub/ProgramFiles/b_flask/k8s/kind/kind-service.yaml --kubeconfig=${KUBE_CONFIG}
            }
        }
    }
```
Since my Kubernetes is installed locally, I specified the path `.kube/config` in the variables section. It applies accordingly. I remove it because sometimes there can be conflicts, and removing it resolves this issue. A check could be added here to determine whether the YAML has been applied or not. 


------------
## If your repo is private?

```pipeline
stages {
        stage('Clone Git Repository') {
            steps {
                git branch: 'latest', credentialsId: 'gitlab-token', url: "${GIT_REPO_URL}"
                // you can add "gitlab-token" in Manage Jenkins --> Credentials --> Global --> Add Credentials --> Username with password and id = gitlab-token
            }
        }
```
We can access the private repository using a credential named gitlab-token, which contains the GitLab account's username and password. <br>
The repository URL is already obtained from the variable in the environment section above. You can modify the branch part according to your needs in the code. Alternatively, instead of adjusting the branch part within the code, you can create a variable in the environment section and direct it here to simplify the process.



------------
## Credential
- registryCredential = 'dockerhub-credentials' <br>
  dockerhub-credentials is a credential created within Jenkins. It is of type "Username and password" and contains the Docker Hub account's username and password. It is passed into the pipeline using `registryCredential`.
------------
## Related Projects

Here are some related projects;

[Basic Flask Project](https://github.com/zbrtsn/basic-to-do-flask.git) <br>
[Kubernetes-Kind](https://github.com/zbrtsn/kurbernetes-kind)


  
