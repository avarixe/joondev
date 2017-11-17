# :nodoc:
module MyFifa
  PLAYER_POSITIONS = %w[
    GK
    CB
    LB
    LWB
    RB
    RWB
    CDM
    CM
    LM
    RM
    LW
    RW
    CAM
    CF
    ST
  ].freeze

  FORMATION_LAYOUTS = [
    '3-1-2-1-3',
    '3-1-4-2',
    '3-4-1-2',
    '3-4-2-1',
    '3-4-3',

    '4-1-2-1-2',
    '4-1-2-3',
    '4-1-3-2',
    '4-2-1-3',
    '4-2-2-2',
    '4-2-3-1',
    '4-2-4',
    '4-3-1-2',
    '4-3-2-1',
    '4-3-3',
    '4-4-2'
  ].freeze

  RATING_COLORS = {
    40  => '#FF0000',
    45  => '#FB2D00',
    50  => '#F85A00',
    55  => '#F58600',
    60  => '#F2B000',
    65  => '#EFD900',
    70  => '#D6EC00',
    75  => '#A9E900',
    80  => '#7DE600',
    85  => '#52E300',
    90  => '#28E000',
    95  => '#00DD00',
    100 => '#00FF00'
  }.freeze

  COUNTRY_FLAGS = {
    # Europe
    'Belgium'          => 'be',
    'England'          => 'gb',
    'France'           => 'fr',
    'Germany'          => 'de',
    'Gibraltar'        => 'gi',
    'Ireland'          => 'ie',
    'Italy'            => 'it',
    'Netherlands'      => 'nl',
    'Northern Ireland' => 'gb',
    'Portugal'         => 'pt',
    'Russia'           => 'ru',
    'Scotland'         => 'gb sct',
    'Spain'            => 'es',
    'Switzerland'      => 'ch',
    'Wales'            => 'gb wls',

    # North America
    'Canada'        => 'ca',
    'Costa Rica'    => 'cr',
    'Mexico'        => 'mx',
    'United States' => 'us',

    # South America
    'Argentina' => 'ar',
    'Brazil'    => 'br',
    'Chile'     => 'cl',
    'Colombia'  => 'co',
    'Uruguay'   => 'uy',
    'Venezuela' => 've',

    # Asia
    'Australia'   => 'au',
    'China'       => 'cn',
    'India'       => 'in',
    'Japan'       => 'jp',
    'South Korea' => 'kr',

    # Africa
    'Cameroon'     => 'cm',
    'Cote Divoire' => 'ci',
    'Egypt'        => 'eg',
    'Guyana'       => 'gy'
  }.freeze

  BONUS_STAT_TYPES = [
    'Appearances',
    'Goals',
    'Assists',
    'Clean Sheets'
  ].freeze
end
