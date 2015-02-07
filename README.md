#SendGrid-CFML
This is a library allows you to quickly and easily send emails
through SendGrid's using CFML. It is heavily based on SendGrid's official libraries.

SendGrid's official Web API documentation can be found [here](https://sendgrid.com/docs/API_Reference/Web_API/mail.html)


setDate('Wed, 17 Dec 2014 19:21:16 +0000')
Must be in RFC-2822 Date format!

##Contributing

1. Fork it ( https://github.com/[my-github-username]/sendgrid-cfml/fork )
2. Create your feature branch (git checkout -b feature/my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

##Issues

Log issues with GitHub [Issues](https://github.com/dankraus/sendgrid-cfml/issues)

##Thanks
I was going a bit crazy trying to convert unicode chars for the X-SMTPAPI headers.
Big thanks to this Saman W Jayasekara @cfloveorg and this [blog post](http://cflove.org/2009/12/format-unicode-string-for-indesign-a-coldfusion-udf.cfm)!
I rewrote it in cfscript for use in `SMTPAPI.cfc`.