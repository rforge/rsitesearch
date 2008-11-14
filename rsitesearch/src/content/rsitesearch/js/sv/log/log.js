
sv.log = {
    log : function( msg ){
        if( sv.log.DEBUG ){
            dump( "[rsitesearch] " + msg + "\n") ; 
        }
    },
    DEBUG : true 
}

