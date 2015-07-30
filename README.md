# Medical Patient Data to CSV Parser

## Ruby Based Parser for DCH and FAY CSV based data to CSV based data for Collect
  - Takes a DCH and FAY CSV file and parses line by line each patient data
  - Parsed data is placed into a CSV formatted file
  - Exported CSV files follow file name output as follows:

### DCH
    1. DEM DCH SMALL.csv
    2. ADJUSTMENT DCH SMALL.csv
    3. DEM DCH MEDICAID.csv
    4. ADJUSTMENT DCH MEDICAID.csv
    5. DEM DCH LARGE.csv
    6. ADJUSTMENT DCH LARGE.csv

### FAY
    1. DEM FAY SMALL.csv
    2. ADJUSTMENT FAY SMALL.csv
    3. DEM FAY LARGE.csv
    4. ADJUSTMENT FAY LARGE.csv

## Todo
  + Needs to be able to parse adjustments into separate CSV files
  - See Full [Todo Checklist] (https://github.com/bradbajuz/med-parser/blob/master/Todo.md)