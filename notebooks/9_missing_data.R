# Housekeeping -------------------------

if (!require('pacman')) install.packages('pacman')
pacman::p_load(
  dplyr,
  purrr,
  naniar,
  ggplot2,
  skimr,
  ggpubr,
  stringr,
  lmtest,
  forcats,
  pscl,
  tictoc,
  missRanger
)
pacman::p_load_gh('ChrisDonovan307/projecter')
clean <- read.csv('data/clean/nhanes_2017_2023_clean.csv')
get_str(clean)

# For now we don't care about missing in prop_pbp
# That is a separate issue. Let's remove it
# Also ditch income quartiles, same missingness as og income
full <- select(clean, -any_of(c(
  'prop_pbp',
  'oz_pbp',
  'pf_total_calc',
  'SEQN',
  'weight_2d',
  'grams'
)))

# Turn demos into factors
full <- full %>%
    mutate(
        race = factor(race),
        education = factor(education),
        education = fct_relevel(
            education,
            'Less than 9th grade',
            '9th to 11th grade',
            'High school/GED',
            'Some college or AA',
            'College graduate or above'
        ),
        gender = factor(gender),
        income_ratio_qs = factor(income_ratio_qs),
        income_ratio_qs = fct_relevel(
            income_ratio_qs,
            'Lowest',
            'Low',
            'Medium',
            'High',
            'Highest'
        )
    )
get_str(full)



# Visualize ---------------------------------------------------------------


# Get total missing from full dataset
mean(is.na(select(full, -income_ratio_qs))) * 100
# 4.2496% missing overall

# Not missing anything from fped variables
# Let's narrow down to just demos and biomarkers
dat <- select(full, gender:last_col())
get_str(dat)

# vis_miss <- vis_miss(
#     select(dat, -income_ratio_qs),
#     warn_large_data = FALSE,
#     cluster = TRUE,
#     show_perc = TRUE
# )
# vis_miss +
#   theme(
#     plot.margin = margin(0, 50, 0, 0),
#     panel.grid.major = element_blank(),
#     panel.grid.minor = element_blank()
#   )
# # Some income missing, and lots of biomarkers.
#
# # Let's save it
# ggsave(
#   'outputs/checkin_3/vis_miss.png',
#   width = 6,
#   height = 6,
#   units = 'in',
#   bg = 'white'
# )

# Check by variable
miss_var_summary(dat)
gg_miss_var(dat, show_pct = TRUE)
# serum ferritin is 43%. All biomarkers missing > 10%

# Save it
ggsave(
  'outputs/checkin_3/gg_miss_var.png',
  width = 4,
  height = 5,
  units = 'in',
  bg = 'white'
)

# Explore missing data by demographics
no_qs <- select(dat, -income_ratio_qs)
demos <- c('race', 'education', 'age', 'gender')
gg_miss_fcts <- list()

# Map over them to plot at once
plots <- map(demos, ~ {
  gg_miss_fct(no_qs, !!sym(.x))
}) %>%
  setNames(c(demos))

# Add hinky one
plots$income <- gg_miss_fct(select(dat, -income_ratio), income_ratio_qs)
plots

# Save all of them
iwalk(plots, ~ {
  ggsave(
    filename = paste0('outputs/checkin_3/gg_miss_fct_', .y, '.png'),
    plot = .x,
    width = 5,
    height = 6,
    units = 'in',
    bg = 'white'
  )
})



# Nature of Missingness -------------------------


# Test for MCAR
mcar_test(dat)
# Null hypothesis is MCAR. Significant result suggests not MCAR

# For each variable with any missing, make a var that is its missingness as a
# binary, then run logistic regression to test for MAR
indices <- map_lgl(names(dat), ~ {
  any(is.na(dat[[.x]]))
})
miss_vars <- names(dat)[indices]

# Make all models
models <- map(miss_vars, ~ {
  df <- dat %>%
    mutate(missing = ifelse(is.na(!!sym(.x)), 1, 0))
  if (.x == 'income_ratio') {
    model <- glm(
      missing ~ age + gender + race + education,
      data = df,
      family = 'binomial'
    )
  } else {
    model <- glm(
      missing ~ age + gender + race + education + income_ratio,
      data = df,
      family = 'binomial'
    )
  }
  return(model)
}) %>%
  setNames(c(miss_vars))
get_str(models)

# Check summaries
map(models, summary)
# Every model has significant predictors

# Get psuedo R2 for each model
pR2s <- map_dbl(models, ~ pR2(.x)[['McFadden']])
pR2s
range(pR2s)
# pseudo R2 ranges from 0.01575 to 0.4876



# Imputation --------------------------------------------------------------


# Using missForest to impute data and create clean dataset
# Can use FPED variables to help predict
get_str(clean)
get_str(dat)

input <- clean %>%
  select(
    f_total_.cup_eq.:income_ratio,
    blood_mercury,
    avg_systolic_bp,
    avg_diastolic_bp
  )
get_str(input)

# Miss ranger imputation
out <- missRanger(
  input,
  pmm.k = 5,
  num.trees = 100,
  seed = 42,
  keep_forests = TRUE,
  verbose = 1
)
summary(out)

# Check errors
out$mean_pred_errors

# Best errors
out$pred_errors[2, ]



# Wrangle -----------------------------------------------------------------


# Combine back with clean
get_str(clean)
get_str(out$data)

# Just need SEQN, weight, FPED, and 4 biomarkers
df <- clean %>%
  select(
    SEQN,
    weight_2d
  )
get_str(df)

# Combine
df <- bind_cols(df, out$data)
get_str(df)

# Get parenthesis back in
names(df) <- names(df) %>%
  str_replace('\\.', '\\(') %>%
  str_replace('eq\\.', 'eq\\)') %>%
  str_replace('drinks\\.', 'drinks\\)') %>%
  str_replace('grams\\.', 'grams\\)')
names(df)



# Save --------------------------------------------------------------------


# Save as csv for EDA script
write.csv(df, 'data/clean/nhanes_2017_2023_imputed.csv')
