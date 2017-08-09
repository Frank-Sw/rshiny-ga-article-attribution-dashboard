FROM gcr.io/ep---dev/github-empirical-path-gce-rshiny
MAINTAINER Justin Marciszewski (justin@empiricalpath.com)

# install R package dependencies
RUN apt-get update && apt-get install -y \
	cron \
	nano \
	libssl-dev \
	libxml2-dev \
	libcurl4-openssl-dev \
	## clean up
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/ \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## install R packages 
RUN install2.r --error \
	## from CRAN
	-r 'http://cran.us.r-project.org' \
	tidyr \
	## from github
	# && Rscript -e 'devtools::install_github("")' \
	## clean up
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds

## copy shiny app directory
COPY ./dashboards/ /srv/shiny-server/dashboards

## run extract script 
# RUN cd /srv/shiny-server/dashboards; Rscript extract.R