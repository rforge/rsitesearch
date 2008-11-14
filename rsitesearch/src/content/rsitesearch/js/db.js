

var file = Components.classes["@mozilla.org/file/directory_service;1"]
                     .getService(Components.interfaces.nsIProperties)
                     .get("ProfD", Components.interfaces.nsIFile);

file.append("chrome://rsitesearch/content/db/rsitesearch.sqlite");

var storageService = Components.classes["@mozilla.org/storage/service;1"]
                        .getService(Components.interfaces.mozIStorageService);
var mDBConn = storageService.openDatabase(file);

alert( mDBConn ) ;

var statement = mDBConn.createStatement("SELECT * FROM search");


