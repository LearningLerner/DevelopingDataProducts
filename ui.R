library(shiny)
#
shinyUI(fluidPage(
  titlePanel("Knowing MPG by Groups"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("group", "Group by:",
                   c("Transmission"="am",
                     "Cylinders"="cyl",
                     "Gear"="gear",
                     "Carburator"="carb"))
    ),
    mainPanel(
      h1("Analysing Variance by Groups"),
      p("This shiny app aims to show visual and analytically 
        the relationship between the dependent variable mpg and 
        some factor variables of mtcars data set."),
      p("The variable mpg stands for Mile Per Galon and is a measurement of
        the performance of the vehicle. The factor variables considered in this app are
        Transmission (0 = automatic, 1 = manual), Cylinders, Gear (number of forward gears) and
        Carburator. The boxplot depicts the distribution of the variable mpg along the levels 
        of each factor considered. It's useful to explory the distance of the central values in
        each group and the data dispersion in each one. The table, in turn, quantifies the difference between groups 
        for each factor and uses the F-statistic to assess the relevance of the variable to explain
        the variability found in the data. The significance is expressed in the p-value of the metric for
        the respective degrees of freedom. It's possible to see that Cylinder has the most significative impact
        in explaining the variance found in the data set."),
      p("To use this shiny app, it's only necessry to choose the factor variable by clicking on the radio button on left.
        The mpg variable is, then, distributed accordingly in groups corresponding to each level of the explanatory variable"),

      plotOutput("mainPlot"),
      tableOutput("tbl")
    )
  )
))
