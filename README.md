# Examples of Mixed Models in R

This repository contains simple examples of fitting random effect models in R. I assume basic familiarity with R, and mixed effect models. This mainly focuses on the tools. These examples were shown in class in SAS. The `mixed.R` file aims to replicate many of the SAS results. I included 3 examples:

* One-Way Random Effect CRD
* RCBD with random block
* Split-Plot design with RCBD on whole plots

# Libraries for R

#### lme4

This is how to fit random models in R, it offers a function called `lmer` which functions very similarly to `lm` in base R.

#### lmerTest

This will modify the behavior of R, so that the anova function returns p-values. lme4 by default does not return "p-values" and the reason for this is well documented. After installing the package, you can read about this by running `help("pvalues")`

#### emmeans

This replicates a lot of the functionality of the `lsmeans` statement, i.e. comparisons of marginal means between different groups.

# Other Resources

This example should give you a good start. If you need more detail in one particula area, here are some places to start.

* [Vignettes for emmeans](https://cran.r-project.org/web/packages/emmeans/vignettes/) - I suggest starting with "basics" and "comparisons". These are basically mini tutorials that give you an overview of the packages
* [Bodo Winter Tutorial](http://www.bodowinter.com/tutorial/bw_LME_tutorial.pdf) - Great conceptual intro to mixed effects
* [The definitive overview of lme4](https://cran.r-project.org/web/packages/lme4/vignettes/lmer.pdf) - details of the package and a high level overview. Can be somewhat technical, but the first few sections are worth reading when first starting
* [Lecture Notes from Professor Ané](http://www.stat.wisc.edu/~ane/st572/notes/index.html) - previous course notes have some great R examples

