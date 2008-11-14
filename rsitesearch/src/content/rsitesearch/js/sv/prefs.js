
sv.prefs = {
    PREF : Components.classes["@mozilla.org/preferences-service;1"].
                getService(Components.interfaces.nsIPrefBranch), 
    get : function( pref, defaultValue){
        if( ! this.PREF.prefHasUserValue(pref) ){
            this.set( pref, defaultValue) ;
        }
        return( this.PREF.getCharPref( pref) ) ;
    },
    set : function( pref, value){
        if( !value) value = "" ; 
        this.PREF.setCharPref( pref, value) ;
    }
}

sv.properties = {
    get : function( property ){
        PROP = document.getElementById("rsitesearch-strings") ; 
        var value ;
        try{
            var value = PROP.getString( property ) ;
            if( !value ) value = "" ;
        } catch(e){ value = "" }
        return(value) ;
    }
}
