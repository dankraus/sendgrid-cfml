component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    // executes before all suites+specs in the run() method
    function beforeAll(){
    }

    // executes after all suites+specs in the run() method
    function afterAll(){
    }

/*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        var system = createObject("java", "java.lang.System");
        var env = system.getenv();
        if(structKeyExists(env, "SENDGRID_USERNAME") && structKeyExists(env, "SENDGRID_PASSWORD")){
            var sgUsername = env['SENDGRID_USERNAME'];
            var sgPassword = env['SENDGRID_PASSWORD'];
        } else {
            var username = 'user';
            var password = 'pass';
        }
        var emailOpts = {
            to: structKeyExists(env, "SENDGRID_TEST_TO") ? env['SENDGRID_TEST_TO'] : 'hello@example.com',
            from: structKeyExists(env, "SENDGRID_TEST_FROM") ? env['SENDGRID_TEST_FROM'] : 'sample@example.com',
            subject: 'This is a subject - SendGridCFML',
            html: '<p>This is the body of an email!</p>'
        }
        var files = [
            expandPath("/test/resources/assets/logo.png"),
            expandPath("/test/resources/assets/secret.txt")
        ];
        var uri = 'http://i.imgur.com/HnAga.png';

        describe("initlizations", function(){
            it("initializes", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                expect(sendgrid).toBeInstanceOf('SendGrid');

            });
            it("sets username and password in intialization", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                expect(sendgrid.apiUsername).toBe(sgusername);
                expect(sendgrid.apiPassword).toBe(sgpassword);
            });
            it("has default url", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                expect(sendgrid.url).toBe('https://api.sendgrid.com/api/mail.send.json')
            });
            it("can set a custom url with url option", function(){
                var options = {
                    url = "http://thisisaurlitotallymadeup.com/mail"
                };
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword, options);
                expect(sendgrid.url).toBe('http://thisisaurlitotallymadeup.com/mail')
            });
            it("can set a custom url with url part options", function(){
                var options = {
                    "protocol": "http",
                    "host": "sendgrid.org",
                    "endpoint": "/send",
                    "port": "80"
                };
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword, options);
                expect(sendgrid.url).toBe('http://sendgrid.org:80/send')
            });
        });

        describe("Sending email", function(){
            it( "returns bad username/password when SendGrid creds are bogus", function(){
                var sendgrid = new models.services.SendGrid('username', 'junk');
                var email = new models.Email();
                var response = {};

                email.addTo(emailOpts.to);
                email.setFrom('foo@bar.com');
                email.setSubject('Foobar subject 2!');
                email.setText('This is the body!');

                response = sendgrid.send(email);

                expect(response).toBeTypeOf('struct');
                expect(response['errors'][1]).toBe("Bad username / password");
            });
            it("gets a success response from SendGrid when sending", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                var email = new models.Email();
                var response = {};

                email.addTo(emailOpts.to);
                email.setFrom('foo@bar.com');
                email.setSubject('Foobar subject 2!');
                email.setText('This is the body!');

                response = sendgrid.send(email);

                expect(response).toBeTypeOf('struct');
                expect(response['message']).toBe("success");
            });
            it( "gets a success response from SendGrid with attachment from path", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                var email = new models.Email(emailOpts);
                var response = {};

                email.addFile({filename: 'path-image.png', path: files[1]});
                email.addFile({filename: 'stuff.txt', path: files[2]});

                response = sendgrid.send(email);
                expect(response['message']).toBe("success");
            });
            it( "should clear temp files in ramdisk after sending", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                var email = new models.Email(emailOpts);
                var response = {};
                var rampaths = ['', ''];

                email.addFile({filename: 'path-image.png', path: files[1]});
                email.addFile({filename: 'path-image2.png', path: files[1]});

                rampaths[1] = email.files[1].ramDiskFolder;
                rampaths[2] = email.files[2].ramDiskFolder;

                response = sendgrid.send(email);
                expect(response['message']).toBe("success");

                expect(directoryExists(rampaths[1])).toBeFalse();
                expect(directoryExists(rampaths[2])).toBeFalse();
            });
            it( "gets a success response from SendGrid with attachment from url", function(){
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                var email = new models.Email(emailOpts);
                var response = {};
                var rampaths = ['', ''];

                email.addFile({filename: 'path-image.png', url: uri});
                email.addFile({filename: 'path-image2.png', url: uri});

                rampaths[1] = email.files[1].ramDiskFolder;
                rampaths[2] = email.files[2].ramDiskFolder;

                response = sendgrid.send(email);
                expect(response['message']).toBe("success");

                expect(directoryExists(rampaths[1])).toBeFalse();
                expect(directoryExists(rampaths[2])).toBeFalse();
            });
            it( "gets a success response from SendGrid with inline content attachments (cid)", function(){
                var response = {};
                var sendgrid = new models.services.SendGrid(sgusername, sgpassword);
                var opts = structCopy(emailOpts);
                opts.text = '';
                opts.html = '<p>This is an image <img src="cid:1234567"></img></p>';
                opts.to = emailOpts.to;
                var email = new models.Email(opts);
                email.addFile({filename: 'path-image.png', filePath: files[1], cid: '1234567', contentType: 'image/png'});

                response = sendgrid.send(email);
                expect(response['message']).toBe("success");
            });
        });
    }
}