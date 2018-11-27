# Christmas Store Volunteer Sign-Up

This web application is used by New Horizons Fellowship to sign-up volunteers for the annual Christmas Store charity event.
The Christmas Store is a place where disadvantaged families can choose gifts for their children and have them gift wrapped
at no cost to them.  This is a community effort that relies on donations of toys, money and time from people and businesses
in Southeastern Wake County, NC.

This program is written in Java and JSP, uses a MariaDB (MySQL) database and Tomcat.  

## Building

`mvn package`

## Deploying

`cp target/ChristmasStore.war <tomcat_home>/webapps/ROOT.war`

## Configuring email

At NHF, this program is being hosted on Microsoft Azure.  Azure does not allow virtual machines to just send SMTP email.
We are using MailGun to send our reminder emails.  MailGun allows us to send up to 6000 email/month for free, which is
plenty for our Christmas Store Volunteer Sign-Up application.

In MailGun, you will create a domain and an API key.  The API key and the URL for the domain will be available on the
MailGun web site.  You will need to create a file called mail_parameters.txt with the first line of the file being the
URL and the second line being the API key (without the "api-" prefix) and put this file in the directory with the .jsp
files before building the war file.

## Initializing the database

There is a .sql file with our initial data from 2018.  Every year, we end up tweaking the database for the dates and
any changes to area descriptions, volunteers needed, etc.
