/**
*
* @file  SendGridCFML/models/services/SendGrid.cfc
* @author Dan Kraus
*
*/

component output="false" displayname="SendGrid"  {

    this.apiUsername = "";
    this.apiPassword = "";
    this.url = "";

    public function init(required string apiUsername, required string apiPassword, struct options = {}){
        var protocol = structKeyExists(arguments.options, "protocol") ? arguments.options.protocol : 'https';
        var host = structKeyExists(arguments.options, "host") ? arguments.options.host : 'api.sendgrid.com';
        var port = structKeyExists(arguments.options, "port") ? ":#arguments.options.port#" : '';
        var endpoint = structKeyExists(arguments.options, "endpoint") ? arguments.options.endpoint : '/api/mail.send.json';

        this.apiUsername = arguments.apiUsername;
        this.apiPassword = arguments.apiPassword;

        this.url = structKeyExists(arguments.options, "url") ? arguments.options.url : "#protocol#://#host##port##endpoint#";

        return this;
    }

    public function send(required Email email){
        var httpform = email.toWebFormat();
        var response = [];

        httpform['api_user'] = this.apiUsername;
        httpform['api_key'] = this.apiPassword;
        response = makeRequest(httpform);
        email.clearRamDiskFiles();

        return response;
    }

    private function makeRequest(required struct httpform){
        var httpResponse = '';
        var response = '';
        var http = new http();

        http.setMethod("post");
        http.setUrl(this.url);
        http.addParam(type="header", name:"User-Agent", value="sendgrid;cfml");
        arguments.httpform.each(function(key, val){
            if(findNoCase("files", key)){
                http.addParam(type="file",
                              name=key,
                              filename=val['filename'],
                              mimeType=val['contentType'],
                              file=val['ramPath']);
            } else {
                http.addParam(type="formfield", name=key, value=val);
          }
        });
        httpResponse = http.send().getPrefix();
        response = httpResponse.filecontent;

        return deserializeJSON(response);
    }
}