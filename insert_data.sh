#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Delete all data in the tables
echo $($PSQL "TRUNCATE TABLE games, teams;")
echo $($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1;")

tail -n +2 "games.csv" | while IFS=, read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Insert the team names from the winners into the teams table
  echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")

  # Insert the team names from the opponents into the teams table
  echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")

  # Get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")

  # Get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")

  # Insert the year, round, winner_id, opponent_id, winner_goals and opponent goals into the games table
  echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")

done
