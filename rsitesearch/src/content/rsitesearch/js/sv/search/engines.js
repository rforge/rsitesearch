
sv.search.engines = new Array() ;

// engine to search (for help pages) on the search.r-project.org website
sv.search.engines["rsitesearch"] = {
    description : "search for help pages on search.r-project.org" ,
    url: function( query, node){
        query = query.replace( / +/, "+" ) ;
        var nbResults = 20 ;
        var url = "http://search.r-project.org/cgi-bin/namazu.cgi?query=" + query + "&max=" + nbResults + "&result=short&sort=score&idxname=functions" ;
        return( url ) ;
    },
    process : function( txt  ){
        var rx_dl = /\n<\/?dl>\n/g ; 
        var rx_strong = /<\/?strong.*?>/g ;
        var rx_score = /.*\(score: (.*)\).*/ ;    
        
        // extract the content of the <dl> tag and split items
        var results = txt.split( rx_dl )[1].split( "\n\n" ) ;
        var data = new Array( ) ;
        var res, url, desc, score, pack, alias ;
        
        sv.log.log( results.length + "results" ) ; 
        for( var i=0; i<results.length; i++){
            res  = results[i].split( "\n" )[0] ;
            url  = res.replace( /.*href="(.*?)".*/ , "$1") ;
            desc = res.replace( /.*html">R:(.*)<\/a>.*/ , "$1") ;
            desc = desc.replace( rx_strong, "" ) ;
            score = res.replace( rx_score, "$1" )            
            pack  = url.replace( /.*\/R\/library\/(.*?)\/.*/, "$1" ) ;
            alias = url.replace( /.*\/html\/(.*?)\.html.*/, "$1" ) ;
            if( alias != "00Index" ) { 
                
                data[ data.length ] = {
                    url : url,
                    desc : desc,
                    score: score,
                    alias:alias,
                    pack : pack
                } ;
                sv.log.log( url + "; "+desc+"; " ) ;  
            }
        }
        
        sv.log.log( "finished searching" ) ; 
        return( data ) ;
    }, 
    display : function( data ){
        
        var itemnode, item ;  
        for( var i=0; i<data.length; i++){
            item = data[i] ;
            itemnode =
                <treeitem url={item.url} description={item.desc} engine="rsitesearch" index={i} > 
                    <treerow properties="rsitesearch" >
                      <treecell label={item.alias} /> 
                    </treerow>
                </treeitem> ;
            sv.tools.e4x2dom.appendTo( itemnode, sv.search.node) ;    
        }       
    },
    tooltip : function( data ){
        var desc = sv.tools.rx.cleanDescription( data.desc ) ;
        
        
        var tip =
            <vbox xmlns:html="http://www.w3.org/1999/xhtml">
                <hbox>
                    <label value={data.pack} class="rsitesearch-sidebar-tooltip-description" />
                    <spacer flex="1"/>
                    <label value={data.alias} class="rsitesearch-sidebar-tooltip-description" />
                </hbox>
                <description>{ desc }</description>
                <vbox>
                    <label value = "" class = "rsitesearch-sidebar-tooltip-label" />
                    <html:html>
                        <html:div style="max-width:500px" />
                    </html:html>    
                </vbox>    
            </vbox>    ;
        
            
        // r graphical manuals
        var graphs = sv.search.engines["rgraphicalmanuals"].graphics( data.pack, data.alias) ;
        var html = new Namespace("http://www.w3.org/1999/xhtml") ;

        if( graphs ){
            tip.vbox.html::html.html::div.image = new XMLList() ;
            tip.vbox.label.@value = graphs.length + " image(s) from R Graphical Manuals" ; 
            for( var i=0; i<graphs.length; i++){
                tip.vbox.html::html.html::div.image +=
                    <image src={graphs[i]}
                            minwidth="100px" maxwidth="100px" minheight="100px" maxheight="100px"
                            class = "rsitesearch-tree-tooltip-image" />
            }
        } else{
            tip.vbox.label.@value = "No graphics from R Graphical Manuals" ;
            tip.vbox.label.@class = "rsitesearch-sidebar-tooltip-label rsitesearch-sidebar-tooltip-label-gray" ;
        }
        return (tip) ;
    }
}

// engine to search for mailing list archives on gmane

sv.search.engines["gmane"] = {
    description : "search in mailing list archives using gmane" ,
    url : function( query, node){
        query = query.replace( / +/, "+" ) ;
        var search = "http://search.gmane.org/?query="+ query +"&group=gmane.comp.lang.r.*" ;
        return( search ) ;
    },
    process : function( txt ){
        sv.log.log( "processing gmane " ) ;
        var data = new Array() ;
        var results = txt.split( /<dl><dt>/ ) ;
            
            sv.log.log("processing gmane data, " + results.length + " results" ) ; 
            for( var i=1; i<results.length; i++){
                res = results[i].replace(/\n/g,'\uffff') ; // hack to replace line breaks to unicode characters
                url = res.replace( /.*<A HREF="(.*?)".*/, "$1" ) ;
                desc = sv.tools.rx.cleanDescription( res.replace( /^.*?">(.*?)<\/A>.*/ , "$1" ) ) ;
                group = url.replace( /^http:\/\/.*?\/(.*?)\/.*/, "$1" ) ;
                group = group.replace("gmane.comp.lang.r.", "") ; 
                author = res.replace( /.*<dd><B>(.*?)<\/B>.*/, "$1" ) ; 
                authorname = author.replace( /\&lt.*/, "" ) ;
                authoremail = sv.tools.rx.cleanEmail( author.replace( /.*?\&lt;(.*)\&gt;/, "$1" ) ) ;

                data[data.length] = {
                    desc : desc,
                    url : url, 
                    author : authorname, 
                    email : authoremail,
                    description : results[i],
                    group : group
                }
                sv.log.log( desc + "; " + authorname + "; " + authoremail) ; 
            }
        
        return( data ) ;
        
    }, display : function( data ){
        sv.log.log( "display gmane data" ) ;
        
        var itemnode, item ;  
        for( var i=0; i<data.length; i++){
            item = data[i] ;
            itemnode =
                <treeitem url={item.url} description={item.description} engine="gmane" index={i}> 
                    <treerow properties="gmane">
                      <treecell label={item.desc} /> 
                    </treerow>
                    <treechildren/>
                </treeitem> ;
            sv.tools.e4x2dom.appendTo( itemnode, sv.search.node) ;
        }
        
    }, tooltip : function( data ){
        var tip =
            <vbox>
                <hbox>
                    <label value={ data.author + "<" + data.email +">" } class="rsitesearch-sidebar-tooltip-description" />
                    <spacer flex="1" />
                    <label value={"gmane.comp.lang.r." + data.group} class="rsitesearch-sidebar-tooltip-description" />
                </hbox>
                <description>
                    { data.desc }
                </description>
            </vbox> ;
        return (tip) ;
    }
}


sv.search.engines["wiki"] = {
    description : "R Wiki",
    url : function(query, node){
        var url = "http://wiki.r-project.org/rwiki/doku.php?do=search&id=" + query ;
        return( url ) ;
    },
    process : function( text ){
        
        var data = new Array() ;
        var rows = text.split("<div class=\"search_result\">");
        var wikipage, txt, snippet; 
        
        if( rows.length < 2){
            return( null ) ;
        } else{
            rows[rows.length - 1]  =  rows[rows.length - 1].split( "<script" )[0] ;
            for( var i=1; i<rows.length; i++){ 
                txt = rows[i].split("\n")[0] ;
                wikipage = txt.replace(/^.*?\?id=(.*?)&amp;.*$/g, "$1") ;
                snippet = sv.tools.rx.cleanDescription( txt.replace( /^.*?_snippet"(.*?)<\/div>/, "$1" ) ) ;
                
                data[data.length] = {
                    url : "http://wiki.r-project.org/rwiki/doku.php?id=" + wikipage,
                    id : wikipage,
                    shortId : wikipage.replace( /^.*:/, "" ),
                    snippet : snippet
                }
                
            }
        }
        
        return( data ) ;
    },  
    display : function( data ){
        
        sv.log.log( "representing wiki data" ) ;
        var itemnode, item;
        for( var i=0; i<data.length; i++){
            item = data[i] ;
            itemnode = <treeitem container="false" url={ item.url} engine="wiki" index={i}> 
                <treerow properties="wiki" >
                  <treecell label={item.shortId } /> 
                </treerow>
                <treechildren/>
              </treeitem> ;
            sv.tools.e4x2dom.appendTo( itemnode, sv.search.node) ;  
        }
        
    },
    tooltip : function( data ){
        var tip =
            <vbox>
                <hbox>
                    <label value={data.id} class="rsitesearch-sidebar-tooltip-description" />
                    <spacer flex="1" />
                </hbox>
                <description>
                    { data.snippet }
                </description>
            </vbox> ;
        return( tip ) ;
    }
}


sv.search.engines["rgraphgallery"] = {
    description : "R Graph Gallery" ,
    url : function( query, node ){
        var search = "http://addictedtor.free.fr/graphiques/searchSimple.php?q="+query ;
        return( search ) ;
    },
    process : function( txt ){
        var data = new Array() ;
        var results = txt.split("\n") ;
        var currentLine ;
        if( results.length < 3) return(null) ;
        for( var i=1; i<results.length - 1; i++){
            currentLine = results[i] ;
            id = currentLine.replace( /;.*$/, "" ) ;
            description = currentLine.replace( /^.*?;/ , "") ;
            sv.log.log( i + " : \n  id :" + id + "\n  desc:  " + description + "\n\n") ;
            
            data[ data.length ] = {
                id : id,
                description : description,
                url : "http://addictedtor.free.fr/graphiques/RGraphGallery.php?graph="+id,
                png : "http://addictedtor.free.fr/graphiques/graphiques/graph_" + id + ".png"
            }
        }
        return(data) ;
    },
    display : function( data ){
        sv.log.log( "representing graph gallery data" ) ;
        
        var itemnode, item, graphNode ;  
        for( var i=0; i<data.length; i++){
            item = data[i] ;
            
            itemnode =
                <treeitem url={item.url} engine="rgraphgallery" index={i} > 
                    <treerow properties="rgraphgallery">
                      <treecell label={item.description} /> 
                    </treerow>
                    <treechildren/>
                </treeitem> ;
            sv.tools.e4x2dom.appendTo( itemnode, sv.search.node) ;
            
            graphNode =
                <vbox flex="1">
                    <popupset>
                        <tooltip id={ "rsitesearch-sidebar-tooltip-gg-" + i }
                            orient="vertical"
                            class="rsitesearch-sidebar-tooltip">
                            <label value={item.description} class="rsitesearch-sidebar-tooltip-description"/>
                            <image src={ item.png }  />
                            <label value="R Graph Gallery" class="rsitesearch-sidebar-tooltip-footer"/>
                        </tooltip>
                    </popupset>
                    <image src={item.png}
                        minwidth="100px" maxwidth="100px" minheight="100px" maxheight="100px"
                        onclick= { "window.top._content.location = '"+ item.url +"';" }
                        url = {item.url}
                        tooltip = { "rsitesearch-sidebar-tooltip-gg-" + i } />
                </vbox> ;
            sv.search.sidebar.add( graphNode ) ;
            
        }
    }, tooltip : function( data ){
        var tip = <vbox>
            <hbox>
                <label value={data.description} />
                <spacer flex="1" />
            </hbox>
            <image src={data.png} />
        </vbox> ;
        return (tip) ;
    }
}


sv.search.engines["rgraphicalmanuals"] = {
    description : "R Graphical Manuals",
    url : function( query ){
        var search = "http://bm2.genes.nig.ac.jp/RGM2/index.php?query="+ query ;
        return( search ) ;
    },
    process: function( txt) {
        var data = new Array() ;
        sv.log.log( "rgraphical manual: ") ;
        txt = txt.split( /<table border="1">/ )[1] ;
        txt = txt.split( "</table>" )[0].split("\n") ;
        var td ;
        var tdrx = new RegExp( /^<td/ ) ;
        var url, png ;
        for( var i=0; i<txt.length; i++){
            td = txt[i] ;
            if( tdrx.test(td) ){
                url = "http://bm2.genes.nig.ac.jp" + td.replace( /^.*?href="(.*?)".*$/, "$1" ) ;
                png = "http://bm2.genes.nig.ac.jp" + td.replace( /^.*?src="(.*?)".*$/, "$1" ) ;
                
                description = td.replace( /^.*html" title="" target="_blank">(.*?)<\/a> \(.*$/, "$1") 
                pack = td.replace( /^.*library\//, "" ).replace( /\/.*$/, "" )  ;
                alias = td.replace( /.*?\/man\/(.*?).html".*$/, "$1" ) ;
                data[ data.length ] = {
                    url : url,
                    description : description,
                    png : png, 
                    pack : pack,
                    alias :alias
                }
            }
        }
        return( data ) ;
        
    },
    display: function( data ){
        
        sv.log.log( "representing graphical manual data" ) ;
        
        var item, itemnode, graphNode, tooltip ;  
        var known = new Array() ; 
        var already = function( url ){
            for(var i=0; i<known.length;i++){
                if(url == known[i]) return(true) ; 
            }
            known[known.length] = url ;
            return(false) ;
        }
        
        for( var i=0; i<data.length; i++){
            item = data[i] ;
            
            if( !already(item.url) ){
                itemnode =
                    <treeitem url={item.url} engine="rgraphicalmanuals" index={i}> 
                        <treerow properties="rgraphicalmanuals">
                          <treecell label={item.description} /> 
                        </treerow>
                    </treeitem> ;
                sv.tools.e4x2dom.appendTo( itemnode, sv.search.node) ;
            }
            
            var id = "rsitesearch-sidebar-tooltip-gm-" + i ;
            graphNode =
                <vbox flex="1">
                    <popupset>
                        <tooltip id={ id }
                            orient="vertical"
                            class="rsitesearch-sidebar-tooltip" >
                            <label value={item.description} class="rsitesearch-sidebar-tooltip-description"/>
                            <image src={ item.png.replace(/s_/, "") }  />
                            <label value="R Graphical Manuals" class="rsitesearch-sidebar-tooltip-footer"/>
                        </tooltip>
                    </popupset>
                    <image src={item.png}
                       minwidth="100px" maxwidth="100px" minheight="100px" maxheight="100px"
                       onclick= { "window.top._content.location = '"+ item.url +"';" }
                       url = {item.url}
                       tooltip = { "rsitesearch-sidebar-tooltip-gm-" + i } />
                </vbox> ;
            sv.search.sidebar.add( graphNode ) ;
            
        }
        
    }, tooltip : function( data ){
        var desc = sv.tools.rx.cleanDescription( data.description ) ;
        
        var tip =
            <vbox xmlns:html="http://www.w3.org/1999/xhtml">
                <hbox>
                    <label value={data.pack} class="rsitesearch-sidebar-tooltip-description" />
                    <spacer flex="1"/>
                    <label value={data.alias} class="rsitesearch-sidebar-tooltip-description" />
                </hbox>
                <description>{ desc }</description>
                <vbox>
                    <label value = "" class = "rsitesearch-sidebar-tooltip-label" />
                    <html:html>
                        <html:div style="max-width:500px" />
                    </html:html>    
                </vbox>    
            </vbox>    ;
        
            
        // r graphical manuals
        var graphs = sv.search.engines["rgraphicalmanuals"].graphics( data.pack, data.alias) ;
        var html = new Namespace("http://www.w3.org/1999/xhtml") ;

        tip.vbox.html::html.html::div.image = new XMLList() ;
        tip.vbox.label.@value = graphs.length + " image(s) from R Graphical Manuals" ; 
        for( var i=0; i<graphs.length; i++){
            tip.vbox.html::html.html::div.image +=
                <image src={graphs[i]}
                        minwidth="100px" maxwidth="100px" minheight="100px" maxheight="100px"
                        class = "rsitesearch-tree-tooltip-image" />
        }
        return (tip) ;
    
    }, graphics : function( pack, alias) {
        var X = new XMLHttpRequest()
        var url = "http://bm2.genes.nig.ac.jp/RGM2/REST.php?method=searchSmallImagesByFunctionName&pkg_name=" + pack + "&func_name=" + alias ;
        X.open("GET", url, false);
        X.send(null);
        var txt = X.responseText ;
        
        var rx = new RegExp( "img_path" ) ;
        var g = new Array() ;
        if( ! rx.test( txt) ){
            return null ;
        }
        var lines = txt.split( "\n" ) ;
        var graph ;
        for( var i=1; i<lines.length; i++){
            if( rx.test( lines[i] ) ) {
                graph = lines[i].replace( /^.*>(.*)<.*/, "$1" ) ;
                graph = graph.replace( "cged.genes.nig.ac.jp", "bm2.genes.nig.ac.jp" )
                g[ g.length ] = graph ;
            }
        }
        return g ;
    }
}
