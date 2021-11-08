# Lab 9: 

<!-- NOTE: 
You can preview this README.md document by clicking the 'Preview' button in the RStudio toolbar. 
-->

## Preparation

- Read/ annotate: [Recipe \#9](https://lin380.github.io/tadr/articles/recipe_9.html). You can refer back to this document to help you at any point during this lab activity.
- Note: do your best to employ what you've learned and use other existing resources (R documentation, web searches, etc.).

## Objectives

- Gain experience working with coding strategies to prepare, assess, interrogate, evaluate, and report results from an inferential data analysis.
- Practice transforming datasets and visualizing relationships
- Implement organizational strategies for organizing and reporting results in a reproducible fashion.

## Instructions

In this lab we will be working with the `sdac_transformed` dataset that we've seen earlier. This dataset is based on the [Switchboard Dialogue Act Corpus](https://catalog.ldc.upenn.edu/LDC97S62). We seen the process to curate and transform this dataset in previous chapters and recipes. An important feature of this dataset is the fact that it includes utterance-level discourse annotation. The convention used to annotate each utterance is called DAMSL which stands for Dialogue Act Markup using Several Layers (DAMSL). Here is the [annotation documentation for the Switchboard Dialogue Act Corpus](https://web.stanford.edu/~jurafsky/ws97/manual.august1.html) for reference.

The aim of this lab will be use the transformed dataset to analyze a particular alternative hypothesis: 

$H_1$: Women use more hedges than men. 

Then, the null hypothesis is: 

$H_0$: Women do not use more hedges than men.


Background information for the analysis: 

Lakoff (1973) argues that women express themselves tentatively without warrant or justification more often than men. This suggestion would predict that women will use more hedges than men. What is a hedge? A hedge is used to diminish the confidence or certainty with which the speaker makes a statement or answers a question.

Examples of hedges: 

(1) General example: 

- *I don't know if I'm making any sense or not.*


(2) In context from the Switchboard Dialogue Act Corpus:

- You might try,                                           
- *I don't know,*                                                  
- hold it down a little longer,

In the Switchboard Dialogue Act Corpus hedges are marked in the DAMSL tag annotation as `h` (hedge), `h^r` (repeated hedge), or `h^t` (hedge when talking about the task). 

With our theoretical aim in mind we will want to prepare, assess, interrogate, evaluate, and report results from this analysis.

### Setup

1. Create a new R Markdown document. Title it "Lab 9" and provide add your name as the author. 
2. Edit the front matter to have rendered R Markdown documents as you see fit (table of contents, numbered sections, etc.)
3. Delete all the material below the front matter.
4. Add a code chunk directly below the header named 'setup' and add the code to load the following packages and any others you end up using in this lab report. Add `message=FALSE` to this code chunk to suppress messages. 
  - tidyverse
  - knitr
  - skimr
  - patchwork
  - effectsize
  - report
  - also include `source()` to source the `functions/functions.R` file. This will import the `print_pretty_table()` function.

*NOTE* Please pay attention to the formatting of your R Markdown output --particular in terms of the code chunk options (`echo = FALSE`, `message = FALSE`, etc.). Also use the `print_pretty_table()` function for all of your table outputs. Include the following two arguments. 

```r
dataset %>% # dataset
  print_pretty_table(caption = "<your caption here>") # pretty table with caption
```

### Tasks

1. Create two level-1 header sections named: "Overview" and "Tasks". 
2. Under "Tasks" create six level-2 header sections named: "Orientation", "Preparation", "Descriptive assessment", "Statistical interrogation", "Evaluation" and "Reporting".
3. Follow the instructions that follow adding the relevant prose description and code chunks to the corresponding sections.
  - **Make sure to provide descriptions of your steps between code chunks and code comments within the code chunks!**

#### Orientation

- Read the `sdac_transformed.csv` into an object called `sdac` and `sdac_transformed_data_dictionary.csv` as an object called `sdac_data_dictionary`. 
  - Preview the data structure of `sdac` and provide prose description of the dataset.
  - Print a table of the `sdac_data_dictionary` (use `print_pretty_table()`) and provide prose description of the data dictionary.

*Note: we will include the variable `age` in our analysis as a control factor to ensure that we account for any variability due to the age of the speakers.*

#### Preparation

- Modify the `sdac` dataset and create a new object `sdac_hedges`. This object will create a new column `hedges` that is the result of counting all utterances in which hedges occur. You will use `mutate()` to create the new column and the `str_count()` function to match hedges. To help you out the regular expression to match all hedges will be `^h(\\^r|\\^t)?`. 
- Sum and normalize the number of hedges used by each speaker. To do this you will group the variables `speaker_id`, `sex`, and `age` and then use `summarize()` to create a variable `hedges_per_utt`. To sum and normalize the hedges, use `(sum(hedges)/ n()) * 1000` inside the `summarize()` function. 
- Preview the new `sdac_hedges` dataset using the `print_pretty_table()` function. 
- Note that speaker 155 has incomplete `sex` and `age` information. Remove this observation by using `filter()` and overwrite `sdac_hedges` with the result. Our dataset will contain one less speaker now.
- Finally, convert the variables `sex` and `age` to factors using `mutate()` and `factor()`. 
  - Preview the structure of the dataset `sdac_hedges`

#### Descriptive assessment

- Use `skim()` to look at the categorical variable `sex` (deselect the variable `speaker_id` as it is of no interest to our assessment). 
  - Pull out only the factor-oriented information with `yank("factor")`.
  - Provide a prose description of the numeric results.
- Use the following custom skim function to look at the numeric variables `age` and `hedges_per_utt`. 
  - `num_skim <- skim_with(numeric = sfl(iqr = IQR)) # add IQR to skim`
  - Pull out only the numeric-oriented information with `yank("numeric")`.
  - Provide a prose description of the numeric results.
- Explore the distribution of the dependent variable `hedges_per_utt` by creating a histogram and a density plot. Combine them in the plotting space by assigning each plot to a variable (i.e. `p1` and `p2`) and then use the `+` operator to display them both inline in the R Markdown output.
  - Provide a prose description of the visual results.
- As you will see, the distribution is right-skewed. But since `hedges_per_utt` is not discrete (not whole numbers) and can take a range of values (floating points, i.e. decimal places), let's explore a transformation of this variable known as the 'log transformation'. Create another density plot, but wrap the `hedges_per_utt` variable with the function `log()`. 
  - Describe how the distribution has changed.
- (Optional) You may also want to create a QQ-Plot to see the distribution of `hedges_per_utt` compared to the theoretical normal distribution.
  - Describe the degree that the distribution visually conforms to the normal distribution.
- Create a new variable in our dataset called `hedges_per_utt_log` that applies a log transformation to `hedges_per_utt`. Note that you will use the function `log()` to create this variable, but you will need to add one to all observations to avoid undefined values when `log(0)`. 
- Perform the Shapiro-Wilk Test of Normality on the new `hedges_per_utt_log` variable to verify whether it conforms to the normal distribution. 
  - Hint: it will not, but we can visually see that the log transformation helps the distribution so we will proceed with the `hedges_per_utt_log` as our dependent variable.
- Create a numeric summary looking at the relationship between the variables we are going to add to our statistical model. Let's group our summaries by the categorical variable `sex` and use `num_skim()` and `yank("numeric")`. 
  - Provide a prose description of the numeric results.
- Create a scatter plot with the mappings `x = age`, y = `hedges_per_utt_log`, and `color = sex`. The `geom_point()` function will create the points and the `geom_smooth()` will create the trend line and confidence interval ribbons. Inside the `geom_smooth()` add `method = "lm"` to create a linear trend line.
  - Provide a prose description of the visual results.

#### Statistical interrogation

- Conduct an Ordinary Least Squares Regression with the `lm()` function. Assign the result to `m1`.
  - The formula will be `hedges_per_utt_log ~ age + sex`. 
  - Return a summary of the results by running `summary()` on the `m1` object.
  - Provide a description of the results, focusing on the 'Coefficients' for our model variables. Remember that `age` is a control variable in this model!

#### Evaluation

- Calculate the effect size and confidence intervals for our model predictors (independent and control variables) by using the `effectsize()` function. Assign the result to `effects`. 
  - Preview the results of `effects`.
- Evaluate the effect size of our only significant predictor (`age`) by using the `interpret_r()` function on the correct value from the `effects` object (i.e. `effects$Std_Coefficient[2]`). 
  - Provide a prose description of the findings from our evaluation.


#### Reporting

- Create the boilerplate text from our findings using the `report_text()` function on the statistical model `m1`
- Create a table of the model results using the `report_table()` function on the statistical model `m1`

#### Overview

Now that you have conducted the steps to analyze the dataset, provide a prose overview of what the goals of this script are and resulting findings are at the beginning of your script in the 'Overview' section.

### Assessment

Add a level-1 section which describes your learning in this lab.

Some questions to consider: 

  - What did you learn?
  - What was most/ least challenging?
  - What resources did you consult? 
  - What more would you like to know about?

## Submission

1. To prepare your lab report for submission on Canvas you will need to Knit your R Markdown document to PDF or Word.
  - Note since the analysis contains some special characters, you will need to change the latex engine if you knit this document to a PDF file. To do this use the RStudio shortcut button to the 'Output options...' and select format output 'PDF', then select 'Advanced' and choose 'xelatex' as the latex engine.
2. Download this file to your computer.
3. Go to the Canvas submission page for Lab #9 and submit your PDF/Word document as a 'File Upload'. Add any comments you would like to pass on to me about the lab in the 'Comments...' box in Canvas.


## References

Holmes, J. (1990). Hedges and boosters in women’s and men’s speech. Language & Communication, 10(3), 185–205. https://doi.org/10.1016/0271-5309(90)90002-S

Lakoff, R. (1973). Language and Woman’s Place. Language in Society, 2(1), 45–80.

