## code to prepare `us_equation` dataset goes here

#read in the raw equations dataset
us_eq <- read.table("data-raw/us_1978.txt")
japan_eq <- read.table("data-raw/japan_1984.txt")
canada_eq <- read.table("data-raw/canada_re_est.txt")
china_eq <- read.table("data-raw/china_2000.txt")
germany_eq <- read.table("data-raw/germany_2007.txt")

#make the coefficients stuff less annoying
all_combinations <- c(levels(us_eq$V1), levels(japan_eq$V1),
                      levels(canada_eq$V1), levels(china_eq$V1), levels(germany_eq$V1))

all_combinations <- c(us_eq$V1, japan_eq$V1,
                      canada_eq$V1, china_eq$V1, germany_eq$V1)

all_combinations <- tibble(combos = unique(all_combinations))

decoding_coefficients <- tibble(coef_name = all_combinations) %>%
                         mutate(combos = str_remove(coef_name, "Z")) %>%
                         separate(combos, sep = c(3, 6), into = c("A", "B", "O")) %>%
                         rowwise() %>%
                         mutate(AE = if_else(A == "100", 1, 0),
                                AP = if_else(A == "010", 1, 0),
                                AA = if_else(A == "001", 1, 0),
                                BE = if_else(B == "100", 1, 0),
                                BP = if_else(B == "010", 1, 0),
                                BA = if_else(B == "001", 1, 0),
                                OE = if_else(O == "100", 1, 0),
                                OP = if_else(O == "010", 1, 0),
                                OA = if_else(O == "001", 1, 0))

#equation to reshape the equation info
reshape_equation <- function(eq) {
  eq <- tibble(coef_name = eq$V1,
               postAE = eq$V2,
               postAP = eq$V3,
               postAA = eq$V4,
               postBE = eq$V5,
               postBP = eq$V6,
               postBA = eq$V7,
               postOE = eq$V8,
               postOP = eq$V9,
               postOA = eq$V10)

  eq_coef_info <- left_join(eq, decoding_coefficients, by = c("coef_name"))

  return(eq_coef_info)
}

#apply to all equations from Interact
us_1978 <- reshape_equation(us_eq)
japan_1984 <- reshape_equation(japan_eq)
canada_re_est <- reshape_equation(canada_eq)
china_2000 <- reshape_equation(china_eq)
germany_2007 <- reshape_equation(germany_eq)

#put the data into the clean data folder
use_data(us_1978, overwrite = TRUE)
use_data(japan_1984, overwrite = TRUE)
use_data(canada_re_est, overwrite = TRUE)
use_data(china_2000, overwrite = TRUE)
use_data(germany_2007, overwrite = TRUE)
here()

#read in the raw equations dataset
us_emotions <- read.table("data-raw/US_1978_emotion.txt")

#make the coefficients stuff less annoying
all_combinations <- c(levels(us_emotions$V1))

all_combinations <- unique(all_combinations)

decoding_coefficients <- tibble(coef_name = all_combinations) %>%
                         mutate(combos = str_remove(coef_name, "Z")) %>%
                         separate(combos, sep = c(3), into = c("M", "I")) %>%
                         rowwise() %>%
                         mutate(ME = if_else(M == "100", 1, 0),
                               MP = if_else(M == "010", 1, 0),
                               MA = if_else(M == "001", 1, 0),
                               IE = if_else(I == "100", 1, 0),
                               IP = if_else(I == "010", 1, 0),
                               IA = if_else(I == "001", 1, 0))

#equation to reshape the equation info
reshape_emotion_equation <- function(eq) {
            eq <- tibble(coef_name = eq$V1,
                         postME = eq$V2,
                         postMP = eq$V3,
                         postMA = eq$V4)

            eq_coef_info <- left_join(eq, decoding_coefficients, by = c("coef_name"))

            return(eq_coef_info)
}

us_emotions <- reshape_emotion_equation(us_emotions)

use_data(us_emotions, overwrite = TRUE)
