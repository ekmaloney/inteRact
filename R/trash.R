#select fundamental sentiment terms related to behavior
element_def <- element_def %>%
  mutate(f_s_b = if_else(element == "B",
                         fundamental_sentiment, 1))

#select transient impression terms related to behavior
z_b <- us_1978 %>%
  mutate(z_b = case_when(B == "000" ~ 1,
                         B == "100" ~ element_def$trans_imp[4],
                         B == "010" ~ element_def$trans_imp[5],
                         B == "001" ~ element_def$trans_imp[6])) %>%
  select(z_b)

#save as a vector
z_b <- c(as.vector(element_def$f_s_b), as.vector(z_b$z_b))

#now get the non-behavior terms from each
element_def <- element_def %>%
  mutate(f_s_i = if_else(element != "B",
                         fundamental_sentiment, 1))

i <- us_1978 %>%
  mutate(i = case_when(A == "000" & O == "000" ~ 1,
                       A == "100" & O == "000"~ element_def$trans_imp[1],
                       A == "010" & O == "000"~ element_def$trans_imp[2],
                       A == "001" & O == "000"~ element_def$trans_imp[3],
                       O == "100" & A == "000"~ element_def$trans_imp[7],
                       O == "010" & A == "000"~ element_def$trans_imp[8],
                       O == "001" & A == "000"~ element_def$trans_imp[9],
                       A == "100" & O == "010"~ element_def$trans_imp[1]*element_def$trans_imp[8],
                       A == "100" & O == "100"~ element_def$trans_imp[1]*element_def$trans_imp[7])) %>%
  select(i)

#save as a vector
i <- c(as.vector(element_def$f_s_i), as.vector(i$i))

#make into a matrix with that on the diagonal
mat_i <- matrix(0, 29, 29)
diag(mat_i) <- i

#extract the terms that are not Behavior
mat_i <- extract_terms(elem = "B", t_imp = element_def)

test_cases <- tibble(actor = sample(us_2015_full$term[us_2015_full$type == "identity"], 1),
                     behavior = sample(us_2015_full$term[us_2015_full$type == "behavior"], 1),
                     object = sample(us_2015_full$term[us_2015_full$type == "identity"], 1))

us_2015_full %>% filter(term %in% test_cases)
