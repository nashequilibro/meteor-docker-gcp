# Deploy Meteor Apps in an Ubuntu Docker Container

## Basic Docker Container for local use

This works from you App directory with Meteor 1.6.1 and Docker 18.03.0 but should work for similar environments.

`meteor build ../meteorbuilds/app --directory --architecture os.linux.x86_64`

Now copy the Dockerfile into the ../meteorbuilds/app folder, **add your settings** and from there run

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

For configuration and SSL and load balancing etc etc please refer to the Google Cloud Docs.
