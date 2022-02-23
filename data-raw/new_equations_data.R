## code to prepare `equation_coef` dataset goes here

all_equations <- c("us2010_impressionabo_av", "us2010_impressionabos_f",
                   "us2010_impressionabos_m", "us2010_selfdir_f",
                   "us2010_selfdir_m", "us2010_traitid_av", "us2010_emotionid_f",
                   "us2010_emotionid_m", "nc1978_impressionabo_f", "nc1978_impressionabo_m",
                   "nc1978_impressionabos_f", "nc1978_impressionabos_m", "nc1978_selfdir_f",
                   "nc1978_selfdir_m", "nc1978_traitid_av", "nc1978_emotionid_f", "nc1978_emotionid_m",
                   "morocco2015_impressionabo_av", "morocco2015_impressionabos_f",
                   "morocco2015_impressionabos_m", "morocco2015_selfdir_f",
                   "morocco2015_selfdir_m", "morocco2015_traitid_av", "morocco2015_emotionid_f",
                   "morocco2015_emotionid_m", "japan1984_impressionabo_f", "japan1984_impressionabo_m",
                   "japan1984_impressionabos_f", "japan1984_impressionabos_m",
                   "japan1984_selfdir_f", "japan1984_selfdir_m",
                   "japan1984_traitid_f", "japan1984_traitid_m", "japan1984_emotionid_f",
                   "japan1984_emotionid_m", "egypt2014_impressionabo_av",
                   "egypt2014_impressionabos_f", "egypt2014_impressionabos_m",
                   "egypt2014_selfdir_f", "egypt2014_selfdir_m", "egypt2014_traitid_av",
                   "egypt2014_emotionid_f", "egypt2014_emotionid_m",
                   "germany2007_impressionabo_av", "germany2007_impressionabos_f",
                   "germany2007_impressionabos_m", "germany2007_selfdir_f", "germany2007_selfdir_m",
                   "germany2007_traitid_av", "germany2007_emotionid_av", "china2000_impressionabo_f",
                   "china2000_impressionabo_m", "china2000_impressionabos_f",
                   "china2000_impressionabos_m", "china2000_selfdir_f", "china2000_selfdir_m",
                   "china2000_traitid_f", "china2000_traitid_m", "china2000_emotionid_f",
                   "china2000_emotionid_m", "canada20012003_impressionabo_f",
                   "canada20012003_impressionabo_m", "canada20012003_impressionabos_f",
                   "canada20012003_impressionabos_m", "canada20012003_selfdir_f",
                   "canada20012003_selfdir_m", "canada20012003_traitid_av",
                   "canada20012003_emotionid_av", "canada1985_impressionabo_f",
                   "canada1985_impressionabo_m", "canada1985_impressionabos_f", "canada1985_impressionabos_m",
                   "canada1985_selfdir_f", "canada1985_selfdir_m", "canada1985_traitid_av", "canada1985_emotionid_av")

make_equation_data_set <- function(eq_name){

  eq_info <- tibble(eq_name = eq_name,
                    eq_name_new = paste(eq_name, "eqn", sep = "_"))

  eq_split <- eq_info %>% tidyr::separate(eq_name, into = c("key", "equation_type", "gender", "eqn"),
                       sep = "_")

  eq_split <- eq_split %>% dplyr::mutate(df = list(get(eq_name_new)))

  return(eq_split)

}

#apply to all of the equations
all_equations_data <- purrr::map_df(all_equations, make_equation_data_set)

#fix the gender variable
all_equations_data_clean <- all_equations_data %>%
                            mutate(gender = case_when(gender == "av" ~ "average",
                                                      gender == "f" ~ "female",
                                                      gender == "m" ~ "male")) %>%
                            select(-eqn)

#name something better lol
equations_dataframe <- all_equations_data_clean

#save :)
usethis::use_data(equations_dataframe, overwrite = TRUE)

####### MAKE REGULAR COEF DATAFRAME
only_regular <- equations_dataframe %>%
                filter(equation_type == "impressionabo") %>%
                tidyr::unnest_longer(df) %>% select(df)

unique_coefficients <- unique(only_regular$df$V1)

impression_coefficients <- tibble(coef_name = unique_coefficients) %>%
  mutate(combos = str_remove(coef_name, "Z")) %>%
  tidyr::separate(combos, sep = c(3, 6), into = c("A", "B", "O")) %>%
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

usethis::use_data(impression_coefficients, overwrite = TRUE)

####### MAKE EMOTIONS COEF DATAFRAME

only_emotions <- equations_dataframe %>%
                 filter(equation_type == "traitid" |
                          equation_type == "emotionid") %>%
                  tidyr::unnest_longer(df) %>%
                  select(df)

unique_coefficients <- unique(only_emotions$df$V1)

emotions_coefficients <- tibble(coef_name = unique_coefficients) %>%
                          mutate(combos = str_remove(coef_name, "Z")) %>%
                          tidyr::separate(combos, sep = c(3), into = c("M", "I")) %>%
                          rowwise() %>%
                          mutate(ME = if_else(M == "100", 1, 0),
                                 MP = if_else(M == "010", 1, 0),
                                 MA = if_else(M == "001", 1, 0),
                                 IE = if_else(I == "100", 1, 0),
                                 IP = if_else(I == "010", 1, 0),
                                 IA = if_else(I == "001", 1, 0))


usethis::use_data(emotions_coefficients, overwrite = TRUE)

