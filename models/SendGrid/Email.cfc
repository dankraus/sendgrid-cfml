/**
*
* @file  models/SendGrid/Email.cfc
* @author Dan Kraus
*
*/
// $to,
//          $from,
//          $from_name,
//          $reply_to,
//          $cc_list,
//          $bcc_list,
//          $subject,
//          $text,
//          $html,
//          $date,
//          $content,
//          $headers,
//          $smtpapi,
//          $attachments;

component accessors="true" output="false" displayname="Email"   {
	property name="tos" type="array";
	property name="from" type="string";
	property name="fromName" type="string";
	property name="replyTo" type="string";
	property name="ccS" type="array";
	property name="bccS" type="array";
	property name="subject" type="string";


	public function init(){
		setTos([]);
		setCCs([]);
		setBCCs([]);
		return this;
	}


	public Email function addTo(required string address, string name) {
		addr = structKeyExists(arguments, "name") ? "#arguments.name# <#arguments.address#>" : arguments.address;
  		setTos(getTos().append(addr));
		return this;
	}


	public function getFrom(boolean asStruct=false){
		if(arguments.asStruct){
			return { "#variables.from#": getFromName() };
		} else {
			return variables.from;
		}
	}

	public Email function setCC(required string address){
		setCCs([arguments.address]);
		return this;
	}

	public Email function addCC(required string address){
		setCCs(getCCs().append(arguments.address));
		return this;
	}

	public Email function removeCC(required string address){
		var address = arguments.address;
		var addresses = getCCs();
		addresses = addresses.filter(function(addr){
			return arguments.addr NEQ address;
		});
		setCCs(addresses);
		return this;
	}

	public Email function setBCC(required string address){
		setBCCs([arguments.address]);
		return this;
	}

	public Email function addBCC(required string address){
		setBCCs(getBCCs().append(arguments.address));
		return this;
	}

	public Email function removeBCC(required string address){
		var address = arguments.address;
		var addresses = getBCCs();
		addresses = addresses.filter(function(addr){
			return arguments.addr NEQ address;
		});
		setBCCs(addresses);
		return this;
	}

	public function toWebFormat(){

	}
}