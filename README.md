# Deploy Meteor Apps in an Ubuntu Docker Container

This works from you App directory with Meteor 1.6.1 and Docker 18.03.0 but should work for similar environments.

`meteor build ../meteorbuilds/app --directory --architecture os.linux.x86_64`

Now copy the Dockerfile into the ../meteorbuilds/app folder, **add your settings** and run

`docker build -t my-app-image-name .`

This is going to build a Docker image with Ubuntu, install dependencies we need, copy the working folder into the image, install nodejs and run npm install which rebuilds the node dependencies.

If you want to test it locally you can try

`docker run -p 3000:3000 my-app-image-name`

which should make your nodejs server available at http://localhost:3000. To stop and remove the container please refer to the Docker docs.
