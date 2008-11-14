
sv.search.toolbar.mode = {
    toggle : function(){
        var mode = this.getMode() ;
        if( mode == "single" ){
            mode = "multiple" ; 
        } else {
            mode = "single" ; 
        }
        sv.log.log( "toggling the search mode to " + mode ) ; 
        this.setMode( mode ) ;
    },
    setMode : function( mode ){
        mode = this.checkMode( mode ) ;
        sv.prefs.set( "rsitesearch-result-mode", mode ) ;
        var button = document.getElementById("rsitesearch-results-mode") ;
        button.setAttribute( "class", "result-" + mode ) ;
        button.setAttribute( "tooltiptext", sv.properties.get("rsitesearch-results-mode-" + mode) ) ;
        
    } ,
    init : function(){
        var mode = this.getMode() ;
        this.setMode( mode ) ;
    },
    checkMode : function( mode ){
        if( mode == "multiple" ) return("multiple") ;
        return("single")
    },
    getMode : function( ){
        var mode = this.checkMode( sv.prefs.get( "rsitesearch-result-mode", "single" ) );
        return( mode) ;
    }
}



sv.search.options = {
    toggle : function(){
        var visible = this.getVisibility() ;
        if( visible == "visible" ){
            visible = "hidden" ; 
        } else {
            visible = "visible" ; 
        }
        this.setVisibility( visible ) ;
    },
    init : function(){
        var visible = this.getVisibility() ;
        this.setVisibility( visible ) ;
  
        var enginebox = document.getElementById( "rsitesearch-options-engines" ) ;
        for( var eng in sv.search.engines){
            var e4x =
                <hbox flex="1">
                    <checkbox label={eng} checked="true" disabled="true"/>
                    <spacer flex="1" />
                    <toolbarbutton class={ "engine engine-"+ eng} flex="1" />
                </hbox>  ;
            sv.tools.e4x2dom.appendTo(e4x,enginebox) ;
        }
    },
    getVisibility : function(){
        var visible = this.checkVisibility( sv.prefs.get( "rsitesearch-options-visible", "hidden" ) );
        return( visible ) ;
    },
    setVisibility : function( visible ){
        visible = this.checkVisibility( visible ) ;
        sv.prefs.set( "rsitesearch-options-visible", visible ) ;
        var button = document.getElementById("rsitesearch-options-button") ;
        button.setAttribute( "class", "options-" + visible ) ;
        button.setAttribute( "tooltiptext", sv.properties.get("rsitesearch-options-" + visible) ) ;
        
        var enginebox = document.getElementById( "rsitesearch-options-box" ) ;
        if( visible == "hidden"){
            enginebox.setAttribute( "collapsed", "true" ) ;
        } else {
            enginebox.setAttribute( "collapsed", "false" ) ;
        }
        
    },
    checkVisibility : function( visible ){
        if( visible == "visible" ) return("visible") ;
        return("hidden")
    },
    gotoEngine : function(e){
       alert( "re" ) ; 
    }
}





