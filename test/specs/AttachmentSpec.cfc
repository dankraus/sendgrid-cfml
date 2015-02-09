
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
        // all your suites go here.
        var files = [
            expandPath("/test/resources/assets/logo.png"),
            expandPath("/test/resources/assets/secret.txt")
        ];
        var uri = 'http://i.imgur.com/HnAga.png';

        describe( "Attachment", function(){
            it( "should handle files from the filesystem", function(){
                var handler = new models.Attachment(path=files[2], filename='sg.txt');
                expect(handler.type).toBe('path');
                expect(handler.path).toBe(files[2]);
                expect(handler.filename).toBe('sg.txt');
                expect(handler.contentType).toBe('text/plain');
            });
            it( "should handle files from a url", function(){
                var handler = new models.Attachment(url=uri, filename="esb.jpg");
                expect(handler.type).toBe('url');
                expect(handler.url).toBe(uri);
                expect(handler.filename).toBe('esb.jpg');
                expect(handler.contentType).toBe('image/png');
            });
            it( "should figure out the filename if one is not provided for path type", function(){
                var handler = new models.Attachment(path=files[2]);
                expect(handler.type).toBe('path');
                expect(handler.path).toBe(files[2]);
                expect(handler.filename).toBe('secret.txt');
                expect(handler.contentType).toBe('text/plain');
            });
            it( "should figure out the filename if one is not provided for url type", function(){
                var handler = new models.Attachment(url=uri);
                expect(handler.type).toBe('url');
                expect(handler.url).toBe(uri);
                expect(handler.filename).toBe('HnAga.png');
                expect(handler.contentType).toBe('image/png');
            });
            it( "should handle inline content", function(){
                var cidData = { cid: 'testcid', filePath: files[1], contentType: 'image/jpeg' };
                var handler = new models.Attachment(cid=cidData);
                expect(handler.type).toBe('cid');
                expect(handler.contentType).toBe('image/jpeg');
                expect(handler.cid).toBe('testcid');
            });
            it( "should throw error when Attachment cid is passed in and content, or contentType is has not been provided", function(){
                expect(function(){
                    var cidData = { cid: 'testcid' };
                    var handler = new models.Attachment(cid=cidData);
                }).toThrow("exception", "cid argument must be a struct containing keys for 'cid', and 'filePath', and 'contentType'");
                expect(function(){
                    var cidData = { contentType: 'image/jpeg' };
                    var handler = new models.Attachment(cid=cidData);
                }).toThrow("exception", "cid argument must be a struct containing keys for 'cid', and 'filePath', and 'contentType'");
                expect(function(){
                    var cidData = { filePath: path=files[1] };
                    var handler = new models.Attachment(cid=cidData);
                }).toThrow("exception", "cid argument must be a struct containing keys for 'cid', and 'filePath', and 'contentType'");
            });
            it( "should throw error when path, url, or, cid has not been provided", function(){
                expect(function(){
                    var handler = new models.Attachment();
                }).toThrow("exception", "Unrecognized Attachment type. Must pass in 'url', 'path', or 'cid'.");
            });
            it( "should write to ramdisk with file from path", function(){
                var handler = new models.Attachment(path=files[2], filename='sg.txt');
                var ramPath = handler.ramPath;
                expect(fileExists(ramPath)).toBeTrue();
            });
            it( "should write to ramdisk with file from url", function(){
                var handler = new models.Attachment(url=uri);
                var ramPath = handler.ramPath;
                expect(fileExists(ramPath)).toBeTrue();
            });
            it( "should delete the file from ramdisk", function(){
                var handler = new models.Attachment(path=files[2], filename='sg.txt');
                var ramPath = handler.ramPath;
                handler.deleteFromRamDisk();
                expect(fileExists(ramPath)).toBeFalse();
            });
            it( "should delete the folder in ramdisk", function(){
                var handler = new models.Attachment(path=files[2], filename='sg.txt');
                var ramPath = handler.ramPath;
                handler.deleteFromRamDisk();
                expect(directoryExists(handler.ramDiskFolder)).tobeFalse();
            });


        });
    }

}