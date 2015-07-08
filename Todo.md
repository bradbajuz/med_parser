### PARSE FILE to CSV CHECK LIST

~~Insert Acvite~~

~~Insert ACT~~

~~Copy/Insert Account # but leaving out 0~~

~~Copy/Insert Full Name (Last First I)~~

#### TODO
- Copy/Insert Street Address
- Insert 2 Commas(, ,)
- Copy/Insert City
- Copy/Insert State
- Copy/Insert Zip
- Copy/Insert up to first 8 digits of 17 character string
- Copy/Insert last 9 digits (SSN) of 17 character string. Add (- -) if SSN is blank (no 9 digits in 17 character string)
- Copy/Insert 10 digit personal phone number. Needs to be in the format of (123) 456-7890. Should be all digits up to last name
- Copy/Insert Total (xxxx.xx) by starting at first (? alpha character or blank and/or "+" up to second "+", ignore first 3 zero's, take only next 6 digits)
- Copy/Insert following Total copy, get next 8 digits (same as next 8 digits)
- Copy/Insert following Total copy, get next 8 digits (same as previous 8 digits)
- Insert a "4"
- Copy/Insert Insurance Provider
- Copy/Insert Insurance Provider Street/PO Box Address
- Insert 2 Commas(, ,)
- Copy/Insert City State Zip (some zip codes have a "-", if so get only next 3 digits)
- Copy/Insert 10 digit provider phone number. Needs to be in the format of (123) 456-7890. Should be all digits up to last name. If blank, insert "( ) - "
- Copy/Insert all digits up to first alpha character
- Insert a "4"
- Insert 4 Commas ( , , , ,) if nothing exists
- Insert "( ) - " if nothing exists
- Insert 3 Commas ( , , ,)
- Insert a "4"
- Insert 4 Commas ( , , , ,) if nothing exists
- Insert "( ) - " if nothing exists
- Insert 3 Commas ( , , ,)
- Insert a "4"
- Insert " Dr Info"
- Copy/Insert all characters up to next digit
- Copy/Insert all characters up to next alpha character
- Copy/Insert Doctor name if it exists. If not, Insert 
- Insert commas until next digit or until next alpha character
- Copy/Insert Insurance Provider
- Ignore anything after Insurance Provider (mainly numbers)