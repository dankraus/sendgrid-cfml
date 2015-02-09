component {

    // Module Properties
    this.title              = "SendGrid-CFML";
    this.author             = "Dan Kraus";
    this.webURL             = "https://github.com/dankraus/sendgird-cfml/";
    this.description        = "CFML port of SendGrid's email library";
    this.version            = "1.0.0";
    this.modelNamespace     = "sendgrid-cfml";
    this.cfmapping          = "sendgrid-cfml";
    this.autoMapModels      = true;

    function configure(){

        settings = {
        };

    }

    function onLoad(){
        this.configStruct = controller.getConfigSettings();
        // parse parent settings
        parseParentSettings();
        // Map Config
        binder.map( "SendGrid@sendgrid-cfml" )
            .to( "#this.cfmapping#.models.services.SendGrid" )
            .initWith(
                apiUsername=this.configStruct.SendGrid.apiUsername,
                apiPassword=this.configStruct.SendGrid.apiPassword,
                options=this.configStruct.SendGrid.options
            );
    }

    /**
    * Fired when the module is unloaded
    */
    function onUnload(){
    }

    /**
    * Prepare settings and returns true if using i18n else false.
    */
    private function parseParentSettings(){
        var oConfig         = controller.getSetting( "ColdBoxConfig" );
        var configStruct    = controller.getConfigSettings();

        var SendGrid        = configStruct.SendGrid;

        //defaults
        this.configStruct.SendGrid = {
            apiUsername: "dummy",
            apiPassword: "pass",
            options: {}
        };

        //Check for IOC Framework
        structAppend( this.configStruct.SendGrid, SendGrid, true );

    }

}