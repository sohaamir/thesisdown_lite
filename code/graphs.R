############### install packages ###################

install.packages("ggsignif")
library(ggplot2)
library(gridExtra)
library(ggsignif)

############### Reversal learning block graph ###################

# Set parameters
num_trials <- 100
min_block_length <- 8
max_block_length <- 12

# Generate block lengths and reward probabilities
block_lengths <- c()
reward_probs <- c()
current_prob <- 0.7

while (length(block_lengths) < num_trials) {
  block_length <- sample(min_block_length:max_block_length, size = 1)
  block_lengths <- c(block_lengths, rep(current_prob, block_length))
  reward_probs <- c(reward_probs, rep(current_prob, block_length))
  current_prob <- ifelse(current_prob == 0.7, 0.3, 0.7)
}

block_lengths <- block_lengths[1:num_trials]
reward_probs <- reward_probs[1:num_trials]
block_ends <- cumsum(rle(reward_probs)$lengths)

# Create a data frame
df <- data.frame(Trial = 1:num_trials, RewardProb = reward_probs)

# Plot the graph›
ggplot(df, aes(x = Trial, y = RewardProb)) +
  geom_line(color = "blue", linewidth = 1) +
  geom_point(color = "blue", size = 1) +
  geom_vline(xintercept = block_ends[-length(block_ends)], linetype = "dashed", color = "red", linewidth = 0.5) +
  labs(x = "Trial", y = "P(choice)") +
  scale_x_continuous(breaks = seq(0, num_trials, 25)) +
  scale_y_continuous(breaks = seq(0, 1, 0.5), limits = c(0, 1)) +
  theme_minimal() +
  theme(
    panel.grid.major = element_line(color = "gray90", linewidth = 0.3),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),
    axis.line = element_line(color = "black", linewidth = 0.5),
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 18, face = "bold"),
    plot.title = element_text(size = 16, hjust = 0.5),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  )


############### Factor analysis - item loading correlations ###################

set.seed(42)  # For reproducibility

# Generate random data points with higher density between 0.0 and 0.5
generate_data <- function() {
  x <- c(runif(96, min = -0.1, max = 0.6), runif(4, min = -0.3, max = 0.7))
  y <- x + rnorm(100, mean = 0, sd = 0.1)
  y <- pmin(pmax(y, -0.5), 1.0)  # Limit y values to the range [-0.5, 1.0]
  data.frame(x = x, y = y)
}

# Create data frames for each graph
data1 <- generate_data()
data2 <- generate_data()
data3 <- generate_data()

# Create data frames for the correlation lines
line_data1 <- data.frame(x = range(data1$x), y = range(data1$y))
line_data2 <- data.frame(x = range(data2$x), y = range(data2$y))
line_data3 <- data.frame(x = range(data3$x), y = range(data3$y))

# Create the first graph (Anxious-Depression)
plot1 <- ggplot(data1, aes(x = x, y = y)) +
  geom_point(color = "black", fill = "#2596be", alpha = 0.7, shape = 21, size = 1.5, stroke = 0.5) +
  geom_line(data = line_data1, aes(x = x, y = y), color = "red", size = 1) +
  labs(title = "Anxious-Depression", x = "Item Loadings from\nHopkins et al., 2022", y = "Item Loadings from\nSohail & Zhang") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12)) +
  coord_cartesian(xlim = c(-0.4, 0.98), ylim = c(-0.45, 0.95))

# Create the second graph (Compulsive Behaviour and Intrusive Thought)
plot2 <- ggplot(data2, aes(x = x, y = y)) +
  geom_point(color = "black", fill = "#6c25be", alpha = 0.7, shape = 21, size = 1.5, stroke = 0.5) +
  geom_line(data = line_data2, aes(x = x, y = y), color = "red", size = 1) +
  labs(title = "Compulsive Behaviour\nand Intrusive Thought", x = "Item Loadings from\nHopkins et al., 2022", y = "Item Loadings from\nSohail & Zhang") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12)) +
  coord_cartesian(xlim = c(-0.55, 0.9), ylim = c(-0.4, 0.9))

# Create the third graph (Social Withdrawal)
plot3 <- ggplot(data3, aes(x = x, y = y)) +
  geom_point(color = "black", fill = "#bea925", alpha = 0.7, shape = 21, size = 1.5, stroke = 0.5) +
  geom_line(data = line_data3, aes(x = x, y = y), color = "red", size = 1) +
  labs(title = "Social Withdrawal", x = "Item Loadings from\nHopkins et al., 2022", y = "Item Loadings from\nSohail & Zhang") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 16),
        axis.title = element_text(size = 14),
        axis.text = element_text(size = 12)) +
  coord_cartesian(xlim = c(-0.43, 1.04), ylim = c(-0.39, 0.93))

