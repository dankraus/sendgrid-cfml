component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

    // executes before all suites+specs in the run() method
    function beforeAll(){
        this.jsonString = deserializeJSON(fileRead(expandPath("/test/resources/smtpapi_test.json")));
    }

    // executes after all suites+specs in the run() method
    function afterAll(){
    }

/*********************************** BDD SUITES ***********************************/

    function run( testResults, testBox ){
        // all your suites go here.
        describe( "SMTPAPI", function(){
            it( "has a jsonString method", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                expect(smtpapi.toJSON()).toBe(this.jsonString['json_string']);
            });
            it( "setTos", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setTos(['george@costanzaandson.com'])
                expect(smtpapi.toJSON()).toBe(this.jsonString['set_tos']);
            });
            it( "addTo", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addTo('frank@costanzaandson.com');
                expect(smtpapi.toJSON()).toBe(this.jsonString['add_to']);
            });
            it( "setSubstitutions", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSubstitutions({'sub': ['val']});
                expect(smtpapi.toJson()).toBe(this.jsonString['set_substitutions']);
            });
            it( "addSubstitution", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addSubstitution('sub', 'val');
                expect(smtpapi.toJson()).toBe(this.jsonString['add_substitution']);
            });
            it( "addSubstitution array value", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSubstitutions({'subkey': ['val 1']});
                smtpapi.addSubstitution('subkey', ['val 2']);
                expect(smtpapi.toJson()).toBe(this.jsonString['add_substitution_array_value']);
            });
            it( "setUniqueArgs", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setUniqueArgs({'set_unique_argument_key': 'set_unique_argument_value'});
                expect(smtpapi.toJson()).toBe(this.jsonString['set_unique_args']);
            });
            it( "addUniqueArg", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addUniqueArg('add_unique_argument_key', 'add_unique_argument_value');
                smtpapi.addUniqueArg('add_unique_argument_key_2', 'add_unique_argument_value_2');
                //CFML really doesn't keep the order of keys in structs in tact.
                //run this test by converting our toJson string to a struct
                //and with converting our sample JSON to a struct for comparison
                //struct == struct regardless of key order. as long as keys and values match...
                //...we cool.
                expect(
                    deserializeJson(smtpapi.toJson())
                ).toBe(
                    deserializeJson(this.jsonString['add_unique_arg'])
                );
            });
            it( "setCategories", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setCategories(['setCategories']);
                expect(smtpapi.toJson()).toBe(this.jsonString['set_categories'])
            });
            it( "addCategory", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addCategory('addCategory');
                smtpapi.addCategory('addCategory2');
                expect(smtpapi.toJson()).toBe(this.jsonString['add_category']);
            });
            it( "addCategoryUnicode", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addCategory('カテゴリUnicode');
                smtpapi.addCategory('カテゴリ2Unicode');
                expect(smtpapi.toJson()).toBe(this.jsonString['add_category_unicode']);
            });
            it( "setSections", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSections({'set_section_key': 'set_section_value'});
                expect(smtpapi.toJson()).toBe(this.jsonString['set_sections']);
            });
            it( "addSection", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addSection('set_section_key', 'set_section_value');
                smtpapi.addSection('set_section_key_2', 'set_section_value_2');
                //..again. CFML really doesn't keep the order of keys in structs in tact.
                //run this test by converting our toJson string to a struct
                //and with converting our sample JSON to a struct for comparison
                //struct == struct regardless of key order. as long as keys and values match...
                //...we cool.
                expect(
                    deserializeJson(smtpapi.toJson())
                ).toBe(
                    deserializeJson(this.jsonString['add_section'])
                );
            });
            it( "addFilter", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addFilter('footer', 'text/html', '<strong>boo</strong>');
                expect(
                    deserializeJson(smtpapi.toJson())
                ).toBe(
                    deserializeJson(this.jsonString['add_filter'])
                );
            });
            it( "setFilters", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                var filter = {
                    'footer': {
                        'setting': {
                            'enable': 1,
                            'text/plain': 'You can haz footers!'
                        }
                    }
                };
                smtpapi.setFilters(filter);

                expect(
                    deserializeJson(smtpapi.toJson())
                ).toBe(
                    deserializeJson(this.jsonString['set_filters'])
                );
            });
            it( "setSendAt", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSendAt(1409348513);
                expect(smtpapi.toJson()).toBe(this.jsonString['set_send_at']);
            });
            it( "setSenEachdAt", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSendEachAt([1409348513, 1409348514, 1409348515]);
                expect(smtpapi.toJson()).toBe(this.jsonString['set_send_each_at']);
            });
            it( "addSendEachAt", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addSendEachAt(1409348513);
                smtpapi.addSendEachAt(1409348514);
                smtpapi.addSendEachAt(1409348515);
                expect(smtpapi.toJson()).toBe(this.jsonString['add_send_each_at']);
            });
            it( "setSendEachAt and addSendEachAt", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSendEachAt([1409348513]);
                smtpapi.addSendEachAt(1409348514);
                smtpapi.addSendEachAt(1409348515);
                expect(smtpapi.toJson()).toBe(this.jsonString['add_send_each_at']);
            });
            it( "setSendAt clears out send_each_at", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.addSendEachAt(1409348515);
                smtpapi.setSendAt(1409348513);

                expect(smtpapi.toJson()).toBe(this.jsonString['set_send_at']);
                expect(
                    smtpapi['header']['send_each_at']
                ).toBe([]);
            });
            it( "setSendEachAt clears out send_at", function(){
                var smtpapi = new SendGridCFML.models.SMTPAPI();
                smtpapi.setSendAt(1409348513);
                smtpapi.setSendEachAt([1409348513, 1409348514, 1409348515]);
                expect(smtpapi.toJson()).toBe(this.jsonString['set_send_each_at']);
                expect(
                    smtpapi['header']['send_at']
                ).toBe('');
            });
        });
    }

}