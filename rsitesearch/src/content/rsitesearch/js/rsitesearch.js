var searchWhere; // rss, wiki, filter
var nbResults;   // only used when searching over the r site search

// the string to search
//   most of the time, that string will come 
//   from the textbox named "rsitesearch-textbox"
var svalue = "" ; 

var prefs = Components.classes["@mozilla.org/preferences-service;1"].
                getService(Components.interfaces.nsIPrefBranch);


function setNumberOfResults(n){
  prefs.setIntPref("mango-solutions.rsitesearch.nbResults", n);
  nbResults=n;
}

function setEngine(e) {
  prefs.setCharPref("mango-solutions.rsitesearch.engine", e);
  document.getElementById("rss_selectengine").className="rss_engine_"+e ;
  searchWhere = e ;
}


function startRSS(){
   // try to get the preferred number of results from firefox preferences   
   try{
     nbResults = prefs.getIntPref("mango-solutions.rsitesearch.nbResults") ;
   } catch(e){
     nbResults = 20 ;
     setNumberOfResults(20) ;
   }

   // try to get the preferred engine (rss, wiki, or filter)
   try{
     searchWhere = prefs.getCharPref("mango-solutions.rsitesearch.engine") ;
   } catch(e) {
     searchWhere = "rss"
   }
   setEngine(searchWhere) ;
}

function wrongQuery(q){
   window.top._content.location = "http://finzi.psych.upenn.edu/namazu.html#query" ; 
}

function searchDispatch(){

  svalue = document.getElementById("rsitesearch-textbox").value ;     
  var myreg = new RegExp(":") ; // something like "apackage:afunction"

  if(svalue==""){
    wrongQuery(svalue) ;    
  } else if(myreg.test(svalue)){
     // TODO : put that in a function

     tab = svalue.split(":") ; 
     pack = tab[0]; 
     // try to see if the first element is a package
     // i.e. if it is a son of `treeroot`
     var packok = false ;
     var root=document.getElementById("allpackages");
     var ch = root.childNodes ;  // treeroot childs
     for(var i=0; i<ch.length; i++){
        if(pack == ch[i]){
           packok = true;
           break;
        }
     }
     
     if(packok){
        // then build the tree for that package
        // including all pages matching the second part of the regex
          
        // close the childs of treeroot
        var treeroot=document.getElementById("treeroot");
        var ch=treeroot.childNodes ; 
        for(var i=0; i<ch.length; i++){
          ch[i].setAttribute("open", false) ;
        }

        var fun = tab[1] ;
        
        // START HERE


     }

  } else if(searchWhere=="filter") {
     searchPackages() ;
  } else if(searchWhere=="wiki") {
     searchWiki() ;
  } else {
     search() ;
  }
  
}

function goHelp(event){
  var tree = event.target;
  
  var id = tree.treeBoxObject.view.getItemAtIndex(tree.currentIndex).getAttribute('id');
  
  var vigReg = new RegExp("^vig\:");
  var copyReg = new RegExp("^copy") ;
  var filReg = new RegExp("^filter");
  var seaReg = new RegExp("^search");
  var wikReg = new RegExp("^wiki") ;
  
  var url ="";
  if( !( filReg.test(id) | seaReg.test(id) | id=="allitem" ) ) {
    if(vigReg.test(id) ){
       url = id.replace(
        /^([^\:]+)\:+([^\:]+)\:+([^\:]+)/,
        "http://finzi.psych.upenn.edu/R/library/$2/doc/$3.pdf"
        )
    } else if(copyReg.test(id)){
      url = id.replace(
        /^([^\:]+)\:+([^\:]+)\:+([^\:]+)/,
        "http://finzi.psych.upenn.edu/R/library/$2/html/$3"
        )
    } else if(wikReg.test(id)) {
      url = id.replace(
       /^wiki\:(.*)$/,
       "http://wiki.r-project.org/rwiki/doku.php?id=$1") ;
    } else {
      url = id.replace(
        /^([^\:]+)\:+([^\:]+)/,
        "http://finzi.psych.upenn.edu/R/library/$1/html/$2.html"
        )
    }
       
      window.top._content.location = url ;
  }
}

