#SendGrid-CFML
This is a library allows you to quickly and easily send emails
through SendGrid's using CFML. It is heavily based on SendGrid's official libraries. Module support for ColdBox 4

SendGrid's official Web API documentation can be found [here](https://sendgrid.com/docs/API_Reference/Web_API/mail.html)

##Usage

*Coming soon...*

---

email.setDate('Wed, 17 Dec 2014 19:21:16 +0000');
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