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
