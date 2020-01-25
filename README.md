# School API

# How Install to local server
  * git clone https://github.com/CaioCS100/school-api.git
  * config your username and password in config/database.yml
  * run bundle install
  * run rails db:create to create a database
  * run rails db:migrate for migrate the tables to database 
  * you can use some created tests in lib/task/dev.rake
    * for use this, you need run rails dev:setup
  * There is a documentation in Swagger website
    * you can see this documentation accessing: https://app.swaggerhub.com/apis-docs/CaioCS100/school/1.0.0
  * First run the /auth route to create a user then you will receive some elements that you need to see another rotes
    * this elements are:
      * access-token
      * token-type
      * client
      * uid
