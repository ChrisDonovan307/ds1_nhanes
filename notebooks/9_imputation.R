str(iris)
getwd()


# Housekeeping ------------------------- 

if (!require('pacman')) install.packages('pacman')
pacman::p_load(
  dplyr,
  purrr,
  naniar,
  ggplot2,
  skimr,
  missForest
)
pacman::p_load_gh('ChrisDonovan307/projecter')
dat <- read.csv('data/clean/df_nhanes_2017_2023.csv')
get_str(dat)


# Visualize Missing Data -------------------------

# Visualize across all columns
vis_miss(dat, warn_large_data = FALSE)
# Only income is missing data

# Check how much missing data there is total
mean(is.na(dat)) * 100
# Missing  0.23% overall

# Check for just income ratio
mean(is.na(dat$income_ratio)) * 100
# Missing 11.6%

# Reduce to demos only
demos <- select(dat, age, gender, race, education, income_ratio)

# Look at it by race and education
gg_miss_fct(demos, race)
gg_miss_fct(demos, education)
# Seems to vary by both


# Nature of Missingness -------------------------

mcar_test(demos)
# Null hypothesis is MCAR. Significant result suggests not MCAR

# Use a regression to test for MAR
# First create binary variable for missingness
demos$missing <- ifelse(is.na(demos$income_ratio), 1, 0)

# Logistic regression
model <- glm(
  missing ~ age + gender + race + education,
  data = demos,
  family = 'binomial'
)
summary(model)
# Significant differences by age, race, and education, but not gender

# Pseudo R2
DescTools::PseudoR2(model, which = 'McFadden')
# 0.015
# Not a terribly impressive pseudo R2
# but it's definitely MAR and covaries with several other demographics


# Imputation -------------------------

# Using missForest to impute data and create clean dataset
# First convert to all factors or numeric
get_str(demos)
input <- demos %>% 
  select(-missing) %>% 
  mutate(across(c(gender, race, education), as.factor))
get_str(input)

# Run missForest
set.seed(42)
mf_out <- missForest(
  input,
  ntree = 100,
  mtry = 2,
  variablewise = TRUE,
  verbose = TRUE
)
get_str(mf_out)

# Check out imputation error
mf_out$OOBerror
# MSE is 2.044703 

# Pull out clean dataset
clean <- mf_out$ximp
get_str(clean)


# Save ------------------------

# Save as csv for EDA script
write.csv(clean, 'data/clean/df_nhanes_2017_2023_imputed.csv')
