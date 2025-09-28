# EcoLearn - Gamified Environmental Education Platform

This is a Java web application built with Jakarta EE for gamified environmental education.

## Deployment to Heroku

To deploy this application to Heroku, follow these steps:

1. Create a Heroku account at https://heroku.com if you don't have one already
2. Install the Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli
3. Clone this repository
4. Login to Heroku CLI: `heroku login`
5. Create a new Heroku app: `heroku create your-app-name`
6. Set the buildpack: `heroku buildpacks:set heroku/java`
7. Deploy the application: `git push heroku master`

## Local Development

To run this application locally:

1. Make sure you have Apache Maven installed
2. Run `mvn clean package` to build the project
3. Deploy the generated WAR file to a servlet container like Tomcat

## Features

- Gamified learning experience
- Environmental education content
- Interactive challenges
- Student progress tracking
- Teacher dashboard

## Technologies Used

- Java
- Jakarta EE
- MySQL
- HTML/CSS/JavaScript
- Maven for build management