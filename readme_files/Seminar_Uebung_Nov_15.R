# Pakete installieren

# install.packages("tidyverse")
# install.packages("psych")
# install.packages("plotrix")
# install.packages("remotes")
# remotes::install_github("statisticsforsocialscience/dataforsocialscience")

# Pakete aktivieren
library(tidyverse)
library(psych)
library(plotrix)
library(dataforsocialscience)

# Daten einlesen
df <- robo_care

table(df$gender)
qplot(df$gender)

median(df$age)
quantile(df$age)
boxplot(df$age)
mad(df$age)

table(df$cse)
qplot(df$cse)
median(df$cse)
quantile(df$cse)
boxplot(df$cse)
mad(df$cse)
sd(df$cse)
std.error(df$cse)

