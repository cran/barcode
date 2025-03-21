"barcode.panel" <- function(x, horizontal=TRUE, xlim=NULL, labelloc=TRUE,
                            axisloc=TRUE,
                            labelouter=FALSE, nint=0, fontsize=9, 
                            ptsize=unit(0.25, "char"), ptpch=1, bcspace=NULL,
                            xlab="", xlaboffset=unit(2.5, "lines"),
                            use.points=FALSE, buffer=0.02, log=FALSE) {
  
  if (!is.list(x)) { stop("x must be a list") }
  
  K <- length(x)
  for (i in 1:K) x[[i]] <- x[[i]][!is.na(x[[i]])]
  
  # Figure out some global things we'll need for spacing:  
  maxct <- 0
  if (is.null(xlim)) {
    minx <- min(unlist(x)) - buffer*(max(unlist(x))-min(unlist(x)))
    maxx <- max(unlist(x)) + buffer*(max(unlist(x))-min(unlist(x)))
  } else {
    minx <- xlim[1]
    maxx <- xlim[2]
  }
  # Left offset works as bottom offset for vertical plot (9/18/2024)
  xleftoffset <- unit(1, "strwidth", names(x)[1])
  for (i in 1:K) {
    y <- x[[i]]
    if (length(y)>0) {
      if (nint>0) z <- hist(y, breaks=pretty(unlist(x), n=nint),
                            plot=FALSE)$counts
      else z <- table(y)
      maxct <- max(maxct, max(z))
      xleftoffset <- max(xleftoffset, unit(1, "strwidth", names(x)[i]))
    }
  }
  maxct <- maxct + 3
  if (log) maxct <- log(maxct)
  xleftoffset <- 1.05 * xleftoffset
  if (is.null(labelloc) || !labelloc) {
    xrightoffset <- xleftoffset
    xleftoffset <- unit(0, "npc")
    # Factor location (9/18/2024)
    if (horizontal) {
      xtextloc <- unit(1, "npc") - xrightoffset
      xtextalign <- "left"
    } else {
      xtextloc <- unit(1, "npc") - xrightoffset
      xtextalign <- "right" 
    }
    
  } else {
    xrightoffset <- unit(0, "npc")
    # Flipped factor location (9/18/2024)
    if (horizontal) {
      xtextloc <- xleftoffset
      xtextalign <- "right"
    } else {
      xtextloc <- unit(0, "npc") + xleftoffset
      xtextalign <- "left" 
    }
  }
  if (labelouter) {
    xleftoffset <- unit(0, "npc")
    xrightoffset <- unit(0, "npc")
    if (is.null(labelloc) || !labelloc) xtextloc <- unit(1.02, "npc")
    else xtextloc <- unit(-0.02, "npc")
  }
  if (is.null(bcspace)) bcspace <- max(0.2, 1.5 / (maxct + 1))
  
  # Trivial viewport to properly create axis labels.
  if (horizontal) {
    pushViewport(viewport(x=xleftoffset, 
                          y=unit(0, "npc"),
                          width=unit(1, "npc") - xleftoffset - xrightoffset,
                          height=unit(1, "npc"),
                          xscale=c(minx, maxx),
                          just=c("left", "bottom")))
    if (!is.null(axisloc)) {
      grid.xaxis(main=axisloc, gp=gpar(fontsize=fontsize))
      if (axisloc) grid.text(xlab, x=unit(0.5, "npc"),
                             y=unit(0, "npc") - xlaboffset)
      else grid.text(xlab, x=unit(0.5, "npc"), y=unit(1, "npc") + xlaboffset)
    }
  } else { 
    # Vertical axis (9/18/2024)
    pushViewport(viewport(x=unit(0, "npc"), 
                          y=xleftoffset,
                          width=unit(1, "npc"),
                          height=unit(1, "npc") - xleftoffset - xrightoffset,
                          yscale=c(minx, maxx),
                          just=c("left", "bottom")))
    if (!is.null(axisloc)) {
      grid.yaxis(main=axisloc, gp=gpar(fontsize=fontsize))
      if (axisloc) grid.text(xlab, x=unit(0, "npc") - xlaboffset,
                             y=unit(0.5, "npc"),rot=90)
      else grid.text(xlab, x=unit(1, "npc") + xlaboffset,
                     y=unit(0.5, "npc"), rot = -90)
    }
  }
  
  popViewport(1)
  
  # Now do each of the barcodes:
  for (i in 1:K) {
    
    y <- x[[i]]
    
    # Handle the factor labels(horizontal/vertical) (9/18/2024):
    if (!is.null(labelloc)) {
      if (horizontal) {
        grid.text(names(x)[i], x=xtextloc,
                  y=unit((i-1)/K, "npc") + 0.5*unit(1/K, "npc"),
                  just=xtextalign, gp=gpar(fontsize=fontsize))
      } else {
        grid.text(names(x)[i], x=unit((i-1)/K, "npc")+0.5*unit(1/K, "npc"),
                  y=xtextloc,
                  just=xtextalign, gp=gpar(fontsize=fontsize), rot = -90) 
      }
    }
    
    if (nint>0) {
      zhist <- hist(y, breaks=pretty(unlist(x), n=nint), plot=FALSE)
      z <- zhist$counts
      mids <- zhist$mids
    } else {
      z <- table(y)
      mids <- as.numeric(names(z))
    }
    
    if (length(mids)>0) {
      
      # The barcode part of things(horizontal/vertical):
      if (horizontal) {
        vp.barcode <- viewport(x=xleftoffset,
                               y=unit((i-1)/K, "npc") + unit(0.05/K, "npc"),
                               width=unit(1, "npc")-xleftoffset-xrightoffset,
                               height=unit(1/K, "npc")*bcspace - unit(0.05/K, "npc"),
                               xscale=c(minx, maxx), yscale=c(0,1),
                               just=c("left", "bottom"),
                               name="barcode", clip="off")
        pushViewport(vp.barcode)
        grid.segments(unit(mids[z>0], "native"), 0, unit(mids[z>0], "native"), 1)
        popViewport(1)
        
        # The histogram part of things:
        vp.hist <- viewport(x=xleftoffset,
                            y=unit((i-1)/K, "npc")+unit(1/K, "npc")*bcspace,
                            width=unit(1, "npc")-xrightoffset-xleftoffset,
                            height=unit(1/K, "npc")-unit(1/K, "npc")*bcspace,
                            xscale=c(minx, maxx), yscale=c(0,1),
                            just=c("left", "bottom"),
                            name="hist", clip="off")
        pushViewport(vp.hist)
        vp.buffer <- viewport(x=0, y=0.05, width=1, height=0.9, 
                              just=c("left", "bottom"),
                              xscale=c(minx, maxx), yscale=c(0,1))
        pushViewport(vp.buffer)
        
      } else { 
        # Vertical barcode and histogram (9/18/2024)
        vp.barcode <- viewport(x=unit((i-1)/K, "npc") + unit(0.05/K, "npc"),
                               y=xleftoffset,
                               width=unit(1/K, "npc")*bcspace - unit(0.05/K, "npc"),
                               height=unit(1, "npc") - xleftoffset - xrightoffset,
                               xscale=c(0,1), yscale=c(minx,maxx),
                               just=c("left", "bottom"),
                               name="barcode", clip="off")
        pushViewport(vp.barcode)
        grid.segments(0,unit(mids[z>0], "native"), 1,unit(mids[z>0], "native"))
        popViewport(1)
        
        # The histogram part of things:        
        vp.hist <- viewport(x=unit((i-1)/K, "npc")+unit(1/K, "npc")*bcspace,
                            y=xleftoffset,
                            width=unit(1/K, "npc") - unit(1/K, "npc")*bcspace,
                            height=unit(1, "npc") - xleftoffset - xrightoffset,
                            xscale=c(0,1), yscale=c(minx,maxx),
                            just=c("left", "bottom"),
                            name="hist", clip="off")
        pushViewport(vp.hist)
        vp.buffer <- viewport(x=0.05, y=0, width=0.9, height=1, just=c("left", "bottom"),
                              xscale=c(0,1), yscale=c(minx,maxx))
        pushViewport(vp.buffer)
      }
      
      
      
      for (j in 1:length(z)) {
        if (z[j]>1) {
          xx <- rep(mids[j], z[j]-1)
          if (log) {
            yy <- ( log(2 + 1:(z[j]-1)) ) / maxct
          } else { yy <- (1:(z[j]-1))/maxct }
          
          if (use.points) {
            # Point plot for horizontal and vertical (9/18/2024)
            if (horizontal) grid.points(unit(xx, "native"), yy, pch=ptpch, size=ptsize)
            else grid.points(yy,unit(xx, "native"), pch=ptpch, size=ptsize)
          } else {
            if (log) yy <- c(yy, log(2 + z[j]) / maxct)
            else yy <- c(yy, (z[j])/maxct)
            
            # Grid segments horizontal and vertical (9/18/2024)
            if (horizontal) {
              grid.segments(unit(mids[j], "native"), unit(1/maxct, "npc"),
                            unit(mids[j], "native"), unit(max(yy), "npc"))
            } else {
              grid.segments(unit(1/maxct, "npc"),unit(mids[j], "native"),
                            unit(max(yy), "npc"), unit(mids[j], "native"))
            }
          }
        }
      }
      
      popViewport(2)
      
    }
    
  }
  
}
