library(dplyr)
library(readr)

INPUT <- "outputs/ws_predictions.csv"

pred <- read_csv(INPUT, show_col_types = FALSE)

# Team total salary (example)
team_total_salary <- 130493067

total_ws <- sum(pred$WS_pred, na.rm = TRUE)
cost_per_win <- team_total_salary / total_ws
cat(sprintf("Estimated Cost per Win: $%.0f\n", cost_per_win))

# Example valuation
players <- pred %>% select(Player, WS_pred, Salary = CurrentSalary) %>% mutate(
  EstimatedValue = WS_pred * cost_per_win,
  UnderOver = EstimatedValue - Salary
)

write.csv(players, "outputs/player_value_estimates.csv", row.names = FALSE)
