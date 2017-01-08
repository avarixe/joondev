# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

PLAYERS = [
  { team_id: 1, name: 'Jordi Masip',            pos: 'GK',    sec_pos: nil          },
  { team_id: 1, name: 'Jasper Cillessen',       pos: 'GK',    sec_pos: nil          },
  { team_id: 1, name: 'Marc-Andre ter Stegen',  pos: 'GK',    sec_pos: nil          },
  { team_id: 1, name: 'Thibaut Courtois',       pos: 'GK',    sec_pos: nil          },
  { team_id: 1, name: 'Lee Harrison',           pos: 'GK',    sec_pos: nil          },
  { team_id: 1, name: 'Ryan Shawcross',         pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Borja Lopez',            pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Gerard Pique',           pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Joel Matip',             pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Inigo Martinez',         pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Jonathan Tah',           pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Jose Maria Gimenez',     pos: 'CB',    sec_pos: nil          },
  { team_id: 1, name: 'Jordi Alba',             pos: 'LB',    sec_pos: nil          },
  { team_id: 1, name: 'Lucas Digne',            pos: 'LB',    sec_pos: nil          },
  { team_id: 1, name: 'Douglas',                pos: 'RB',    sec_pos: 'RM'         },
  { team_id: 1, name: 'Aleix Vidal',            pos: 'RB',    sec_pos: 'RM'         },
  { team_id: 1, name: 'Sergi Palencia',         pos: 'RB',    sec_pos: 'LB'         },
  { team_id: 1, name: 'Nili Perdomo',           pos: 'RB',    sec_pos: 'RM'         },
  { team_id: 1, name: 'Hector Bellerin',        pos: 'RB',    sec_pos: nil          },
  { team_id: 1, name: 'Sergi Samper',           pos: 'CDM',   sec_pos: 'CM'         },
  { team_id: 1, name: 'Sergio Busquets',        pos: 'CDM',   sec_pos: nil          },
  { team_id: 1, name: 'Gerard',                 pos: 'CM',    sec_pos: 'CDM,CB'     },
  { team_id: 1, name: 'Carles Alena',           pos: 'CM',    sec_pos: 'CAM,CDM'    },
  { team_id: 1, name: 'Wilfrid Kaptoum',        pos: 'CM',    sec_pos: 'CDM'        },
  { team_id: 1, name: 'Rodrigo Bentancur',      pos: 'CM',    sec_pos: nil          },
  { team_id: 1, name: 'Gianluca Gaudino',       pos: 'CM',    sec_pos: 'CDM'        },
  { team_id: 1, name: 'Sergi Roberto',          pos: 'CM',    sec_pos: 'RB,CDM'     },
  { team_id: 1, name: 'Rafinha',                pos: 'CM',    sec_pos: 'RW,LW,CDM'  },
  { team_id: 1, name: 'Oguzhan Ozyakup',        pos: 'CM',    sec_pos: nil          },
  { team_id: 1, name: 'Andre Gomes',            pos: 'CM',    sec_pos: 'LM,CAM,CDM' },
  { team_id: 1, name: 'Denis Suarez',           pos: 'LM',    sec_pos: 'RM,CM'      },
  { team_id: 1, name: 'Goncalo Guedes',         pos: 'RM',    sec_pos: 'LM,ST'      },
  { team_id: 1, name: 'Juan Camara',            pos: 'LW',    sec_pos: 'CAM,RW'     },
  { team_id: 1, name: 'Neymar',                 pos: 'LW',    sec_pos: nil          },
  { team_id: 1, name: 'Lionel Messi',           pos: 'RW',    sec_pos: nil          },
  { team_id: 1, name: 'Abdelhak Nouri',         pos: 'CAM',   sec_pos: 'CM'         },
  { team_id: 1, name: 'Davy Klaassen',          pos: 'CAM',   sec_pos: 'CM'         },
  { team_id: 1, name: 'Christian Erikson',      pos: 'CAM',   sec_pos: 'LM'         },
  { team_id: 1, name: 'Alex Carbonell',         pos: 'CF',    sec_pos: 'RW'         },
  { team_id: 1, name: 'Rafa Mujica',            pos: 'ST',    sec_pos: nil          },
  { team_id: 1, name: 'Marc Cardona',           pos: 'ST',    sec_pos: nil          },
  { team_id: 1, name: 'Gyasi Zardes',           pos: 'ST',    sec_pos: 'RM,LM'      },
  { team_id: 1, name: 'Munir',                  pos: 'ST',    sec_pos: 'LW,RW'      },
  { team_id: 1, name: 'Luis Suarez',            pos: 'ST',    sec_pos: nil          },
  { team_id: 1, name: 'Paco Alcacer',           pos: 'ST',    sec_pos: nil          },
  { team_id: 1, name: 'Angel Correa',           pos: 'ST',    sec_pos: 'CAM,CF'     },
  { team_id: 1, name: 'Antonio Sanabria',       pos: 'ST',    sec_pos: 'LM'         },
  { team_id: 1, name: 'Romelu Lukaku',          pos: 'ST',    sec_pos: nil          }
]

PLAYERS.each do |p|
  Cmsk::Player.create(p)
end