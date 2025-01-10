# Pakete aktivieren ----
library(tidyverse)
library(psych)
source("qualtricshelpers.R")

# Daten einlesen ----
raw <- load_qualtrics_csv("data/finale Testdaten_echter Fragebogen.csv")

# Rohdaten filtern ----
raw %>% 
  filter(Progress == 100) %>% 
  filter(Status == 0) %>% 
  filter(DSGVO == 1) -> raw

# Überflüssige Variablen entfernen ----
raw.short <- raw[,c(6, 9, 19:22, 24:37, 65:70, 74:81, 85:86, 94:99, 107:109, 63)]

# Variablen umbenennen ---- 
generate_codebook(raw.short, "data/finale Testdaten_echter Fragebogen.csv", "data/codebook.csv")
codebook <- read_codebook("data/codebook_final.csv")
names(raw.short) <- codebook$variable

# Korrekte Datentypen zuordnen ----

raw.short$Gender %>% 
  recode('1' = "Männlich", '2' = "Weiblich", '3' = "divers", '4' = "keine Angabe") %>% 
  as.factor() -> raw.short$Gender

raw.short$Bildungsabschluss %>% 
  ordered(levels = c(1:5),
          labels = c("(noch) kein Schulabschluss", 
                     "Hauptschulabschluss", 
                     "Realschulabschluss", 
                     "Abitur", 
                     "Hochschulabschluss")) -> raw.short$Bildungsabschluss
  
raw.short$Wohnort %>% 
  recode('1' = "Ländlich", '2' = "Vorort / Kleinstadt", '3' = "Großstadt") %>% 
  as.factor() -> raw.short$Wohnort

# Qualitätskontrolle ---- 
# Wir machen keine Qualitätskontrolle, weil unsere Cronbachs-Alpha-Werte 
# gut sind und wir bereits ein ausführliches Datacleaning durchgeführt haben.

# Skalenwerte berechnen ----
schluesselliste <- list(
  BF_Offenheit = c("big5_1", "-big5_2n"),
  Vertrauen = c("-nzv_1n", "nzv_2", "nzv_3"),
  ATI = c("ati_1", "ati_2", "-ati_3n", "ati_4", "ati_5", "-ati_6n", "ati_7", "-ati_8n", "ati_9"),
  BI_A = c("biatt_a_1", "biatt_a_2", "biatt_a_3"),
  ATT_A = c("biatt_a_4", "biatt_a_5", "biatt_a_6"),
  TIA_A = c("tia_a_1", "tia_a_2"),
  BI_B = c("biatt_b_1", "biatt_b_2", "biatt_b_3"),
  ATT_B = c("biatt_b_4", "biatt_b_5", "biatt_b_6"),
  TIA_B = c("tia_b_1", "tia_b_2"),
  BI_C = c("biatt_c_1", "biatt_c_2", "biatt_c_3"),
  ATT_C = c("biatt_c_4", "biatt_c_5", "biatt_c_6")
)

scores <- scoreItems(schluesselliste, items = raw.short, min = 1, max = 6)

scores$alpha

data <- bind_cols(raw.short, scores$scores) 

# Daten exprotieren ---- 
write_rds(data, "data/data.rds") 




install.packages("pwr")
library(pwr)

# Variante 1: Stichprobengröße gesucht ----
pwr::pwr.t.test(n = NULL, sig.level = 0.05 , d = 0.8, power = 0.8)

# Variante 2: Signifikanzniveau gesucht ----
pwr::pwr.t.test(n = 200, sig.level = NULL , d = 0.2, power = 0.8)

# Variante 3: Effektstärke gesucht ----
pwr::pwr.t.test(n = 110, sig.level = 0.05 , d = NULL, power = 0.8)
# Es geht in Richtung mittelstarker Effekt, um die Effektstärke detektieren 
# zu können.

# Variante 4: Power gesucht ----

library(dataforsocialscience)
library(tidyverse)
library(lsr)
df <- robo_care
df_male <- filter(df, df$gender == "male")
df_female <- filter(df, df$gender == "female")

t.test(df_male$privacy_concerns, df_female$privacy_concerns)
cohensD(df_male$privacy_concerns, df_female$privacy_concerns)

pwr::pwr.t.test(n = 122, sig.level = 0.05, d = 0.04400775, power = NULL)
