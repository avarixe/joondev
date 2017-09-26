
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

Formation Class:
  Stores possible formation layouts for Squads

Player Class:
  Store general information about Players on the Team
  
Squad Class:
  Collection of Players with assigned positions
  For quick insert into Game Class
  
Game Class:
  Stores Information about Game played
  Collection of many Player Records

PlayerRecord Class:
  Collection of a Player's Match stats in a game


PLAYER MANAGEMENT CLASSES

  Contract Class:
    Information about Player's Contract (length, $, origin, etc)
      - Start Date
      - End Date
      * has_many ContractTerms
      - Origin
      - Transfer Cost
      - Loan
      * Destination
      - Exit Cost

  Cost Class:
    record of Cost of a player for transaction
      - Price (TODO: Rename to Fee)
      - Traded Player
      * Add-on Clause
  
  ContractTerm Class:
    Latest instance supercedes previous terms of Contract
      + Date Expires
      + Wage
      + Bonus
      + Number of Stats
      + Stat Type
      + Release Clause
    
  Injury Class:
    Record of a Player's Injury
  
  Loan Class:
    Record of a Player going on Loan