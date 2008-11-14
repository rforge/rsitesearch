
sv.search.sidebar = {
    clear : function(){
        sv.tools.e4x2dom.clear( this.getBox() ) ;
    },
    getBox : function(){
        return( this.getDocument().getElementById( "rsitesearch-graphics-browser" ) ) ;  
    },
    getDocument : function(){
        var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                   .getInterface(Components.interfaces.nsIWebNavigation)
                   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
                   .rootTreeItem
                   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                   .getInterface(Components.interfaces.nsIDOMWindow);

        var docu = mainWindow.document ;
        return(docu) ;
    },
    add : function( e4x ){
        var box = this.getBox() ;
        sv.tools.e4x2dom.appendTo( e4x, box ) ;
        sv.tools.e4x2dom.appendTo( <splitter/>, box ) ;
    },
    hide : function( update ){
        if( update ) sv.prefs.set( "rsitesearch-options-sidebar", "hidden" ) ;
        this.getBox().setAttribute( "collapsed", "true") ;
    },
    show : function( update ){
        this.getBox().setAttribute( "collapsed", "false") ;
        if( update ) sv.prefs.set( "rsitesearch-options-sidebar", "visible" ) ;
    },
    init : function(){
        var status = sv.prefs.get( "rsitesearch-options-sidebar", "hidden" ) ;
        if( status == "hidden" ){
            this.hide(false) ;
        } else{
            this.show(false) ;
        }
        document.getElementById("rsitesearch-options-sidebar").setAttribute( "class",
            "rsitesearch-options-sidebar-" + status) ;
    },
    toggle : function(){
        var status = sv.prefs.get( "rsitesearch-options-sidebar", "hidden" ) ;
        if( status == "visible" ){
            this.hide(true) ;
            status = "hidden" ;
        } else{
            this.show(true) ;
            status = "visible" ;
        }
        document.getElementById("rsitesearch-options-sidebar").setAttribute( "class",
            "rsitesearch-options-sidebar-" + status) ;
    }
    
}
