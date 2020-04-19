# CI/Docker: Use last image for quicker building 

When you heavily use Continuous Integration on Gitlab for example, you build a
lot of new Docker Images. Some can take a long time to build, depending of how
your (private) Docker registry is caching things.

A nice way to build a new Docker Image for your project in the CI is to use the
Docker build `--cache-from` argument. When you use it to build a new image, it will
use the previous image built for that project to accelerate the build of the
new one.

Example:

```yml
# gitlab-ci.yml
build:
  stage: build
  script:
    - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY
    - docker pull "$CI_REGISTRY_IMAGE/project-image:latest" || true # to handle first build where there is no image yet
    - docker build --cache-from "$CI_REGISTRY_IMAGE/project-image:latest" --tag "$CI_REGISTRY_IMAGE/project-image:$CI_COMMIT_SHA" --tag "$CI_REGISTRY_IMAGE/project-image:latest" .
    - docker push "$CI_REGISTRY_IMAGE/project-image:latest"
```

The CI will first pull the last built image (if any) and use it as a cache to build the
new one. It should reduce the built time a lot.

