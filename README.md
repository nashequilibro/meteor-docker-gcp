# Deploy Meteor Apps in an Ubuntu Docker Container

## Basic Docker Container for local use

This works from you App directory with Meteor 1.6.1 and Docker 18.03.0 but should work for similar environments.

`meteor build ../meteorbuilds/app --directory --architecture os.linux.x86_64`

Now copy the Dockerfile

```
# Use an official ubuntu 16.04
FROM ubuntu:16.04

# Set the working directory to /app
WORKDIR /app

# Copy the app directory contents into the container at /app
ADD . /app

# Install any needed packages
RUN apt-get -y update && apt-get -y install build-essential python g++ curl
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs
RUN cd ./programs/server && npm install

# Make port 3000 available to the world outside this container
EXPOSE 3000

# Define environment variables for Meteor
ENV MONGO_URL="{Your Mongo Uri}"
# Root Url, so we can access it from outside
ENV ROOT_URL=http://localhost
ENV PORT=3000
# Your Meteor Settings
ENV METEOR_SETTINGS='{"public": {}, "private": {}}'

# Run app.py when the container launches
CMD ["node", "main.js"]
```

into the ../meteorbuilds/app folder, **add your settings** and from there run

`docker build -t my-app-image-name .`

This is going to build a Docker image with Ubuntu, install dependencies we need, copy the working folder into the image, install nodejs and run npm install which rebuilds the node dependencies.

If you want to test it locally you can try

`docker run -p 3000:3000 my-app-image-name`

which should make your nodejs server available at http://localhost:3000. To stop and remove the container please refer to the Docker docs.

## For deployment on GCP (Kubernetes)

I used the tutorial on https://cloud.google.com/kubernetes-engine/docs/tutorials/hello-app to create a Kubernetes cluster on Google Cloud. The build process works as before, just use something like gcr.io/${PROJECT_ID}/app-name:v1 for your images.
Push your image to container registry with

`gcloud docker -- push gcr.io/${PROJECT_ID}/app-name:v1`

From there you can

`kubectl run my-app --image=gcr.io/${PROJECT_ID}/app-name:v1 --port 3000`

and then

`kubectl expose deployment my-app --type=LoadBalancer --port 80 --target-port 3000`

to make it accessible over http. Find the external ip with `kubectl get service`.

For configuration and SSL and load balancing etc etc please refer to the Google Cloud Docs, but i have to warn you: It is not going to be quick and easy. I gave up after a couple of days.

## Deployment on Google App Engine

add the app.yaml in addition to the Dockerfile

```
runtime: custom
env: flex
threadsafe: true
automatic_scaling:
  max_num_instances: 1
skip_files:
- ^(.*/)?\.dockerignore$
- ^(.*/)?\npm-debug.log$
- ^(.*/)?\yarn-error.log$
- ^(.*/)?\.git$
- ^(.*/)?\.hg$
- ^(.*/)?\.svn$
```

and just run

`gcloud app deploy`
