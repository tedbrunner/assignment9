#! /bin/bash
# Tag, Push and Deploy only if it's not a pull request
# Comment
if [ "$TRAVIS_BRANCH" == "master" ]; then
    docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
    if [ $? -eq 0 ]; then
	echo "docker logged in"
    fi
    
    docker push "$DOCKER_REPO"/"$DOCKER_IMAGE":latest
    if [ $? -eq 0 ]; then
	echo "docker pushed repo"
    fi

    ./bin/ecs-deploy.sh \
    -n $ECS_SERVICE_NAME \
    -c $ECS_CLUSTER_NAME \
    -i "$DOCKER_REPO"/"$DOCKER_IMAGE":latest

    if [ $? -eq 0 ]; then
	echo "ecs-deploy"
    fi

fi
