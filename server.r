library(shiny)
library(datasets)

data("mtcars")


shinyServer(
  function(input, output) {
    
    output$mainPlot <- renderPlot({
      with(mtcars,
           boxplot(mpg ~ get(input$group), 
                   main="MPG by selected group",
                   ylab="MPG", xlab={input$group}))
    })
    
    group_SSE <- function(x){
      mu <- mean(x)
      return(sum((x-mu)^2))
    }
    
    output$SSETotal <- renderPrint({
      mu <- mean(mtcars$mpg)
      SSETotal <- sum((mtcars$mpg-mu)^2)
      return(round(SSETotal, 2))
    })
        
    output$tbl <- renderTable({
      mtrx <- matrix(nrow=3, ncol=5)
      
      group <- {input$group}
      mu_mpg <- mean(mtcars$mpg)
      mu_groups <- with(mtcars, sapply(split(mpg, get(group)), mean))
      
      n_groups <-  with(mtcars, sapply(split(mpg, get(group)), length))
      
      SSETotal <- sum((mtcars$mpg-mu_mpg)^2)
      SSEG <- sum(((mu_groups-mu_mpg)^2)*n_groups)
      SSER <- sum(with(mtcars, sapply(split(mpg, get(group)), group_SSE)))
      
      n <- dim(mtcars)[1]
      k_groups <- length(mu_groups)
      dfGroups <- k_groups-1
      dfResiduals <- n - k_groups
      dfTotal <- n-1
      
      mtrx[1,1] <- SSEG
      mtrx[2,1] <- SSER
      mtrx[3,1] <- SSETotal
      
      mtrx[1,2] <- dfGroups
      mtrx[2,2] <- dfResiduals
      mtrx[3,2] <- dfTotal
      
      MSEGroups <- SSEG/dfGroups
      MSEResiduals <- SSER/dfResiduals
      
      mtrx[1,2] <- dfGroups
      mtrx[2,2] <- dfResiduals
      
      mtrx[1,3] <- MSEGroups
      mtrx[2,3] <- MSEResiduals
      
      F_statistic <- MSEGroups/MSEResiduals
      mtrx[1,4] <- F_statistic
      
      p_value <- pf(F_statistic, df1 = dfGroups, df2 = dfResiduals, lower.tail = FALSE)
      mtrx[1,5] <- p_value
      
      df <- as.data.frame(mtrx)
      names(df) <- c("SumOfSquaredErrors", "DF", "MSE", "F", "p")
      rownames(df) <- c("Groups", "Residuals","Total")
      df$DF <- as.integer(df$DF)
      df$p[1] <- format(round(df$p[1], 6), nsmall=6)
      
      return(df)
    })
    
    
  }
)