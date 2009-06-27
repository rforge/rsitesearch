
#' binary operators for RSiteSearch objects
Ops.RSiteSearch <- function( e1, e2 ){
	if( nargs() != 2){
		stop( sprintf( "unary operator '%s' not implemented", .Generic) )
	}
	
	# making sure both e1 and e2 are RSiteSearch objects
	rework <- function( x ){
		if( !inherits( x, "RSiteSearch" ) ){
			if( inherits( x, "character" ) && length(x) ){
				RSiteSearch.function( paste( x, collapse= "+" ), quiet = TRUE )
			} else{
				stop( "RSiteSearch objects can only be combined with either RSiteSearch objects or character vectors" )
			}
		} else{
			x
		}
	}
	e1 <- rework( e1 )
	e2 <- rework( e2 )
	switch( .Generic,
		"&" = intersectRSiteSearch( e1, e2 ),
		"|" = unionRSiteSearch( e1, e2),
		stop( sprintf( "operator '%s' not implemented for RSiteSearch objects", .Generic)  )
		)
}

