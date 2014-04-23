-- grid element legend xyz :
-- x : marked, y : item level, z : item color
-- colors values :  "green", "cyan", "magenta", "blue", "red", "green", "yellow"
-- maxItemLevel values : 1-6
-- victory condition values : "clean"
level_1 = {
  value = 1,
  grid = {
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "x3yellow",            "",            "",    "",    "" },
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "x3green",     "x3green",            "",            "",    "" },
    {"",          "",         "",            "",            "",            "x3magenta",            "",    "" },
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "",            "",            "",            "",    "" },
    {"",          "",         "",            "",            "",            "x3green",            "",    "" },
  },
  colors = { "green", "yellow", "magenta", "blue", "red" , "cyan"},
  maxItemLevel = 3,
  minItemLevel = 3,
  victoryCondition = "clean",
}


level_2 = {
  value = 1,
  grid = {
    {"x6magenta",          "",         "",            "",            "",            "",            "",    "x6magenta" },
    {"x6magenta",  "x6magenta",         "",            "",            "",            "",    "x6magenta",    "x6magenta" },
    {"x6magenta",          "x6green", "x6magenta",            "",            "",    "x6magenta",            "x6green",    "x6magenta" },
    {"x6magenta",          "x6green",         "x6green",    "x6magenta",    "x6magenta",            "x6green",            "x6green",    "x6magenta" },
    {"x6magenta",          "x6green",         "x6green",            "x6green",            "x6green",            "x6green",            "x6green",    "x6magenta" },
    {"x6magenta",          "x6green",         "x6green",            "x6green",            "x6green",            "x6green",            "x6green",    "x6magenta" },
    {"x6magenta",          "x6green",         "x6green",            "x6green",            "x6green",            "x6green",            "x6green",    "x6magenta" },
    {"x6magenta",          "x6green",         "x6green",            "x6green",            "x6green",            "x6green",            "x6green",    "x6magenta" },
  },
  colors = { "magenta" },
  maxItemLevel = 6,
  minItemLevel = 6,
  victoryCondition = "clean",
}