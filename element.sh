#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]] 
then 
  RESPONSE="DONE"
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
then 
  RESPONSE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $1")
else 
  RESPONSE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol = '$1'  OR name = '$1'")
fi

if [[ ! -z $RESPONSE && ! $RESPONSE == 'DONE' ]]
then
  echo "$RESPONSE" | while read ATOMIC_NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
  do 
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
elif [[ -z $RESPONSE ]]
then
  echo "I could not find that element in the database."
fi
