install.packages("plan")
library(plan)

# Read the CSV file
phd_timeline <- read.gantt("phd_timeline.csv")

# Create the Gantt chart
plot(phd_timeline, event.label = 'Submission', event.time = '2027-10-01',
     col.event = c("red"),
     col.notdone = c("lightblue"),
     cex.main = 2,  # Increase the size of the title
     xlab = "Date"
)