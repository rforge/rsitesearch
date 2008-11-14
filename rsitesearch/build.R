#!/usr/local/bin/Rscript

require( operators, quietly = T )

### read and update the install.rdf file
### increase the minor version number by 1
rdf <- readLines( "install.rdf" )
version <- rdf %o~|% 'em:version="(.*)"'
major <- version %-~% "-\\d+$"
minor <- as.numeric( version %-~% "^.*-" ) + 1
version <- sprintf( "%s-%d", major, minor ) 
rdf <- gsub( 'em:version=".*"', sprintf( 'em:version="%s"', version ), rdf )
cat( rdf, file = "install.rdf", sep = "\n" )

### move the source into the build directory
system( "rm -fr build/chrome/*" )
system( "cp -fr src/* build/chrome/" )
setwd( "build/chrome" )
system( "zip -q -r rsitesearch.jar locale skin content " )
setwd( ".." )
file.copy( "../install.rdf", "install.rdf", overwrite = TRUE )
# file.copy( "../chrome.manifest", "chrome.manifest", overwrite = TRUE )
file.copy( "../chrome.manifest.jar", "chrome.manifest", overwrite = TRUE )
system( "zip -q rsitesearch.xpi chrome chrome/rsitesearch.jar install.rdf chrome.manifest")
setwd( ".." )

### copy the built file to the www space
if( !file.exists( old <- file.path( "..", "www", "xpi", "old", major ) )){
	dir.create( old )
}
file.copy( "build/rsitesearch.xpi", sprintf("%s/rsitesearch_%s.xpi", old, version), overwrite = TRUE )
file.copy( "build/rsitesearch.xpi", "../www/xpi/rsitesearch.xpi", overwrite = TRUE )
file.copy( "build/rsitesearch.xpi", "dist/rsitesearch.xpi", overwrite = TRUE )

### update the update.rdf file
update <- readLines( "src/update.rdf" ) %s~% sprintf( "/VERSION/%s/", version )
cat( update, file = "../www/update.rdf", sep = "\n" )


