library(rvest)
library(tidyverse)

html_obj <- read_html("https://fantasydata.com/nfl/fantasy-football-leaders?position=1&season=2019&seasontype=1&scope=1&subscope=1&startweek=1&endweek=17&aggregatescope=1&range=3")
html_obj

class(html_obj)

player_elements <- html_nodes(html_obj, css = "#stats_grid td+ td , #stats_grid a , #home .ng-scope .align-left a , #home .ng-scope .ng-binding")
head(player_elements)

player_text <- html_text(player_elements)
head(player_elements)

player_text
tibble(text = player_text)

tibble(text = player_text) %>%
  mutate(rownum = row_number(),
         iseven = rownum %% 2 == 0,
         team = rep(1:50, each = 2)) %>%
  select(-rownum) %>% #take out row that wasn't specified
  pivot_wider(names_from = iseven, values_from = text) %>%
  select(-team, "name" = "FALSE", team = "TRUE") %>%
  mutate(name = str_sub(name, start = 1, end = -9),
         rank = 1:50) %>%
  select(rank, name, team) ->
  player_rank
head(player_rank)