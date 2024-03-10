#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, how can I help you?\n"


GET_SERVICE_ID() {

  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  LIST_SERVICES=$($PSQL "SELECT *  FROM services")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    NAME=$(echo $SERVICE_NAME | sed 's/ //g')
    echo "$ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    [1-5]) NEXT;;
    *) GET_SERVICE_ID "I could not find that service. What would you like today?";;
  esac

}

NEXT(){

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  if [[ -z $NAME ]]
  then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  ADD_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME' , '$CUSTOMER_PHONE')" )
  fi

  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo -e "\nWhat time would you like your $GET_SERVICE_NAME, $CUSTOMER_NAME"
  read SERVICE_TIME
  ADD_TO_APPOINTMENTS=$($PSQL "INSERT INTO  appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  if [[ $ADD_TO_APPOINTMENTS == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." 
  fi


  

}





GET_SERVICE_ID