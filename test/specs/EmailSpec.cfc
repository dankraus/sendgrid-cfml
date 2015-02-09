component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    // executes before all suites+specs in the run() method
    function beforeAll(){
        addMatchers( {
            toExist : function( expectation, args={} ){ return len(expectation) gte 0; }
        } );

    }

    // executes after all suites+specs in the run() method
    function afterAll(){
    }

/*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        var options = {
            to        : 'cosmo.kramer@kramerica.com',
            from      : 'art.vandelay@vandelayindustries.com',
            subject   : 'Import/Export Business',
            text      : 'You should import chips (potato and corn) and export diapers.'
        };
        var files = [
            expandPath("/test/resources/assets/logo.png"),
            expandPath("/test/resources/assets/secret.txt")
        ];
        var uri = 'http://i.imgur.com/HnAga.png';


        describe("initlizations", function(){
            it("initializes", function(){
                var email = new models.Email();
                expect(email).toBeInstanceOf('Email');
            });
            it('allows attributes to be set on init ', function() {
                var email = new models.Email(options);
                for(var option in options){
                    expect(options[option]).toBe(email[option]);
                }
            });
        });

        describe("toWebFormat()", function(){
            it( "should return a Web API format correctly", function(){
                var email = new models.Email(options);
                var format = email.toWebFormat();

                expect(format.to).toBe(options.to);
                expect(format.from).toBe(options.from);
                expect(format.subject).toBe(options.subject);
                expect(format.text).toBe(options.text);
                expect(format).notToHaveKey('toname');
                expect(format).notToHaveKey('fromname');
            });
            it('should have multiple TOs if as an array', function() {
                var opts = structCopy(options);
                opts.to = ['kenny.bania@roundtine.com', 'bob.sacamano@kramerica.com'];
                var email = new models.Email(opts);
                var format = email.toWebFormat();

                expect(format.to).toBe(opts.to);
            });
            it( "should not have multiple TOs if to is array and also set on smtpapi via addTo", function(){
                var opts = structCopy(options);
                opts.to = ['kenny.bania@roundtine.com', 'bob.sacamano@kramerica.com'];
                var email = new models.Email(opts);
                email.addTo(opts.to[1]);
                email.addTo(opts.to[2]);
                var format = email.toWebFormat();

                expect(format.to).toBe(opts.from);
            });
            it( "should have multiple BCCs if as an array", function(){
                var opts = structCopy(options);
                opts.bcc = ['kenny.bania@roundtine.com', 'bob.sacamano@kramerica.com'];
                var email = new models.Email(opts);
                var format = email.toWebFormat();
                expect(format.bcc).toBe(opts.bcc);
            });
            it( "should have multiple CCs if as an array", function(){
                var opts = structCopy(options);
                opts.cc = ['kenny.bania@roundtine.com', 'bob.sacamano@kramerica.com'];
                var email = new models.Email(opts);
                var format = email.toWebFormat();
                expect(format.cc).toBe(opts.cc);
            });
            it( "should not have a field for undefined files", function(){
                var email = new models.Email(options);
                var format = email.toWebFormat();

                expect(format.to).toBe(options.to);
                expect(format.from).toBe(options.from);
                expect(format.subject).toBe(options.subject);
                expect(format.text).toBe(options.text);
                expect(format).notToHaveKey('fromname');
                expect(format).notToHaveKey('toname');
                expect(format).notToHaveKey('files[undefined]');
            });
            it( "should not have a to address if there is no to or no smtpapi", function(){
                var email = new models.Email({ from: 'test@test.com',
                                                            subject: 'testing',
                                                            text: 'testing' });
                expect(email.to).toHaveLength(0);
            });
            it( "should have a to address if there is no to but there is an smtpapi to", function(){
                var opts = structCopy(options);
                opts.to = '';
                var email = new models.Email(opts);
                email.addTo('test@test.com');
                var format = email.toWebFormat();

                expect(serializeJson(format['x-smtpapi'])).notToHaveLength(0);
                expect(format.to).notToHaveLength(0);
            });
            it( "should set a fromname if one is provided", function(){
                var opts = structCopy(options);
                var email = new models.Email({ from: 'test@test.com',
                                                            fromname:'Tester T. Testerson',
                                                            subject: 'testing',
                                                            text: 'testing' });
                expect(email.fromname).toBe('Tester T. Testerson');
            });
            it( "should set a date if one is provided", function(){
                var email = new models.Email({ from: 'test@test.com',
                                                            fromname:'Tester T. Testerson',
                                                            subject: 'testing',
                                                            date: 'Wed, 15 Dec 2014 19:21:16 +0000',
                                                            text: 'testing' });
                expect(email.date).toBe('Wed, 15 Dec 2014 19:21:16 +0000');
                email.setDate('Wed, 17 Dec 2013 19:21:16 +0000');
                expect(email.date).toBe('Wed, 17 Dec 2013 19:21:16 +0000');
            });
            it( "should set a toname if one is provided", function(){
                var email = new models.Email({ from: 'test@test.com',
                                                            to: 'test1@test.com',
                                                            toname:'Tester T. Testerson',
                                                            subject: 'testing',
                                                            text: 'testing' });
                var format = email.toWebFormat();
                expect(format.toname).toBe('Tester T. Testerson');
            });
            it( "should set multiple tonames if several are provided", function(){
                var email = new models.Email({ from: 'test@test.com',
                                                            to: ['test1@test.com', 'test2@test.com'],
                                                            toname: ['Tester T. Testerson', 'Test2 M. Testerson'],
                                                            subject: 'testing',
                                                            text: 'testing' });
                var format = email.toWebFormat();
                expect(format.toname[1]).toBe('Tester T. Testerson');
                expect(format.toname[2]).toBe('Test2 M. Testerson');
            });
            it( "should be possible to setFrom", function(){
                var email = new models.Email();
                expect(email.from).toHaveLength(0);
                email.setFrom('thedrake@company.com');
                expect(email.from).toBe('thedrake@company.com');
            });
            it( "should be possible to setSubject", function(){
                var email = new models.Email();
                expect(email.from).toHaveLength(0);
                email.setSubject('Del Bocha Vista');
                expect(email.subject).toBe('Del Bocha Vista');
            });
            it( "should be possible to setText", function(){
                var email = new models.Email();
                expect(email.text).toHaveLength(0);
                email.setText('Do you ever get down on your knees and thank God you know me and have access to my dementia?');
                expect(email.text).toBe('Do you ever get down on your knees and thank God you know me and have access to my dementia?');
            });
            it( "should be possible to setHtml", function(){
                var email = new models.Email();
                expect(email.html).toHaveLength(0);
                email.setHtml('<p>Hello, Newman...</p>');
                expect(email.html).toBe('<p>Hello, Newman...</p>');
            });
            it( "should be possible to setDate", function(){
                var email = new models.Email();
                expect(email.date).toHaveLength(0);
                email.setDate('Wed, 17 Dec 2014 19:21:16 +0000');
                expect(email.date).toBe('Wed, 17 Dec 2014 19:21:16 +0000');
            });
            it( "should be possible to setSendAt", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBeEmpty(0);
                email.setSendAt(1409348513);
                expect(email.smtpapi.header.send_at).toBe(1409348513);
                expect(email.smtpapi.header.send_each_at).toBeEmpty();
            });
            it( "should be possible to setSendEachAt", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBeEmpty(0);
                email.setSendEachAt([1409348513, 1409348514]);
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBe([1409348513, 1409348514]);
            });
            it( "should be possible to addSendEachAt", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBeEmpty(0);
                email.addSendEachAt(1409348513);
                email.addSendEachAt(1409348514);
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBe([1409348513, 1409348514]);
            });
            it( "should be possible to setSendEachAt and addSendEachAt", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBeEmpty(0);
                email.setSendEachAt([1409348513]);
                email.addSendEachAt(1409348514);
                expect(email.smtpapi.header.send_at).toHaveLength(0);
                expect(email.smtpapi.header.send_each_at).toBe([1409348513, 1409348514]);
            });
            it( "should be possible to addUniqueArg", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.unique_args).toBeEmpty();
                email.addUniqueArg('unique_arg1', 'value');
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg1': 'value'});
                email.addUniqueArg('unique_arg2', 'value');
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg1': 'value', 'unique_arg2': 'value'});
            });
            it( "should be possible to setUniqueArgs", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.unique_args).toBeEmpty();
                email.setUniqueArgs({'unique_arg1': 'value'});
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg1': 'value'});
                email.setUniqueArgs({'unique_arg2': 'value'});
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg2': 'value'});
            });
            it( "should be possible to setUniqueArgs and addUniqueArg", function(){
                var email = new models.Email();
                expect(email.smtpapi.header.unique_args).toBeEmpty();
                email.setUniqueArgs({'unique_arg1': 'value'});
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg1': 'value'});
                email.addUniqueArg('unique_arg2', 'value');
                expect(email.smtpapi.header.unique_args).toBe({'unique_arg1': 'value', 'unique_arg2': 'value'});
            });
            it( "should be possible to addCc", function(){
                var email = new models.Email();
                expect(email.cc).toBeEmpty();
                email.addCc('morty.seinfeld@delbochavista.com');
                expect(email.cc).toBe(['morty.seinfeld@delbochavista.com']);
                email.addCc('helen.seinfeld@delbochavista.com');
                expect(email.cc).toBe(['morty.seinfeld@delbochavista.com', 'helen.seinfeld@delbochavista.com']);
            });
            it( "should be possible to setCcs", function(){
                var email = new models.Email();
                expect(email.cc).toBeEmpty();
                email.setCcs(['morty.seinfeld@delbochavista.com']);
                expect(email.cc).toBe(['morty.seinfeld@delbochavista.com']);
                email.setCcs(['helen.seinfeld@delbochavista.com']);
                expect(email.cc).toBe(['helen.seinfeld@delbochavista.com']);
            });
            it( "should be possible to setCcs and addCc", function(){
                var email = new models.Email();
                expect(email.cc).toBeEmpty();
                email.setCcs(['morty.seinfeld@delbochavista.com']);
                expect(email.cc).toBe(['morty.seinfeld@delbochavista.com']);
                email.addCc('helen.seinfeld@delbochavista.com');
                expect(email.cc).toBe(['morty.seinfeld@delbochavista.com', 'helen.seinfeld@delbochavista.com']);
            });
            it( "shoulld be possible to setFilters", function(){
                var email = new models.Email();
                var theFilter = {'filterName': {'someSetting': 'theValue'}};
                email.setFilters(theFilter);
                expect(email.smtpapi.header.filters).toBe(theFilter);
            });
            it( "shoulld be possible to addFilters", function(){
                var email = new models.Email();
                email.addFilter('someFilter', 'someSetting', 'theValue');
                    expect(email.smtpapi.header.filters).toBe({ 'someFilter': {'settings': {'someSetting': 'theValue'} } });
            });
            it( "should error when missing, to, from, subject, and text or html", function(){
                expect(function(){
                    var email = new models.Email({to: 'joel.ripken@seinfeld.com'});
                    email.toWebFormat();
                }).toThrow('exception', 'Email must include to, from, subject, and text or html');
                expect(function(){
                    var email = new models.Email({from: 'joel.ripken@seinfeld.com'});
                    email.toWebFormat();
                }).toThrow('exception', 'Email must include to, from, subject, and text or html');
                expect(function(){
                    var email = new models.Email({subject: 'The jerk store called...'});
                    email.toWebFormat();
                }).toThrow('exception', 'Email must include to, from, subject, and text or html');
                expect(function(){
                    var email = new models.Email({text: "..and they're running out of you!"});
                    email.toWebFormat();
                }).toThrow('exception', 'Email must include to, from, subject, and text or html');
                expect(function(){
                    var email = new models.Email({to: "reilly@nyyankees.com",
                                                               from: "g.costanza@nyyankees.cm",
                                                               subject: "The jerk store called..."});
                    email.toWebFormat();
                }).toThrow('exception', 'Email must include to, from, subject, and text or html');


                expect(function(){
                    var email = new models.Email({to: "reilly@nyyankees.com",
                                                               from: "g.costanza@nyyankees.cm",
                                                               subject: "The jerk store called...",
                                                               text: "..and they're running out of you!"});
                    var format = email.toWebFormat();
                }).notToThrow('exception', 'Email must include to, from, subject, and text or html');
                expect(function(){
                    var email = new models.Email({to: "reilly@nyyankees.com",
                                                               from: "g.costanza@nyyankees.cm",
                                                               subject: "The jerk store called...",
                                                               html: "<p>..and they're running out of you!</p>"});
                    var format = email.toWebFormat();
                }).notToThrow('exception', 'Email must include to, from, subject, and text or html');
            });
        });

        describe( "files", function(){
            it( "should support adding attachments via path", function(){
                var email = new models.Email(options);
                var format = {};
                email.addFile({filename: 'path-image.png', path: files[1]});
                expect(email.files[1].filename).toBe('path-image.png');
                expect(email.files[1].contentType).toBe('image/png');

                format = email.toWebFormat();
                expect(format).toHaveKey('files[path-image.png]');
            });
            it( "should support attachments via url", function(){
                var email = new models.Email(options);
                var format = {};
                email.addFile({filename: 'path-image.png', url: uri});
                expect(email.files[1].filename).toBe('path-image.png');
                expect(email.files[1].contentType).toBe('image/png');

                format = email.toWebFormat();
                expect(format).toHaveKey('files[path-image.png]');
            });
            it( "should support inline content - cid", function(){
                var email = new models.Email(options);
                var format = {};
                email.addFile({ filename: 'content-image.png', filePath: files[1], cid: 'testcid', contentType: 'image/png'});
                expect(email.files[1].filename).toBe('content-image.png');
                expect(email.files[1].cid).toBe('testcid');
                expect(email.files[1].contentType).toBe('image/png');

                format = email.toWebFormat();
                expect(format).toHaveKey('content[content-image.png]');
                expect(format['content[content-image.png]']).toBe('testcid');
            });
            it( "should add inline content (cids) to content array in web format", function(){
                 var email = new models.Email(options);
                var format = {};
                email.addFile({ filename: 'content-image.png', filePath: files[1], cid: 'testcid', contentType: 'image/png'});
                format = email.toWebFormat();
                expect(format).toHaveKey('content[content-image.png]');
                expect(format['content[content-image.png]']).toBe('testcid');
                expect(format).toHaveKey('files[content-image.png]');
            });
            it( "should clear temp files in ramdisk for files added via path", function(){
                var email = new models.Email();
                var rampath = '';
                email.addFile({filename: 'path-image.png', path: files[1]});
                var rampath = email.files[1].ramDiskFolder;
                email.clearRamDiskFiles();
                expect(directoryExists(rampath)).toBeFalse();
            });
            it( "should clear temp files in ramdisk for files added via url", function(){
                var email = new models.Email();
                var rampath = '';
                email.addFile({filename: 'path-image.png', url: uri});
                var rampath = email.files[1].ramDiskFolder;
                email.clearRamDiskFiles();
                expect(directoryExists(rampath)).toBeFalse();
            });
        });

        describe( "custom headers", function(){
            var customHeaders = { 'droid': 'r2d2', 'alien': 'jawa' };
            it( "should allow setting custom headers via setHeaders", function(){
                var email = new models.Email();
                expect(email.headers).toBeEmpty();
                email.setHeaders(customHeaders);
                expect(email.headers).toBe(customHeaders);
            });
            it( "should allow adding custom headers with key/value", function(){
                var email = new models.Email();
                expect(email.headers).toBeEmpty();
                email.addHeader('ship', 'xwing');
                expect(email.headers.ship).toBe('xwing');
            });
            it( "should be able to add multiple custom headers", function(){
                var email = new models.Email();
                expect(email.headers).toBeEmpty();
                email.addHeader('droid', 'r2d2');
                email.addHeader('alien', 'jawa');
                expect(email.headers).toBe(customHeaders);
            });
            it( "should overwrite headers when calling addHeader with the same key", function(){
                var email = new models.Email();
                expect(email.headers).toBeEmpty();
                email.addHeader('ship', 'xwing');
                email.addHeader('ship', 'falcon');
                expect(email.headers.ship).toBe('falcon')
            });
        });





    }

}