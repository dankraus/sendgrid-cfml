/**
*
* @file  models/SendGrid.cfc
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

		this.url  = structKeyExists(arguments.options, "url") ? arguments.options.url : "#protocol#://#host##port##endpoint#";

		return this;
	}

	public function send(required Email email){
		var form = arguments.email.toWebFormat();
		var response = [];
		form["api_user"] = this.apiUsername;
		form["api_key"] = this.apiPassword;
		response = makeRequest(form);

		return response;
	}

	private function makeRequest(required struct form){
		var response = "";
		var http = new http();
		http.setMethod("post");
	    http.setUrl(this.url);
	    arguments.form.each(function(key, val){
	    	http.addParam(type="formfield", name=key, value=val);
	    });
	    response = http.send().getPrefix().filecontent;

		return deserializeJSON(response);
	}
}