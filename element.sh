#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


# If you run ./element.sh 1, ./element.sh H, or ./element.sh Hydrogen, it should output The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.


re='^[0-9]+$'
ARGUMENT=$1
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ $re ]]
  then
    # Argument is a number
    ELEMENT=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number=$1")
  elif [[ ${#ARGUMENT} -ge 3 ]]
  then
    # Argument is a name
    ELEMENT=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name='$1'")
  else
    # Argument is a symbol
    ELEMENT=$($PSQL "SELECT * FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol='$1'")
  fi
  
  if [[ -z $ELEMENT ]]
    then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
    do
    # The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
fi


