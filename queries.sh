#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
# Get sum(winner_goals)
WINNER_GOALS=$($PSQL "SELECT SUM(winner_goals) FROM games")
echo $WINNER_GOALS

echo -e "\nTotal number of goals in all games from both teams combined:"
# Get sum(opponent_goals)
OPPONENT_GOALS=$($PSQL "SELECT SUM(opponent_goals) FROM games")
echo $(($OPPONENT_GOALS+$WINNER_GOALS))

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
# Get max(winner_goals)
MAX_WIN_GOALS=$($PSQL "SELECT MAX(winner_goals) FROM games")

# Get max(opponent_goals)
MAX_OPP_GOALS=$($PSQL "SELECT MAX(opponent_goals) FROM games")

# Print the biggest number
if [ $MAX_WIN_GOALS -gt $MAX_OPP_GOALS ]; then
  echo $MAX_WIN_GOALS
else
  echo $MAX_OPP_GOALS
fi

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(winner_goals) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT teams.name FROM teams JOIN games ON teams.team_id=games.winner_id
      WHERE games.year = 2018 AND games.round = 'Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT teams.name FROM teams JOIN (
      SELECT winner_id FROM games WHERE year=2014 AND round='Eighth-Final' UNION ALL 
      SELECT opponent_id FROM games WHERE year=2014 AND round='Eighth-Final'
      ) AS query ON teams.team_id=query.winner_id ORDER BY teams.name")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT(name) FROM teams JOIN games ON teams.team_id=games.winner_id ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT games.year, teams.name FROM teams JOIN games ON teams.team_id=games.winner_id
      WHERE games.round='Final' ORDER BY games.year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
