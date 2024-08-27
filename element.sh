#!/bin/bash

# psql connect variable
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"



DATADERIVE() {

  # accessing arg for the function
   argdata=$1

  # checking if arg is a number
  if [[ $argdata =~ ^-?[0-9]+$ ]]
  then
    DATA=$($PSQL "SELECT * FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $argdata") 

  else
    # getting the length of argdata
    length=${#argdata} 

    # if length is less than 3 likely it a symbol
     if [[ $length -lt 3 ]]
     then
        DATA=$($PSQL "SELECT * FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$argdata' ") 
      else
        DATA=$($PSQL "SELECT * FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$argdata' ") 
      fi

  fi


}


# checking if an arguement was passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number='1'")
  IFS="|" read -r NUM SIGN NAME <<< "$ELEMENT"
  echo $NAME

  echo "$($PSQL "SELECT * FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = 1")"
fi