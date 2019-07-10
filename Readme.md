# How to deploy K8s

This repo contains demo resources for presentation "How to deploy K8s"

- [Slides](https://docs.google.com/presentation/d/13jBASi2U6QwGjIHhO9eS2NAFtgEz7DyUQEcMt9orwJM/edit?usp=sharing)

## If you want to run examples

- Requirements:
    - Gitlab runer has to have installed:
        - kubectl
        - terraform

- Setup Env Vars in Gitlab project setting
    - **Docker related env vars**
        - APP_HEALTHY
        - DOCKER_IMAGE
    - **AWS related env vars** - used to upload manifest to S3 bucket
        - AWS_ACCESS_KEY_ID
        - AWS_SECRET_ACCESS_KEY
        - S3_BUCKET_NAME
    - **Spinnaker env vars** - used to fire and monitor Spinnaker pipeline
        - SPINNAKER_APPLICATION_NAME
        - SPINNAKER_BASE_URL
        - SPINNAKER_PASSWORD
        - SPINNAKER_PIPELINE_NAME
        - SPINNAKER_USER