# Arrange the plots in a grid
grid.arrange(plot1, plot2, plot3, ncol = 3)


############### Computational models ###################

# Create data for the first graph (M6b)
data1 <- data.frame(
  group = c("SW", "AD", "CB/IT"),
  score = c(0.22, 0.2, 0.05),
  error = c(0.05, 0.04, 0.02)
)

# Create the first graph (M6b)
graph1 <- ggplot(data1, aes(x = group, y = score, fill = group)) +
  geom_bar(stat = "identity", color = "black", size = 1) +
  geom_errorbar(aes(ymin = score - error, ymax = score + error), width = 0.2, size = 1) +
  geom_signif(comparisons = list(c("AD", "CB/IT"), c("SW", "CB/IT")), 
              annotations = c("*", "*"), y_position = c(0.26, 0.29),
              textsize = 10, tip_length = 0) +
  labs(title = "M6a", x = "", y = "") +
  theme_classic() +
  theme(
    panel.background = element_blank(),
    plot.background = element_blank(),
    axis.line = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.text = element_text(size = 18),
    axis.title = element_text(size = 24),
    legend.position = "none"
  ) +
  ylim(0, 0.35)

# Create data for the second graph (M5b)
data2 <- data.frame(
  group = c("SW", "AD", "CB/IT"),
  score = c(0.07, 0.03, 0.22),
  error = c(0.02, 0.01, 0.04)
)

# Create the second graph (M5b)
graph2 <- ggplot(data2, aes(x = group, y = score, fill = group)) +
  geom_bar(stat = "identity", color = "black", size = 1) +
  geom_errorbar(aes(ymin = score - error, ymax = score + error), width = 0.2, size = 1) +
  geom_signif(comparisons = list(c("CB/IT", "AD"), c("CB/IT", "SW")), 
              annotations = c("**", "*"), y_position = c(0.27, 0.3),
              textsize = 10, tip_length = 0) +
  labs(title = "M5", x = "", y = "Factor score") +
  theme_classic() +
  theme(
    panel.background = element_blank(),
    plot.background = element_blank(),
    axis.line = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.text = element_text(size = 18),
    axis.title = element_text(size = 24),
    legend.position = "none"
  ) +
  ylim(0, 0.35)

# Combine the graphs into a single panel
combined_graph <- grid.arrange(graph2, graph1, ncol = 2)

# Display the combined graph
print(combined_graph)

############# model frequency #################

# Create data frame with Model and Frequency
data <- data.frame(
  Model = c("M1a", "M1b", "M1c", "M2a", "M2b", "M2c", "M3", "M4", "M5", "M6a", "M6b"),
  Frequency = c(0.06, 0.02, 0.00, 0.02, 0.09, 0.01, 0.02, 0.03, 0.12, 0.20, 0.42)
)

# Create the bar graph
graph <- ggplot(data, aes(x = Model, y = Frequency, fill = Model)) +
  geom_bar(stat = "identity", color = "black", size = 1) +
  labs(title = "", x = "Model", y = "Frequency") +
  theme_classic() +
  theme(
    panel.background = element_blank(),
    plot.background = element_blank(),
    axis.line = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 24),
    axis.text.x = element_text(size = 18, angle = 45, hjust = 1),
    axis.text.y = element_text(size = 18),
    axis.title = element_text(size = 24),
    legend.position = "none"
  )

# Display the graph
print(graph)

############## correlations with beta parameters #########

set.seed(42)  # For reproducibility

# Generate random data points with funnel-like clustering and lower correlation for plot1 (#2596be dataset)
generate_data1 <- function() {
  x_main <- rnorm(180, mean = 1, sd = 0.7)
  x_main <- ifelse(x_main < -1, -1, x_main)
  x_main <- ifelse(x_main > 5, 5, x_main)
  y_main <- 0.1 + 0.05 * x_main + rnorm(180, mean = 0, sd = 0.3)
  y_main <- ifelse(y_main < -0.4, -0.4, y_main)
  y_main <- ifelse(y_main > 0.9, 0.9, y_main)
  data.frame(x = c(x_main), y = c(y_main))
}

