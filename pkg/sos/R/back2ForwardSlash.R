back2ForwardSlash <- function(x = readline("text to convert > ")){
  gsub("\\", "/", x, fixed = TRUE)
}
