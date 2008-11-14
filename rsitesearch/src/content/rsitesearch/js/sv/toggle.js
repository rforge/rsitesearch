
function updateAdverts(){
    
    var mainWindow = window.QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                   .getInterface(Components.interfaces.nsIWebNavigation)
                   .QueryInterface(Components.interfaces.nsIDocShellTreeItem)
                   .rootTreeItem
                   .QueryInterface(Components.interfaces.nsIInterfaceRequestor)
                   .getInterface(Components.interfaces.nsIDOMWindow);

    var docu = mainWindow.document ;
    
    var collapsed = docu.getElementById('rsitesearch-adverts').getAttribute('collapsed' ) ;
    if( collapsed == "false"){
        docu.getElementById('rsitesearch-adverts').setAttribute('collapsed', 'true') ;
    }
    else {
        docu.getElementById('rsitesearch-adverts').setAttribute('collapsed', 'false') ;
    }
}
