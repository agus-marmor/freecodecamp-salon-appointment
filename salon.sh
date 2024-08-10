#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t -c "

echo -e "\n~~~~~ AGUSTIN'S SALON ~~~~~"

DISPLAY_SERVICES() {
    if [[ $1 ]] 
    then
      echo -e "\n$1"
    fi
    SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id" | sed 's/^[[:space:]]*//;s/[[:space:]]*|[[:space:]]*/) /;s/[[:space:]]*$//')
    echo "$SERVICES"
}
MAIN_MENU(){
 DISPLAY_SERVICES "\nWelcome to Agustin's Salon, how can I help you?"
 read SERVICE_ID_SELECTED

 SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
 if [[ -z $SERVICE_NAME ]]
 then
  MAIN_MENU "I couldn't find that service. Please try again."
 else
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number. What's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
 fi

  
}


MAIN_MENU