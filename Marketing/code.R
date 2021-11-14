library(grid)
library(ggplot2)

source("theme.R")

png("ggplot-shadow.png", width=600, height=375)

grid.newpage()
grid.rect(gp=gpar(fill="black"))
pushViewport(viewport(x=0, y=0, width=.6, 
                      just=c("left", "bottom")))
gg <- ggplot(mtcars) +
    geom_point(aes(disp, mpg), color="white") +
    ## theme_bw() +
    theme_black() +
    theme(panel.background=element_rect(color=NA, fill="transparent"),
          plot.background=element_rect(color=NA, fill="transparent"))
g <- editGrob(grid.grabExpr(plot(gg), gp=gpar(lex=2)))
## g <- grid.grabExpr(plot(gg))
grid.define(g, name="g")
trans <- function(group, ...) {
    viewportTransform(group, shear=groupShear(2, 0))
}
grad <- linearGradient(rgb(1,1,1,c(.8, .3)),
                       x1=.5, y1=0, x2=.5, y2=.3)
pushViewport(viewport(x=0, y=0, height=1/4, just=c("left", "bottom"),
                      mask=rectGrob(width=2, 
                                    gp=gpar(col=NA, fill=rgb(0,0,0,1)))))
                                    ## gp=gpar(col=NA, fill=grad))))
grid.use("g", transform=trans)
popViewport()
grid.draw(g)    

dev.off()
