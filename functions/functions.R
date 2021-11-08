
# Functions --------------------------------------------------------------------

data_dic_starter <- function(data, file_path) {
  # Function:
  # Creates a .csv file with the basic information
  # to document a curated dataset

  tibble(variable_name = names(data), # column with existing variable names
         name = "", # column for human-readable names
         description = "") %>% # column for prose description
    write_csv(file = file_path) # write to disk
}

print_pretty_table <- function(data, caption, n = 10) {
  # Function
  # Print data frames as pretty tables with captions

  data %>% # dataset
    slice_head(n = n) %>% # first n observations
    knitr::kable(booktabs = TRUE, # bold headers
                 caption = caption) # caption
}
