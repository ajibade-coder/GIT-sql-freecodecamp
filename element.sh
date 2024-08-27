#!/bin/bash

# psql connect variable
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"


# func to check the  data type in other to get data from database
DATADERIVE() {

  # accessing arg for the function
   argdata=$1

  # checking if arg is a number
  if [[ $argdata =~ ^-?[0-9]+$ ]]
  then
    DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass,  melting_point_celsius, boiling_point_celsius, type  FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $argdata") 

  else
    # getting the length of argdata
    length=${#argdata} 

    # if length is less than 3 likely it a symbol
     if [[ $length -lt 3 ]]
     then
        DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass,  melting_point_celsius, boiling_point_celsius, type FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$argdata' ") 

        # otherwise it a name of element
      else
        DATA=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass,  melting_point_celsius, boiling_point_celsius, type FROM elements JOIN  properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$argdata' ") 
      fi

  fi


}

# func to give a result based on the data gotten
DATA_RESULT() {
  # if data cant be found ....
  if [[ -z $DATA ]]
  then
      echo "I could not find that element in the database."

    # if data varaiable not empty
  else
      IFS="|" read -r atomic_number symbol name atomic_mass  melting_point_celsius boiling_point_celsius type <<< "$DATA"

      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
}


# checking if an arguement was passed
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else

DATADERIVE $1

DATA_RESULT

  

fi