function search(){
    
  svalue = document.getElementById("rsitesearch-textbox").value.replace(/ /, "+") ;     
  
  
  // the regular expression from the textbox
  var regex = new RegExp(svalue) ;
                 
  
  
  var tA = new Array() ;
  var nbPack = 0 ;
  var nmPack = new Array() ;
  
  
  try{
    var x = new XMLHttpRequest() ;
    x.onload=null;
    x.open("GET", 
       "http://search.r-project.org/cgi-bin/namazu.cgi?query="+svalue+"&max="+nbResults+"&result=short&sort=score&idxname=functions",
       false);
    
     x.send(null);
     var text = x.responseText ;
   
     var arr = text.split("\n") ;
     
     var str="";
     var rep="";
     var reg = new RegExp("^http");
     var reg00 = new RegExp("00Index") ;
     
     
    var treeroot=document.getElementById("treeroot");
     var ch=treeroot.childNodes ; 
     
     
       // treeitem
  var ti = document.createElement("treeitem") ;
  ti.setAttribute("id", "search_"+svalue+"_item") ;
  ti.setAttribute("container", "true") ;

     // treerow   
    var tr = document.createElement("treerow") ;
    
      // treecell 
      var tc1 = document.createElement("treecell") ;
      tc1.setAttribute("label", svalue ) ;
      tc1.setAttribute("src" , "chrome://rsitesearch/skin/loupe.png") ;
      tr.appendChild(tc1);  
      
      // treecell
      var tc2 = document.createElement("treecell") ;
      tc2.setAttribute("label", "" ) ;
      tr.appendChild(tc2); 
    
    ti.appendChild(tr)
           
     // treechildren
    var tc = document.createElement("treechildren") ;
    tc.setAttribute("id", "filter_"+svalue+"_packages") ;
  
     var tab;
     var currentPackage="", currentScore=0, currentHelpPage="";
     var packageItem;
     var packID="";
     
     var count=0 ;

     for(var i=0; i<arr.length; i++){
       if(reg.test(arr[i])){
         rep = arr[i].replace(/.+library\/([^\\]+)\/html\/(.+)\.html (.+)$/,"$1,$2,$3")  ;
         if(!reg00.test(rep)) {
           
           
            tab = rep.split(",");
            currentPackage  = tab[0];
            currentHelpPage = tab[1];
            currentScore    = tab[2];            
            
            if(tA[currentPackage] == undefined) 
              tA[currentPackage] = new Array() ; 
            
            tA[currentPackage][currentHelpPage] = currentScore ; 
                  
            count++;           
         }
       }
     }
     var childToAppend ; 
     
     if(count > 0) {
 // close the childs of treeroot
     for(var i=0; i<ch.length; i++){
       ch[i].setAttribute("open", false) ;
     }
       for( var currentPackage in tA){
       
         packageItem=document.createElement("treeitem") ;
         packageItem.setAttribute("container", "true") ;
         packageItem.setAttribute("open", "false") ;
         
         var pitr = document.createElement("treerow") ;
         
           var pitc1 = document.createElement("treecell") ;
           pitc1.setAttribute("label", currentPackage);
           pitr.appendChild(pitc1) ;
           
           var pitc2 = document.createElement("treecell") ;
           pitc2.setAttribute("label", "") ;
           pitr.appendChild(pitc2) ;
           
         packageItem.appendChild(pitr) ;
         
         var pitc = document.createElement("treechildren") ;
      
       
       
          for(var currentHelpPage in tA[currentPackage]){
            currentScore = tA[currentPackage][currentHelpPage]  ;
            
            try{ 
              childToAppend = document.getElementById(currentPackage+":"+currentHelpPage).cloneNode(true) ;
              childToAppend.childNodes[0].childNodes[1].setAttribute('label', currentScore) ;
              
              pitc.appendChild(childToAppend ) ;
            } catch(e) { 
             // build the treeitem anyway
             var nti = document.createElement('treeitem') ;
             nti.setAttribute('id',currentPackage+":"+currentHelpPage) ;
             nti.setAttribute('container','false') ;

               var ntr = document.createElement('treerow') ;
               
                      var ntc1 = document.createElement("treecell") ;
                      ntc1.setAttribute("label", currentHelpPage);
                      ntr.appendChild(ntc1) ;
                      
                      var ntc2 = document.createElement("treecell") ;
                      ntc2.setAttribute("label", currentScore) ;
                      ntr.appendChild(ntc2) ;
                        
                nti.appendChild(ntr) ;

                pitc.appendChild(nti) ;
            }
            
          }
          
       packageItem.appendChild(pitc) ;
       packageItem.setAttribute("open", "true") ;
       packageItem.setAttribute("id", "copy_"+svalue+":"+currentPackage+":00Index.html" );
       tc.appendChild(packageItem) ;
     }
     
     
     ti.appendChild(tc);
        ti.setAttribute("open", "true") ;  
     treeroot.appendChild(ti) ;
     
     } else {
        alert("the query\n"+svalue+"\ndidn't get any results") ;

     }

  } catch(e){
    alert(e); 
  }
  
       
}
    


