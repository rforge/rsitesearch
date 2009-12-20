# This file is part of the RcmdrPlugin.sos package
# file created: 20 Nov 2009
# last modified: 20 Nov 2009

sosInit <- function(){
    require(tcltk2)
    initializeDialog(title=gettextRcmdr("Search R help pages"))
    searchFrame <- tkframe(top)
    searchInput <- tclVar("")
    searchField <- tkentry(searchFrame, width="30", textvariable=searchInput)
    ### TODO diff eqs exp
    tk2tip(searchField, paste('You can specify up to 9 search terms separated \neither by "|" (vertical bars, to obtain the union \nof results) or "&" (ampersands, to obtain the \nintersection). Use only one type of separating \noperator per search.', sep=""))
    maxpageNumber <- tclVar("20")
    maxpageNumSlider <- tkscale(searchFrame, from=1, to=99, showvalue=TRUE,
      variable=maxpageNumber, resolution=1, orient="horizontal"
      )
    summaryVariable <- tclVar("0")
    summaryCheckBox <- tkcheckbutton(searchFrame, variable=summaryVariable)
    require("sos")
    sosGrep(recall=sosInit, bLabel=gettextRcmdr("Filter by:"), eLabel=gettextRcmdr("in"), 
      initialLabel=gettextRcmdr("Filter by"))
    onOK <- function(){
        search <- paste(tclvalue(searchInput))
        maxpage <- tclvalue(maxpageNumber)
        summary <- paste(tclvalue(summaryVariable))
        closeDialog()
        vbar <- grepl("|", search, fixed=TRUE)
        ampersand <- grepl("&", search, fixed=TRUE)
        if(vbar & ampersand){
            Message(message=paste('please use only one separating operator per search, "|" or "&"', 
              sep=""), type="error")
            return(sosInit())
        }
        if(vbar){
            sepString <- "|"
        } 
        if(ampersand){
            sepString <- "&"
        }
        if(vbar | ampersand){
            tmp.search <- strsplit(paste(search), paste(sepString), fixed=TRUE)
            tmp.search <- trim.blanks(tmp.search[[1]])
        } else {
            tmp.search <- trim.blanks(search)
        }
        tmp.search <- tmp.search[tmp.search!=""]
        if (length(tmp.search) == 0){
            Message(message=paste("please enter a (non-blank) search string", 
              sep=""), type="error")
            return(sosInit())
        }
        if(length(tmp.search) > 9){
            tmp.search <- tmp.search[1:9]
        }
        search <- tmp.search
        if(maxpage!="20"){
            maxpage <- paste(', maxPage=', maxpage, sep="")
        } else{
            maxpage <- paste("", sep="")
        }
        searchCommand <- NULL
        for(i in 1:length(search)){
            searchCommand[i] <- paste("findFn('", search[i], "'", maxpage, ")", sep="")
        }
        if(.grep!=""){
            grepCommand <- paste("grepFn('", .grep, "', .sos", .column, 
          .ignCase, ")", sep="")
        }
        logger(paste("## Launching RSiteSearch with ", length(search), 
          " search term(s). Please be patient..", sep=""))
        if(summary == "0" & .grep=="" & length(search)==1){
            doItAndPrint(paste(searchCommand, sep=""))
        } else if(summary == "1" | .grep!="" | length(search)>1){
            if(length(search)==1){
                doItAndPrint(paste(".sos", " <- ", searchCommand, sep=""))
            } else {
                for(i in 1:length(search)){
                    doItAndPrint(paste(".sos", i, " <- ", searchCommand[i], sep=""))
                    
                }
                .sosUnion <- ".sos1"
                .sosDel <- '".sos1"'
                for(i in 2:length(search)){
                    .sosUnion <- paste(.sosUnion, " ", sepString, " .sos", i, sep="")
                    .sosDel <- paste(.sosDel, ', ".sos', i, '"', sep="")
                }
                doItAndPrint(paste(".sos", " <- ", .sosUnion, sep=""))
            }
            nullRes <- dim(.sos)[1]==0
            if(!nullRes){
                if(.grep!=""){
                    doItAndPrint(paste(grepCommand, sep=""))
                } else {
                    doItAndPrint(paste(".sos", sep=""))
                }
                if(summary == "1"){
                    doItAndPrint(paste("summary(.sos)", sep=""))
                }
            }
            if(length(search)==1){
                doItAndPrint(paste("remove(.sos)", sep=""))
            } else {
                doItAndPrint(paste('remove(list=c(".sos", ', .sosDel, '))', sep=""))
            }
        }
        tkdestroy(top)
        tkfocus(CommanderWindow())
    }
    OKCancelHelp(helpSubject="findFn")
    tkgrid(tklabel(searchFrame, text=gettextRcmdr("Enter a search term..."), fg="blue"), sticky="w")
    tkgrid(tklabel(searchFrame, text=gettextRcmdr("String:")), searchField, sticky="w")
    tkgrid(labelRcmdr(searchFrame, text=gettextRcmdr("Maximum pages:")),
      maxpageNumSlider, sticky="sw")
    tkgrid(tklabel(searchFrame, text=gettextRcmdr("Summary")), summaryCheckBox, sticky="w")
    tkgrid(tklabel(searchFrame, text=gettextRcmdr(" ")), grepButton, sticky="w")
    tkgrid(searchFrame, sticky="w")
#    tkgrid(grepFrame, sticky="w")
    tkgrid(buttonsFrame, columnspan=1, sticky="w")
    dialogSuffix(rows=3, columns=1)
}
