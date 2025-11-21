library(dplyr)
library(readr)

INPUT <- "data/players_2020_2023.csv" # combined seasons with columns VORP, MP, G, PER, TS, BPM, TRB, DRB, ORB, WS

df <- read_csv(INPUT, show_col_types = FALSE)

# Train/test split
set.seed(42)
idx <- sample(1:nrow(df), size = 0.5*nrow(df))
train <- df[idx, ]
test  <- df[-idx, ]

# Fit WS model
ws_lm <- lm(WS ~ VORP + MP + G + PER + TS + BPM + TRB + DRB + ORB, data = train)
print(summary(ws_lm))

# Predict
test$WS_pred <- predict(ws_lm, newdata = test)
resid_mean <- mean(test$WS_pred - test$WS, na.rm = TRUE)
cat("Residual mean:", resid_mean, "\n")

write.csv(test, "outputs/ws_predictions.csv", row.names = FALSE)