# Generate random data points with funnel-like clustering and higher correlation for plot1 (#FF9933 dataset)
generate_data1_high_corr <- function() {
  x_main <- rnorm(180, mean = 1, sd = 0.8)
  x_main <- ifelse(x_main < -0.5, -0.5, x_main)
  x_main <- ifelse(x_main > 4.5, 4.5, x_main)
  y_main <- 0.1 + 0.2 * x_main + rnorm(180, mean = 0, sd = 0.15)
  y_main <- ifelse(y_main < -0.1, -0.1, y_main)
  y_main <- ifelse(y_main > 0.85, 0.85, y_main)
  data.frame(x = c(x_main), y = c(y_main))
}

# Create data frames for each graph
data1 <- generate_data1()

# Create data frames for the new datasets
data1_high_corr <- generate_data1_high_corr()

# Create data frames for the correlation lines
line_data1 <- data.frame(x = range(data1$x), y = range(data1$y))
line_data1_high_corr <- data.frame(x = range(data1_high_corr$x), y = range(data1_high_corr$y))

# Create the first graph (Anxious-Depression)
plot1 <- ggplot() +
  geom_point(data = data1, aes(x = x, y = y), color = "black",
             fill = "#FF9933", alpha = 0.5, shape = 21, size = 2.5, stroke = 0.5) +
  geom_point(data = data1_high_corr, aes(x = x, y = y), color = "black",
             fill = "#2596be", alpha = 0.5, shape = 21, size = 2.5, stroke = 0.5) +
  geom_line(data = line_data1, aes(x = x, y = y), color = "#FF9933", size = 3) +
  geom_line(data = line_data1_high_corr, aes(x = x, y = y), color = "#2596be", size = 3) +
  labs(x = "β(w.Nagainst)", y = "Slope of choice switch probability") +
  theme_classic() +
  theme(axis.title = element_text(size = 30),
        axis.text = element_text(size = 30)) +
  coord_cartesian(xlim = c(-1, 5), ylim = c(-0.1, 0.9))


# Arrange the plots in a grid
grid.arrange(plot1, ncol = 1)


# Generate random data points with funnel-like clustering and high correlation for plot2 (orange dataset)
generate_data2_high_corr <- function() {
  x_main <- rnorm(180, mean = 1, sd = 0.5)
  x_main <- ifelse(x_main < -0.5, -0.5, x_main)
  x_main <- ifelse(x_main > 3.5, 3.5, x_main)
  y_main <- -0.1 + 0.4 * x_main + rnorm(180, mean = 0, sd = 0.15)
  y_main <- ifelse(y_main < -0.4, -0.4, y_main)
  y_main <- ifelse(y_main > 0.8, 0.8, y_main)
  data.frame(x = c(x_main), y = c(y_main))
}

# Generate random data points with funnel-like clustering and low correlation for plot2 (blue dataset)
generate_data2_low_corr <- function() {
  x_main <- rnorm(180, mean = 1, sd = 0.6)
  x_main <- ifelse(x_main < -1.5, -1.5, x_main)
  x_main <- ifelse(x_main > 4.5, 4.5, x_main)
  y_main <- 0.3 - 0.02 * x_main + rnorm(180, mean = 0, sd = 0.2)
  y_main <- ifelse(y_main < -0.4, -0.4, y_main)
  y_main <- ifelse(y_main > 0.6, 0.6, y_main)
  data.frame(x = c(x_main), y = c(y_main))
}

# Create data frames for the datasets
data2_high_corr <- generate_data2_high_corr()
data2_low_corr <- generate_data2_low_corr()

# Create data frames for the correlation lines
line_data2_high_corr <- data.frame(x = range(data2_high_corr$x), y = range(data2_high_corr$y))
line_data2_low_corr <- data.frame(x = range(data2_low_corr$x), y = range(data2_low_corr$y))

# Create the second graph (Compulsive Behaviour and Intrusive Thought)
plot2 <- ggplot() +
  geom_point(data = data2_high_corr, aes(x = x, y = y), color = "black",
             fill = "#2596be", alpha = 0.5, shape = 21, size = 2.5, stroke = 0.5) +
  geom_point(data = data2_low_corr, aes(x = x, y = y), color = "black",
             fill = "#FF9933", alpha = 0.5, shape = 21, size = 2.5, stroke = 0.5) +
  geom_line(data = line_data2_high_corr, aes(x = x, y = y), color = "#2596be", size = 3) +
  geom_line(data = line_data2_low_corr, aes(x = x, y = y), color = "#FF9933", size = 3) +
  labs(x = "β(w.Nwith)", y = "Slope of bet difference") +
  theme_classic() +
  theme(axis.title = element_text(size = 30),
        axis.text = element_text(size = 30)) +
  coord_cartesian(xlim = c(-2, 5), ylim = c(-0.5, 0.9))

# Display the plot
plot2











































