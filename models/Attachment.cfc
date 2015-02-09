/**
*
* @file  models/Attachment.cfc
* @author Dan Kraus
* @description Handle files for SendGrid emails.
*
*/

component output="false" displayname="Attachment"  {

    public function init(string path,
                         string url,
                         struct cid,
                         string filename=''){
        this.filename = arguments.filename;
        this.cid = isDefined("arguments.cid") ? arguments.cid : '';
        this.ramDiskFolder = 'ram:///sendgrid-cfml#GetTickCount()#/';
        this.ramPath = '';
        this.content = '';

        if(isDefined("arguments.path") && arguments.path.len()){
            initWithPath(arguments.path);
        } else if(isDefined("arguments.url") && arguments.url.len()){
            initWithUrl(arguments.url);
        } else if(isDefined("arguments.cid") && structCount(arguments.cid) > 0 ){
            if( structKeyExists(arguments.cid, "cid")
                && structKeyExists(arguments.cid, "filePath")
                && structKeyExists(arguments.cid, "contentType") ){

                initWithCid(cid=arguments.cid.cid, filePath=arguments.cid.filePath, contentType=arguments.cid.contentType);
            } else {
                throw(type="exception", message="cid argument must be a struct containing keys for 'cid', and 'filePath', and 'contentType'");
            }
        } else {
            throw(type="exception", message="Unrecognized Attachment type. Must pass in 'url', 'path', or 'cid'.");
        }

        return this;
    }


    public void function deleteFromRamDisk() {
        fileDelete(this.ramPath);
        if(directoryList(this.ramDiskFolder).size() == 0){
            directoryDelete(this.ramDiskFolder);
        }
    }


    private void function initWithPath(required string path) {
        var file = fileOpen(arguments.path);
        var bin = fileReadBinary(arguments.path);
        this.type = 'path';
        this.path = arguments.path;

        if(this.filename == ''){
            this.filename = file.name;
        }

        this.contentType = fileGetMimeType(file);
        this.ramPath = writeToRamDisk(this.filename, bin);
    }


    private void function initWithUrl(required string url) {
        var http = new http();
        var response = {};
        this.url = arguments.url;
        this.type = 'url';

        http.setMethod("get");
        http.setUrl(this.url);
        response = http.send().getPrefix();

        if(this.filename == ''){
            this.filename = listLast(this.url, '/');
        }
        this.contentType = response.mimeType;
        this.ramPath = writeToRamDisk(this.filename, response.filecontent);
    }

    private void function initWithCid(required string cid, required string filePath, required string contentType){
        var file = fileOpen(arguments.filePath);
        var bin = fileReadBinary(arguments.filePath);
        this.type = 'cid';
        this.cid = arguments.cid;
        this.contentType = arguments.contentType;

        if(this.filename == ''){
            this.filename = file.name;
        }

        this.ramPath = writeToRamDisk(this.filename, bin);
    }
    private string function writeToRamDisk(required string filename, required binary content) {
        var ramPath = '#this.ramDiskFolder##arguments.filename#';
        if(not directoryExists(this.ramDiskFolder)){
            directoryCreate(this.ramDiskFolder);
        }
        fileWrite('#this.ramDiskFolder##arguments.filename#', arguments.content);

        return ramPath;
    }



}