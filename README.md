#SendGrid-CFML
This is a library allows you to quickly and easily send emails
through SendGrid's using CFML. It is heavily based on SendGrid's official libraries. Module support for ColdBox 4

SendGrid's official Web API documentation can be found [here](https://sendgrid.com/docs/API_Reference/Web_API/mail.html)

##Usage Examples

###As a Coldbox Module

This library can be dropped in as a ColdBox module in your ColdBox app's `modules` folder. It assumed some default username and credentials but they're bogus and won't work so you'll need to get your own from SendGrid.


####Configuration Sample

In Coldbox.cfc:

    function configure(){
        ...
        // custom settings
        settings = {
            SendGrid = {
                apiUsername: "yourUsername",
                apiPassword: "yourPassword",
                options: {}
            }
        };
        ...
    }

You can set environment specific credentials too from Coldbox.cfc

    function configure(){
        ...
        environments = {
            development = "localhost,127.0.0.1"
        };
        ...
    }

    /**
    * Development environment
    */
    function development(){
        settings = {
            SendGrid = {
                apiUsername: "usernameDev",
                apiPassword: "passwordDev",
                options: {}
            }
        };
    }

####Using it in your ColdBox app

There are a few different ways you can then access the SendGrid service and send email.

    component{
        property name="SendGrid" inject="SendGrid@sendgrid-cfml";

        function foo(){
            //Set up email model with methods.
            getModel( 'email@sendgrid-cfml' );
            email.addTo('dskraus@gmail.com');
            email.setFrom('me@domain.com');
            email.setSubject('This is an email');
            email.setHtml('<p>This is an HTML email</p>');

            //or init the email in one go:
            email = getModel( 'email@sendgrid-cfml' ).init({ to: 'art.vandelay@vandelayindustries.com',
                                                             from: 'ckramer@kramerica.com',
                                                             subject: 'This is an email',
                                                             html: '<p>This is an HTML email</p>'});

            //just use it if SendGrid injected with Wirebox via property
            SendGrid.send(email);

            //or if you need to use different credentials than the ones specified in your app
            //you can grab a new instance and init accordingy
            mailer = getModel( 'sendgrid@sendgrid-cfml' ).init("newUsername", "newPass");
            mailer.send(email);

        }
    }

###As a plain old object

    sendGrid = new sendgrid-cfml.models.services.SendGrid.init("username", "password");
    email = new sendgrid-cfml.models.Email.init({ to: 'art.vandelay@vandelayindustries.com',
                                                  from: 'ckramer@kramerica.com',
                                                  subject: 'This is an email',
                                                  html: '<p>This is an HTML email</p>'});

    sendGrid.send(email);


##Documentation

###SendGrid.cfc

###Email.cfc

###SMTPAPI.cfc

###Attachment




---

*More Coming soon...*

---

...So I won't forget this with the rest of the docs:
`email.setDate('Wed, 17 Dec 2014 19:21:16 +0000');`
Must be in RFC-2822 Date format!

---

##Tests

There are 85+ tests! Wowee!

1. Use CommandBox and run `box install` against the directory where this repo has been cloned. CommandBox will download and install TestBox to run tests.

2. Add the following environment variables for the tests to use to test outgoing email and connecting to SendGrid. It will send live emails and use credits against your account:

    * `SENDGRID_USERNAME = :yourSendGridUsername`
    * `SENDGRID_PASSWORD = :yourSendGridPassword`
    * `SENDGRID_TEST_TO = :aToEmailYouCanReadEmailAt@domain.com`
    * `SENDGRID_TEST_FROM = :someTest@domain.com`

3. Start a server with `box server start`and browse to `/test/runner.cfm` to run test suite.

##Contributing

1. Fork it ( https://github.com/[my-github-username]/sendgrid-cfml/fork )
2. Create your feature branch (git checkout -b feature/my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

It'd be really, really terriffic if you wrote tests for your changes to.

##Issues

Log issues with GitHub [Issues](https://github.com/dankraus/sendgrid-cfml/issues)

##Thanks
I was going a bit crazy trying to convert unicode chars for the X-SMTPAPI headers.
Big thanks to this Saman W Jayasekara @cfloveorg and this [blog post](http://cflove.org/2009/12/format-unicode-string-for-indesign-a-coldfusion-udf.cfm)! I rewrote it in cfscript for use in `SMTPAPI.cfc`.

This is my first ColdBox Module. I referenced [Jon Clausen's cfmongodb](https://github.com/jclausen/cfmongodb) for how to do some module configuration defaults and pulling in settings from Coldbox.cfc