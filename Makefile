
TARFILE = ../groups-deposit-$(shell date +'%Y-%m-%d').tar.gz

# For building on my office desktop
# Rscript = ~/R/r-devel-groups/BUILD/bin/Rscript
# Rscript = ~/R/r-devel/BUILD/bin/Rscript
# Rscript = ~/R/r-release/BUILD/bin/Rscript
# Rscript = Rscript

# For building in Docker container
Rscript = /R/R-patched/bin/Rscript

%.xml: %.cml %.bib
	# Protect HTML special chars in R code chunks
	$(Rscript) -e 't <- readLines("$*.cml"); writeLines(gsub("str>", "strong>", gsub("<rcode([^>]*)>", "<rcode\\1><![CDATA[", gsub("</rcode>", "]]></rcode>", t))), "$*-protected.xml")'
	$(Rscript) toc.R $*-protected.xml
	$(Rscript) bib.R $*-toc.xml
	$(Rscript) foot.R $*-bib.xml

%.Rhtml : %.xml
	# Transform to .Rhtml
	xsltproc knitr.xsl $*.xml > $*.Rhtml

%.html : %.Rhtml
	# Use knitr to produce HTML
	$(Rscript) knit.R $*.Rhtml
	# Check that figures have not changed
	$(Rscript) gdiff.R

docker:
	sudo docker build -t pmur002/groups-report:v2 .
	sudo docker run -v $(shell pwd):/home/work/ -w /home/work --rm pmur002/groups-report:v2 make groups.html

web:
	make docker
	cp -r ../groups-report/* ~/Web/Reports/GraphicsEngine/groups/

zip:
	make docker
	tar zcvf $(TARFILE) ./*
