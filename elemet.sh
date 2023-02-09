#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

  if [[ $1 ]]
  then
    NUMLIST=$($PSQL "SELECT atomic_number FROM elements")
    SYMBLIST=$($PSQL "SELECT symbol FROM elements")
    NAMELIST=$($PSQL "SELECT name FROM elements")
    if [[ ${NUMLIST[*]} =~ "$1" ]]
      then
      ATOMNUMBER=$1
    elif [[ ${SYMBLIST[*]} =~ "$1" ]]
      then
      ATOMNUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1';")
    elif [[ ${NAMELIST[*]} =~ "$1" ]]
      then
      ATOMNUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
    else
      echo -e "I could not find that element in the database."
    fi

    if ! [[ -z $ATOMNUMBER ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMNUMBER';")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMNUMBER';")
      TYPE=$($PSQL "SELECT type FROM properties FULL JOIN types USING(type_id) WHERE atomic_number='$ATOMNUMBER';")
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMNUMBER';")
      MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMNUMBER';")
      BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMNUMBER';")
      
      MODFSYMBOL="$(echo $SYMBOL | sed 's/ *$//')"
      MODIFTYPE="$(echo $TYPE | sed 's/ *$//')"
      MODIFATOMNUMBER="$(echo $ATOMNUMBER | sed 's/ *$//')"
    

      echo -e "The element with atomic number "$MODIFATOMNUMBER" is"$NAME" ("$MODFSYMBOL"). It's a "$MODIFTYPE", with a mass of"$MASS" amu."$NAME" has a melting point of"$MELT" celsius and a boiling point of"$BOIL" celsius."
    fi


  else
    echo -e "Please provide an element as an argument."
  fi
