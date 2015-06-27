# Medical Patient Data to CSV Converter

## DCH and FAY Data Ruby Converter to CSV
  - Takes a DCH and FAY text file and parses line by line each patient data
  - Parsed data is placed into a CSV formatted file
  - Accounts for changes in accounts numbers
  - Exported CSV files follow file name output as follows:

### DCH
    1. DEM DCH SMALL.csv
    2. ADJUSTMENT DCH SMALL.csv
    3. DEM DCH MEDICAID.csv
    4. ADJUSTMENT DCH MEDICAID.csv
    5. DEM DCH LARGE.csv
    6. ADJUSTMENT DCH LARGE.csv

### FAY
    1. DEM FAY SMALL
    2. ADJUSTMENT FAY SMALL
    3. DEM FAY LARGE
    4. ADJUSTMENT FAY LARGE

## Todo
  + Needs to be able to parse adjustments into seperate CSV files
  - See Full [Todo Checklist] (https://github.com/bradbajuz/med-parser/blob/master/Todo.md)