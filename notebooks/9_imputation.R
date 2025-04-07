# Housekeeping ------------------------- 

if (!require('pacman')) install.packages('pacman')
pacman::p_load(
  dplyr,
  purrr,
  naniar,
  ggplot2,
  skimr,
  missForest,
  ggpubr,
  stringr,
  lmtest
)
pacman::p_load_gh('ChrisDonovan307/projecter')
dat <- read.csv('data/clean/nhanes_2017_2023_clean.csv')
get_str(dat)

# For now we don't care about missing in prop_pbp
# That is a separate issue. Let's remove it
dat <- select(dat, -prop_pbp)


# Visualize Missing Data -------------------------

# Visualize across all columns
vis_miss(dat, warn_large_data = FALSE)
# Only income is missing data

# Check how much missing data there is total
mis <- mean(is.na(dat)) * 100
cat("\nMissing", round(mis, 3), "% of all data")

# Check for just income ratio
mis_income <- mean(is.na(dat$income_ratio)) * 100
cat("\nMissing", round(mis_income, 3), "% of income data")

# Reduce to demos only
demos <- dat %>% 
    select(
        age, 
        gender, 
        race, 
        education, 
        income_ratio,
        weight_2d
    )
get_str(demos)

# Look at it by race and education
gg_miss_fct(demos, race)
gg_miss_fct(demos, education)
# Seems to vary by both

# Just make a regular ggplot to show by race and education
demos$missing <- ifelse(is.na(demos$income_ratio), 1, 0)
demos$weighted_missing <- demos$missing * demos$weight_2d
get_str(demos)

# Get plots for race and education
plots <- map(c('race', 'education'), \(demo) {
    demos %>% 
        group_by(!!sym(demo)) %>% 
        summarize(mis_prop = sum(weighted_missing) / sum(weight_2d)) %>% 
        ggplot(aes(x = !!sym(demo), y = mis_prop)) +
        geom_col(
            fill = 'lightblue',
            color = 'black'
        ) + 
        theme_classic() +
        labs(
            x = str_to_title(demo),
            y = 'Proportion Missing Income'
        ) +
        scale_y_continuous(limits = c(0, 0.22)) + 
        theme(axis.text.x = element_text(angle = 45, hjust = 1))
})

# Save plots
plot <- ggarrange(
    plotlist = plots,
    ncol = 2,
    nrow = 1,
    align = 'hv',
    labels = c('A', 'B')
)
plot

ggsave(
    'outputs/checkin_2/missing_income.png',
    plot = plot,
    width = 7,
    height = 5,
    units = 'in'
)


# Nature of Missingness -------------------------

mcar_test(demos)
cat(
    '\nMCAR test:\nStatistic:', mcar_test(demos)$statistic, 
    "\np-value:", mcar_test(demos)$p.value
)
# Null hypothesis is MCAR. Significant result suggests not MCAR

# Use a logistic regression to test for MAR
model <- glm(
  missing ~ age + gender + race + education,
  data = demos,
  family = 'binomial'
)
summary(model)
coeftest(model)
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
write.csv(clean, 'data/clean/nhanes_2017_2023_imputed.csv')
