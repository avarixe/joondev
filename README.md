
          .--.                     
          |  |                     ,------.  ,------. ,--.  ,--.
          |  | ,---.  ,---.  ,---. |  .-.  \ |  .---''   | /   /
          |  || .-. || .-. ||  _  ||  |  \  :|  `--, |   |/   /
      .---'  |' '-' '' '-' '| | | ||  '--'  /|  `---.'       /
      `------' `---'  `---' `-' '-'`-------' `------' `-----'
    -------------------------------------------------------------- 

## CMSK Documentation

Team Class:
  Overhead class that encapsulates Players, Squads, Games, Records

Player Class:
  Store general information about Players on the Team
  
Squad Class:
  Collection of Players with assigned positions
  For quick insert into Game Class
  
Game Class:
  Stores Information about Game played
  Collection of many Player Records

PlayerRecord Class:
  Collection of a Player's Rating, Goals and Assists in a game

## CHANGE LOG

#### 0.1.0 (1-7-17)
  - Reorganized previous CMSK into Rails Engine
  - Live on play.joondev.com, replacing cmsk.joondev.com
  - Created top level for organizing future projects
  - Cookies to set current Team observed
  - Players have "ACTIVE" status to indicate visibility status
  - Added functionality to add as many SUBs as needed
  - Upgraded to Bootstrap 4alpha

## TODO

#### DASHBOARD
  - Add image button for CMSK
  
#### CMSK
  - New Team, Player actions into modals and AJAX calls
  - Player Performance Analysis
  - MAYBE: Competition model with jQuery Bracket display, based on competition type
  - Better side menu for Engine level
  - MAYBE: Add More Player Details
  - User Customizability to control Excel output 
