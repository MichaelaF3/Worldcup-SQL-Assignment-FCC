#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

#TEAMS
#team_id SERIAL P-Key
#name VARCHAR UNIQUE NOT NULL


#GAMES
#game_id SERIAL P-Key
#year INT NOT NULL
#round VARCHAR NOT NULL
#winner_id INT NOT NULL F-Key
#opponent_id INT NOT NULL F-Key
#winner_goals INT NOT NULL F-Key
#opponent_goals INT NOT NULL F-Key


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOAL OGOAL
do
if [[ $WINNER != 'winner' ]]
  then
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    if [[ -z $WINNER_ID ]]
     then
      INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    fi
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
      then
      INSERT_TEAM_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi
fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOAL OGOAL
do
 if [[ $YEAR != 'year' ]]
    then
    #Get game ID
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year='$YEAR'")
     
    #if game id not found
      if [[ -z $GAME_ID ]]
        then
        GAME_ID=NULL
      fi
    W_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    O_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
     #Insert Major
        INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $W_ID, $O_ID, $WGOAL, $OGOAL)")
  
  fi

done
  
