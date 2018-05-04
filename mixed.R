# Load the libraries
library(lme4) # Random Effects
library(emmeans) # lsmeans
library(lmerTest) # Change lmer behaviour


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
# install.packages("lmerTest")
library(lme4)

# The main function of lme4 is called "lmer", which is analogous to "lm" in R, and has very similar syntax
# lmer will take a formula statement and we should use

paper.lmer <- lmer(y~1 + (1|operator), data=paper)

summary(paper.lmer) # Anova table only shows Fixed effects
# Split into two sections, 1 section for random effects and 1 section for Fixed effects
# Variance estimates for random effects, and estimates for fixed effects.

anova(paper.lmer) # What happend? (We have no fixed effects)
anova(paper.lm) # It's the same anova table as if we treated is as "fixed"

# Common accessor functions work
residuals(paper.lmer)
logLik(paper.lmer)
coef(paper.lmer) # slightly different from coef for linear model


# RCBD --------------------------------------------

# Another short example if I treat cage as a random effect.
chick <- read.table("~/Projects/mixed_model_examples/Chick Data R.txt", header = TRUE)

# Change all categorical varaibles to factors
# I forget about this step alot, and it can be frustrating that your results don't make sense.
# CHECK YOUR DEGREE'S OF FREEDOM IN THE ANOVA TABLES!!
chick$cage <- factor(chick$cage)
str(chick)

chick.lmer <- lmer(y~ 1 + diet + (1|cage), data=chick)
summary(chick.lmer)
anova(chick.lmer)

# coef, residuals, logLik will all work on that object

# Get the mean squares from lm, all the F tests should be the same too
chick.lm <- lm(y~ 1 + diet + cage, data=chick)
summary(chick.lm)
anova(chick.lm)

# Plot with confidence intervals.
plot(emmeans(chick.lmer, specs = "diet"))

# Split-Plot with fixed block on WP ----------------------------------------------

# Dataset from discussion 14
steel <- data.frame(y=c(73, 83, 67, 89,
                        65, 87, 86, 91,
                        147, 155, 127, 212,
                        153, 90, 100, 108,
                        150, 140, 121, 142,
                        33, 54, 8, 46),
                    coating=c(2, 3, 1, 4,
                              1, 3, 4, 2,
                              3, 1, 2, 4,
                              4, 3, 2, 1,
                              4, 1, 3, 2,
                              1, 4, 2, 3),
                    temp=c(rep(c("360", "370", "380"), each=4), rep(c("380", "370", "360"), each=4)),
                    day=rep(1:2, each= 12))

# Change all categorical varaibles to factors
cls <- c("day", "coating")
steel[,cls] <- lapply(steel[,cls], factor)
str(steel) # Note the appropriate variables are factors!

# If we pretend everything is fixed, we get the mean squares
steel.lm <- lm(y~day + coating*temp + temp:day, data=steel)
anova(steel.lm)

# Using aov for split plot
# We can use aov to specify one other error, and get an anova table with the appropriate
# denominator for error here. There are limitations though:
# 1. Must be balanced data
# 2. If specifying multiple random effects, they must be NESTED
# Just ignore the warning... I think it has something to do with how the data is coded
steel.aov <- aov(y~day + coating*temp + Error(temp:day), data=steel)
summary(steel.aov) # Match these p-values to the type3 sum anova from SAS, they should match exactly!

# Using lmer
steel.lmer <- lmer(y~day + coating*temp + (1|temp:day), data=steel, REML=TRUE)
REMLcrit(steel.lmer) # The deviance
summary(steel.lmer)
anova(steel.lmer)
# ranova gives the likelihood ratio test for the random effects, we learned about LRT in logistic regression
# but not with random effects. The idea is the same though. Remember, these results are true asymptotically, and will not match
# EXACTLY with the F test.
ranova(steel.lmer)

# Since the coating temp interaction was significant, lets look at factor combinations

# Use emmeans to replicate lsmeans in SAS
# The "spec" option is what you want to get the marginal means over
# If we want factor combinations, coating*temp in SAS, specify another variable in the spec list.
# Specifying specific contrasts are also specified here
# Here we are averaging over the first two means, and the 3rd and 4th means.
(coating.steel.lmer <- emmeans(steel.lmer,
                               spec=c("coating", "temp"), 
                               contr=list("1 and 2 avg vs 3 and 4 avg"=c(-.5, -.5, .5,.5, 0, 0, 0, 0, 0, 0, 0, 0))))

# To replicate the pdiff option in SAS, "pairs" function on the emmeans object will work
# The default is to do some tukey adjustment on the pvalues, if we want the raw values, we need to modify the summary output
(pair.coating.steel.lmer <- pairs(coating.steel.lmer))
summary(pair.steel.lmer, adjust="none")

