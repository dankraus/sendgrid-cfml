/**
*
* @file  models/SendGrid.cfc
* @author Dan Kraus
*
*/

component output="false" displayname="SendGrid"  {

	public function init(required string username, required string password, struct options = {}){
		var protocol = structKeyExists(arguments.options, "protocol") ? arguments.options.protocol : 'https';
		var host = structKeyExists(arguments.options, "host") ? arguments.options.host : 'api.sendgrid.com';
		var port = structKeyExists(arguments.options, "port") ? ":#arguments.options.port#" : '';
		var endpoint = structKeyExists(arguments.options, "endpoint") ? arguments.options.endpoint : '/api/mail.send.json';

		this.username = arguments.username;
		this.password = arguments.password;

		this.url  = structKeyExists(arguments.options, "url") ? arguments.options.url : "#protocol#://#host##port##endpoint#";

		return this;
	}
}