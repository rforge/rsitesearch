
    sv.tools.rx = {
        cleanMarkup : function( txt ){
            txt = txt.replace( /<.*?>/g, "" )
            return( txt ) ;
        },
        cleanEmail : function( txt ){
            txt = txt.replace( / \&lt;at\&gt; /   , "@" ) ; 
            txt = txt.replace( / \&lt;dot\&gt; /g , "." ) ; 
            txt = sv.tools.rx.cleanMarkup( txt ) ;
            return( txt ) 
        }, 
        cleanDescription : function( txt ){
            txt = sv.tools.rx.cleanMarkup(txt) ;
            txt = txt.replace( /\[.*?\]/g, "" ) ;
            txt = txt.replace( /re:/ig, "" ) ;
            txt = txt.replace( /\&#40;/g , "" ) ;
            txt = txt.replace( /\&#41;/g , "" ) ;
            txt = txt.replace( /\&amp;/g , "&" ) ;
            txt = txt.replace( /\&[rl]squo;/g , "'" ) ;
            txt = txt.replace( /\&quot;/g , "'" ) ;
            
            return (txt) ;
        }
    }