// function to filter the packages names by some regular expression
// entered in the textbox
function searchPackages(){
  
  svalue = document.getElementById("rsitesearch-textbox").value ; 
  
  
  
  // close the childs of treeroot
  var treeroot=document.getElementById("treeroot");
  var ch=treeroot.childNodes ; 
  for(var i=0; i<ch.length; i++){
    ch[i].setAttribute("open", false) ;
  }
  
  var nbmatch = 0;
  
  // treeitem
  var ti = document.createElement("treeitem") ;
  ti.setAttribute("id", "filter_"+svalue+"_item") ;
  ti.setAttribute("container", "true") ;
  
    // treerow   
    var tr = document.createElement("treerow") ;
    
      // treecell 
      var tc1 = document.createElement("treecell") ;
      tc1.setAttribute("label", svalue) ;
 tc1.setAttribute("src" , "chrome://rsitesearch/skin/filter.png") ;
      tr.appendChild(tc1);  
      
      // treecell
      var tc2 = document.createElement("treecell") ;
      tc2.setAttribute("label", "" ) ;
      tr.appendChild(tc2); 
    
    ti.appendChild(tr)
  
    // treechildren
    var tc = document.createElement("treechildren") ;
    tc.setAttribute("id", "filter_"+svalue+"_packages") ;
  
       var regex = new RegExp(svalue) ;
       var root=document.getElementById("allpackages") ;
       var pack=root.childNodes ;    
       var i=0;
       while(i < pack.length){
         if( regex.test( pack[i].id.replace(/^([^\:]+)\:+([^\:]+)/,"$1")  )){
           nbmatch++;
           tc.appendChild( pack[i].cloneNode(true) ); 
         }                          
         i++;  
       }
                             
        
    ti.appendChild(tc);
    
    ti.setAttribute("open", "true") ;
    if(nbmatch>0){ 
      treeroot.appendChild(ti) ;
    } else {
      alert("no match for '"+svalue+"'") ; 
    }
    
                 
}


function searchWiki(){
  
  svalue = document.getElementById("rsitesearch-textbox").value ; 
  
  try{
    var x = new XMLHttpRequest() ;
    
    x.open("GET", 
       "http://wiki.r-project.org/rwiki/doku.php?do=search&id="+svalue,
       false);
    
     x.send(null);
     // var xmlwiki = x.responseXML.documentElement ;

     var wikipage ;
     var wikisplit;
     var nmsp;
     var pagename ;


     text= x.responseText ;  
     rows = text.split("<div class=\"search_result\">");
     if(rows.length<2) {
       alert("no results from the wiki") ;
     } else { 

       // close the childs of treeroot
        var treeroot=document.getElementById("treeroot");
        var ch=treeroot.childNodes ; 
        for(var i=0; i<ch.length; i++){
          ch[i].setAttribute("open", false) ;
        }

        // treeitem
          var ti = document.createElement("treeitem") ;
          ti.setAttribute("id", "wiki_"+svalue+"_item") ;
          ti.setAttribute("container", "true") ;
          
            // treerow   
            var tr = document.createElement("treerow") ;
            
              // treecell 
              var tc1 = document.createElement("treecell") ;
              tc1.setAttribute("label", svalue) ;
              tc1.setAttribute("src" , "chrome://rsitesearch/skin/wiki.png") ;
              tr.appendChild(tc1);  
              
              // treecell
              var tc2 = document.createElement("treecell") ;
              tc2.setAttribute("label", "" ) ;
              tr.appendChild(tc2); 
            
            ti.appendChild(tr)
          
            // treechildren
            var tc = document.createElement("treechildren") ;
            tc.setAttribute("id", "wiki_"+svalue+"_packages") ;



       var n = rows.length ;       
       for(var i=1; i<n; i++){
         if(i < n-1) {
           wikipage = rows[i].replace( /^<a href="\/rwiki\/doku.php\?id=([^\&]+)\&.*/ , "$1") ;  
         } else {
           wikipage = rows[i].split("&")[0].replace( /^<a href="\/rwiki\/doku.php\?id=(.*)$/ , "$1") ;
         }
 

  
         wikisplit = wikipage.split(":");
         nmsp = wikisplit[0] ; 
         pagename=wikisplit[wikisplit.length - 1] ;        

         var wti = document.createElement("treeitem") ;
         wti.setAttribute("id", "wiki:"+wikipage) ;
         wti.setAttribute("container", "true") ;
          
         
         var wtr = document.createElement("treerow") ;

            var wtc1  = document.createElement("treecell") ;
            wtc1.setAttribute("label", " "+pagename);
            wtc1.setAttribute("src", "chrome://rsitesearch/skin/w_"+nmsp+".png" ) ;
            wtr.appendChild(wtc1) ;
    
            var wtc2  = document.createElement("treecell") ;
            wtc2.setAttribute("label", "");
            wtr.appendChild(wtc2) ;

         wti.appendChild(wtr) ;
         wti.setAttribute("open", "true") ;

         tc.appendChild(wti) ;
       }

       ti.appendChild(tc);
    
       ti.setAttribute("open", "true") ;
       treeroot.appendChild(ti) ;

 
     } 

   } catch(e) { 
     alert(e) ;
   }

}
