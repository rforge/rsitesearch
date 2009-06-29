
#' binary operators for RSiteSearch objects
Ops.findFunction <- function( e1, e2 ){
  if( nargs() != 2){
    stop( sprintf( "unary operator '%s' not implemented", .Generic) )
  }

# making sure both e1 and e2 are RSiteSearch objects
  rework <- function( x ){
    if( !inherits( x, "findFunction" ) ){
      if( inherits( x, "character" ) && length(x) ){
        findFunction( paste( x, collapse= "+" ), quiet = TRUE )
      } else{
        msg <- paste("findFunction objects can only be combined",
                     "with either findFunction objects or",
                     "character vectors" )
        stop(msg)
      }
    } else{
      x
    }
  }
  e1 <- rework( e1 )
  e2 <- rework( e2 )
  switch( .Generic,
         "&" = intersectFindFunction( e1, e2 ),
         "|" = unionFindFunction( e1, e2),
         stop( sprintf(
           "operator '%s' not implemented for findFunction objects",
                       .Generic)  )
         )
}

