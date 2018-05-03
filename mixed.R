# One-Way Random Effect ------------------------------
# We will use the same dataset as we did in discussion 13 for this example:
# We wish to estimate the mean brightness of paper produced in a large factory.

# Manually enter the data
paper <- data.frame(y=c(59.8, 60.0, 60.8, 60.8, 59.8,
                        59.8, 60.2, 60.4, 59.9, 60.0,
                        60.7, 60.7, 60.5, 60.9, 60.3,
                        61.0, 60.8, 60.6, 60.5, 60.5),
                    operator=rep(LETTERS[1:4], each=5))

# Lets treat operator as a fixed effect first, just to familize ourselves with the output and common accessor functions R offers for models
paper.lm <- lm(y~operator, data=paper)

summary(paper.lm) # where is operator A in the output? (intercept. note that the estimates are the *difference* with operator A)
anova(paper.lm) # What's the p-value testing? (all means the same?)
coef(paper.lm)

# You will need lme4 to fit random effects
# install.packages("lme4")
library(lme4)

# The main function of lme4 is called "lmer", which is analogous to "lm" in R, and has very similar syntax
# lmer will take a formula statement and we should use

paper.lmer <- lmer(y~(1|operator), data=paper)

summary(paper.lmer) # Anova table only shows Fixed effects
# Split into two sections, 1 section for random effects and 1 section for Fixed effects
# Variance estimates for random effects, and estimates for fixed effects.

anova(paper.lmer) # What happend? (We have no fixed effects)
anova(paper.lm) # It's the same anova table as if we treated is as "fixed"

# Common accessor functions work
residuals(paper.lmer)
coef(paper.lmer) # slightly different from coef for linear model


# RCBD ------------------------------

chick <- read.table("~/Projects/mixed_model_examples/Chick Data R.txt", header = TRUE)
chick$cage <- factor(chick$cage)
str(chick)

chick.lmer <- lmer(y~ 1 + diet + (1|cage), data=chick)
summary(chick.lmer)
anova(chick.lmer)

