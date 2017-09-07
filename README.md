# R Shiny Google Analytics Article Attribution Dashboard

## Scope

## Executive Summary

## Manual Refresh

- execute `gaExtract.R` 

## Hosting Setup

- Setup GCP project (already done)
- Create VCP firewall rules (screenshot: http://d.pr/i/tq7Hu4)
	- default-allow-http - tcp:80
	- default-allow-rshiny - tcp:3838
- exported service account key from GCP
- created GCS bucket 
- added service account to gcs bucket for access
- build shiny app locally
- setup docker file
- setup git repo
- create build trigger
- push code to git repo
- Launch VM via `launch_vm.R`
- SSH into instance, run `$ docker exec -it shinyserver bash`
- perform initial data extract `$ Rscript extract.R`

## Resources

## TODO

- anonomyze email data, save to this project
- anonomyze ga_account info data, save to this project
- build out email `index.Rmd`
- draft wireframe
- draft spec sheet (from gtihub)
- draft list of R params to update