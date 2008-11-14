

sv.search.progressbar = {
    nengines : function(){
        var val = 0;
        for( var eng in sv.search.engines ){
            val = val + 1 ;
        }
        return val ;
    },
    value : 0 ,
    total : 1 ,
    refresh : function( ){
        document.getElementById( "rsitesearch_meter" ).value = this.value / this.total * 100  ;
    },
    increase : function( ) {
        this.value++ ;
        this.refresh() ;
        if( this.value == this.total){
            sv.search.progressbar.close()
        }
    },
    init : function(){
        document.getElementById("progressbars").setAttribute( "collapsed", "false" ) ;
        this.total = this.nengines() ;
        this.value = 0 ;
        this.refresh() ;
    },
    close : function(){
        document.getElementById("progressbars").setAttribute( "collapsed", "true" ) ;
        this.value = 0 ;
    }
} ;


    sv.search.search = {
        data : null,
        // search for the query in all engines
        searchQuery : function(){
           var query = document.getElementById("rsitesearch-textbox").value ;
           sv.search.search.search( query ) ;
        }, 
        search : function( query ){
            sv.search.sidebar.clear() ;
            sv.search.search.data = new Array() ;
            var rootNode = document.getElementById( "treeroot" ) ;
            sv.tools.e4x2dom.clear( rootNode ) ;
            sv.search.node = rootNode ;
            sv.search.search.count = sv.search.search.count + 1 ;
            
            // call each engine and add the result to the node
            var eng;
            var result ;
            sv.search.progressbar.init() ;
            sv.search.search.data = new Array() ;
            for( var engname in sv.search.engines ){
                sv.search.search.master( query, engname) ;
            }
        },
        
        master : function( query, engname ){
            var engine = sv.search.engines[engname] ;
            var url = engine.url( query ) ;
            var data ;
            var X = new XMLHttpRequest()
            X.open("GET", url, true);
            X.onreadystatechange = function( aEvt ){
                if (X.readyState == 4) {
                    if(X.status == 200){
                        sv.log.log( "data received" ) ;
                        data = engine.process(X.responseText);
                        sv.search.progressbar.increase( ) ;
                        if( data){
                            sv.search.search.data[engname] = data ;
                            engine.display( data ) ;
                        }
                        
                    }
                    else
                        dump("Error loading page\n");
                }
            }
            X.send(null);
            
        }, 
        // identifies the query
        count : 0 ,
        // send the <browser> to the url of the selected <treeitem>
        go : function( event ){
            var tree = event.target;
            var url = tree.treeBoxObject.view.getItemAtIndex(tree.currentIndex).getAttribute('url');
            if( url ){
                window.top._content.location = url ;
            }
        }
    }

sv.search.tree = {
    updateTooltip : function( event ){
        
        var tree = document.getElementById( "tree_r_help_pages" ) ;
        var x = event.clientX ;
        var y = event.clientY ;
        var index = tree.treeBoxObject.getRowAt( x, y ) ;
        if( index != -1 ){
            var current = tree.treeBoxObject.view.getItemAtIndex(index) ;
            var engine = current.getAttribute("engine") ;
            var index  = current.getAttribute("index") ;
            var tooltip = document.getElementById( "rsitesearch-tree-treetooltip" ) ;
            sv.tools.e4x2dom.clear( tooltip ) ;
            // get the tooltip from the engine
            var tooltipcontent = sv.search.engines[engine].tooltip( sv.search.search.data[engine][index] );
            if( tooltipcontent ){ 
                sv.tools.e4x2dom.appendTo( tooltipcontent, tooltip) ;
            }
        }
    }, clearTooltip : function(){
        var tooltip = document.getElementById( "rsitesearch-tree-treetooltip" ) ;
        sv.tools.e4x2dom.clear( tooltip ) ;
    }
}


