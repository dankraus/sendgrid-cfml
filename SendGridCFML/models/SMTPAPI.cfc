/**
*
* @file  /SendGridCFML/models/SMTPAPI.cfc
* @author Dan Kraus
* @description X-SMTPAPI Email Header builder for SendGrid emails
* escapeUnicode function reworked from:
* http://cflove.org/2009/12/format-unicode-string-for-indesign-a-coldfusion-udf.cfm
* Saman W Jayasekara @cfloveorg
*/

component output="false" displayname="SMTPAPI"  {

    public function init(struct params){

        var header = isDefined("arguments.params") ? arguments.params : {};
        this.header['to']           = isDefined("header.to")          ? header.to       : [];
        this.header['sub']          = isDefined("header.sub")         ? header.sub      : {};
        this.header['category']     = isDefined("header.category")    ? header.category : [];
        this.header['section']      = isDefined("header.section")     ? header.section  : {};
        this.header['filters']      = isDefined("header.filters")     ? header.filters  : {};
        this.header['unique_args']  = isDefined("header.unique_args") ? header.unique_args : {};
        this.header['send_at']      = isDefined("header.send_at")     ? header.send_at  : '';
        this.header['send_each_at'] = isDefined("header.send_each_at") ? header.send_each_at  : [];


        return this;
    }

    public string function toJson(){
        var jsonStruct = jsonObject();
        var jsonString = serializeJSON(jsonStruct);

        return escapeUnicode(jsonString);
    }


    public struct function jsonObject() {
        var header = {};
        //filter out empty arrays, structs, strings. We don't want it in our final header.
        for(var key in this.header){
            if( ( isArray(this.header[key]) && this.header[key].size() )
                || isNumeric(this.header[key])
                || ( isStruct(this.header[key]) && not structIsEmpty(this.header[key]) )
             ){
                header[key] = this.header[key];
            }
        }

        return header;
    }




    public any function escapeUnicode(required string str) {
        var escapedString = arguments.str;
        for(var i = 1; i <= escapedString.length(); i++){
            var char = mid(escapedString, i, 1);
            var deci = asc(char);
            if(deci gt 4096){
                escapedString = replace(escapedString, char, "\u#FormatBaseN(deci,16)#");
            } else if(deci gt 255){
                escapedString = replace(escapedString, char, "\u0#FormatBaseN(deci,16)#");
            } else if(deci gt 127){
                escapedString = replace(escapedString, char, "\u00#FormatBaseN(deci,16)#");
            }
        }
        return escapedString;
    }


    public void function setTos(required tos){
        if(isArray(arguments.tos)){
            this.header['to'] = arguments.tos;
        } else {
            this.header['to'] = [arguments.tos];
        }
    }

    public void function addTo(required to){
        if(isArray(arguments.to)){
            this.header['to'].addAll(arguments.to);
        } else {
            this.header['to'].add(arguments.to);
        }
    }


    public void function setSubstitutions(required struct sub) {
        this.header['sub'] = arguments.sub;
    }


    public void function addSubstitution(required string key, required val) {
        if(not structKeyExists(this.header['sub'], arguments.key)){
            this.header['sub'][arguments.key] = [];
        }

        if(isArray(arguments.val)){
            this.header['sub'][arguments.key].addAll(arguments.val);
        } else {
            this.header['sub'][arguments.key].add(arguments.val);
        }
    }


    public void function setUniqueArgs(required struct uniqueArgs) {
        this.header['unique_args'] = arguments.uniqueArgs;
    }


    public void function addUniqueArg(required string key, required string val) {
        this.header['unique_args'][arguments.key] = arguments.val;
    }


    public void function setCategories(required categories) {
        if(isArray(arguments.categories)){
            this.header['category'] = arguments.categories;
        } else {
            this.header['category'] = [arguments.categories];
        }
    }


    public void function addCategory(required string category) {
        if(isArray(arguments.category)){
            this.header['category'].addAll(arguments.category);
        } else {
            this.header['category'].add(arguments.category);
        }
    }


    public void function setSections(required struct section) {
        this.header['section'] = section;
    }


    public void function addSection(required string key, required string val) {
        this.header['section'][arguments.key] = arguments.val;
    }


    public void function setFilters(required struct filters) {
        this.header['filters'] = arguments.filters;
    }


    public void function addFilter(required string filter,
                                   required string setting,
                                   required string val) {
        if(not structKeyExists(this.header['filters'], arguments.filter)){
            this.header['filters'][arguments.filter] = { 'settings': {} };
        }
        this.header['filters'][arguments.filter]['settings'][arguments.setting] = arguments.val;
    }


    public void function setSendAt(required numeric unixTimeStamp) {
        this.header['send_each_at'] = [];
        this.header['send_at'] = arguments.unixTimeStamp;
    }


    public void function setSendEachAt(required times) {
        this.header['send_at'] = '';
        this.header['send_each_at'] = arguments.times;
    }


    public void function addSendEachAt(required times) {
        this.header['send_at'] = '';
        if(isArray(arguments.times)){
            this.header['send_each_at'].addAll(arguments.times);
        } else {
            this.header['send_each_at'].add(arguments.times);
        }
    }


}