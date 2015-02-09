/**
*
* @file  models/Email.cfc
* @author Dan Kraus
*
*/

component output="false" displayname="Email"   {


    public Email function init(struct params){
        var config   = isDefined("arguments.params") ? arguments.params : {};
        this.smtpapi = new SMTPAPI();
        this.to      = isDefined("config.to")      ? config.to      : [];
        this.from    = isDefined("config.from")    ? config.from    : '';
        this.subject = isDefined("config.subject") ? config.subject : '';
        this.text    = isDefined("config.text")    ? config.text    : '';
        this.html    = isDefined("config.html")    ? config.html    : '';
        this.cc      = isDefined("config.cc")      ? config.cc      : [];
        this.bcc     = isDefined("config.bcc")     ? config.bcc     : [];
        this.replyto = isDefined("config.replyto") ? config.replyto : '';
        this.date    = isDefined("config.date")    ? config.date    : '';
        this.headers = isDefined("config.headers") ? config.headers : {};

        //these shouldn't have defaults if they have not been provided
        if(isDefined("config.toname")){
            this.toname = config.toname;
        }
        if(isDefined("config.fromname")){
            this.fromname = config.fromname;
        }

        this.files = [];
        if(isDefined("config.files")){
            for(var file in config.files){
                this.files.add(new Attachment(file));
            }
        }

        return this;
    }

    public struct function toWebFormat(){
        var web = {
            'to'         : this.to,
            'from'       : this.from,
            'subject'    : this.subject,
            'text'       : this.text,
            'html'       : this.html,
            'headers'    : serializeJSON(this.headers),
            'x-smtpapi'  : this.smtpapi.toJSON(),
        };

        if (this.bcc.len())         { web['bcc']          = this.bcc; }
        if (this.cc.len())          { web['cc']           = this.cc; }
        if (this.html.len())        { web['html']         = this.html; }
        if (this.replyto.len())     { web['replyto']      = this.replyto; }
        if (this.date.len())        { web['date']         = this.date; }
        if (this.smtpapi.header.to.len()) { web['to'] = "";}

        if(isDefined("this.toname")){
            web['toname'] = this.toname;
        }
        if(isDefined("this.fromname")){
            web['fromname'] = this.fromname;
        }

        //update missing to
        //when you do multiple addTo(), and no to as been set,
        //sent it to the from address too
        if (this.smtpapi.header.to.len() gt 0) {
            web['to'] = this.from;
        }

        if(this.files.len()){
            this.files.each(function(file){
                web['files[#file.filename#]'] = {
                    filename: file.filename,
                    contentType: file.contentType,
                    content: file.content,
                    cid: file.cid,
                    ramPath: file.ramPath
                }
                if(file.cid.len()){
                    web['content[#file.filename#]'] = file.cid;
                }
            });
        }

        if((web['to'].len() == 0 || web['from'].len() == 0 || web['subject'].len() == 0)
            || (web['text'].len() == 0 && web['html'].len() == 0) ){
            throw(type="exception", message="Email must include to, from, subject, and text or html");
        }

        return web;
    }


    public void function addTo(required to){
        this.smtpapi.addTo(arguments.to);
    }


    public void function setDate(required string date) {
        this.date = arguments.date;
    }


    public void function setFrom(required string from) {
        this.from = arguments.from;
    }


    public void function setSubject(required string subject) {
        this.subject = arguments.subject;
    }

    public void function setText(required string text) {
        this.text = arguments.text;
    }

    public void function setHtml(required string html) {
        this.html = arguments.html;
    }


    public void function setSendAt(required numeric unixTime) {
        this.smtpapi.setSendAt(arguments.unixTime);
    }


    public void function setSendEachAt(required time) {
        this.smtpapi.setSendEachAt(arguments.time);
    }


    public void function addSendEachAt(required time) {
        this.smtpapi.addSendEachAt(arguments.time);
    }


    public void function setUniqueArgs(required struct args) {
        this.smtpapi.setUniqueArgs(args);
    }


    public void function addUniqueArg(required string key, required string val) {
        this.smtpapi.addUniqueArg(arguments.key, arguments.val);
    }


    public void function addCc(required string cc) {
        this.cc.add(arguments.cc);
    }

    public void function setCcs(required ccs) {
        this.cc = arguments.ccs;
    }


    public void function addFile(required struct fileStruct) {
        var path = structKeyExists(arguments.fileStruct, 'path') ? arguments.fileStruct.path : '';
        var uri = structKeyExists(arguments.fileStruct, 'url') ? arguments.fileStruct.url : '';
        var cid = structKeyExists(arguments.fileStruct, 'cid') ? arguments.fileStruct : {};
        var filename = structKeyExists(arguments.fileStruct, 'filename') ? arguments.fileStruct.filename : '';

        var handler = new Attachment(path=path,
                                      url=uri,
                                      cid=cid,
                                      filename=filename);

        this.files.add(handler);
    }


    public void function setHeaders(required struct headers) {
        this.headers = arguments.headers;
    }


    public void function addHeader(required string key, required string val) {
        if(structKeyExists(this.headers, arguments.key)){
            this.headers[arguments.key] = arguments.val;
        } else {
            this.headers[arguments.key] = arguments.val;
        }
    }


    public void function setFilters(required struct filters) {
        this.smtpapi.setFilters(filters);
    }


    public void function addFilter(required string filter, required string setting, required string val) {
        this.smtpapi.addFilter(arguments.filter, arguments.setting, arguments.val);
    }


    public void function clearRamDiskFiles(){
        this.files.each(function(file){
            file.deleteFromRamDisk();
        });
    }
}