# judgement_app

Setup:

1) Make sure required files (Employment by..., constraint, driver, LMO 202* Industry...) are in the raw_data directory
2) Run the script process.R which is in the raw_data directory (pre-processes files, saves as feather files)

To use: 

1) open Rstudio by double clicking on the .Rproj file.
1b) Install my R package: devtools::install_github("rpmartin/aest").
2) from the files tab double click on the judgement.Rmd file.
3) Click on the LEFT play button (Run Document).
4) Choose an industry, a forecast method, make adjustments, and then save your forecast to disk.
5) Forecasts are appended to file forecasts.csv which can be found in folder forecast_output.

After forecasts made:

1) Run the script remove_dups.R which is in folder forecast_output.
2) Run the script csv_and_pdf_output.R which is in folder csv_and_pdf_output.