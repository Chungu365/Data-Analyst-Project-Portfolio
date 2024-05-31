# Load our needed libraries.
library(ggplot2)
library(tidyverse)
library(palmerpenguins)

# Load the dataset.
data("penguins")

# Explore the data and some statistics
View(penguins)

head(penguins)

glimpse(penguins)

sum(is.na(penguins))

summary(penguins)

# Basic visualization to understand our data
# Scatter plot to explore relationship between flipper length and body mass
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g))

# Distribution of flipper length by species
ggplot(data = penguins) +
  geom_histogram(mapping = aes(x = flipper_length_mm, fill = species), binwidth = 5, position = "dodge")
 
# More complex visualizations to uncover deeper insights.
# Using two geoms on the same plot
# Geom_smooth is useful for showing general trend is data.
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g))

# Using Linetype aesthetic to create seperate lines for each variable
ggplot(data = penguins) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g, linetype = species))

ggplot(data = penguins) +
  geom_smooth(mapping = aes(x = flipper_length_mm, y = body_mass_g, linetype = species))

# Using geom_jitter
# This function creates a scatter plot then adds small ranndom noises to each point in the plot to help with overplotting
# Jittering makes the points easier to find.
ggplot(data = penguins) +
  geom_jitter(mapping = aes(x = flipper_length_mm, y = body_mass_g))

#Two types of smoothing.
# Smooth is best for datasets with points < 1000, whilst gam is better for larger datasets
ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_smooth(method = "loess")

ggplot(data = penguins, mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_smooth(method = "gam")

#Facetting in R using ggplot2
ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + 
  facet_wrap(~species)

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color, fill = cut)) +
  facet_wrap(~cut)

ggplot(data = penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)) + 
  facet_grid(sex~species)

# Adding Labels
# Here we add a Title, Subtitle, and Caption.

ggplot(data =penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins : Body Mass vs. Flipper Length", 
       subtitle = "sample of 3 Penguin Species", caption = "Data collected by Dr. Kristen Gorman") 
 
# Adding Annotations as another layer to our plot
ggplot(data =penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins : Body Mass vs. Flipper Length", 
       subtitle = "sample of 3 Penguin Species", caption = "Data collected by Dr. Kristen Gorman") +
  annotate("text", x = 220, y = 3500, label = "The Gentoos are the largest")

# Further customization : adding color, bolding, changing size as well as angle of text
ggplot(data =penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins : Body Mass vs. Flipper Length", 
       subtitle = "sample of 3 Penguin Species", caption = "Data collected by Dr. Kristen Gorman") +
  annotate("text", x = 220, y = 3500, label = "The Gentoos are the largest", color = "purple", size = 3.0, fontface= "bold")

# Now we store it as a variable to shorten our code

P <- ggplot(data =penguins) +
  geom_point(mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  labs(title = "Palmer Penguins : Body Mass vs. Flipper Length", 
       subtitle = "sample of 3 Penguin Species", caption = "Data collected by Dr. Kristen Gorman") +
  annotate("text", x = 220, y = 3500, label = "The Gentoos are the largest", color = "purple", size = 3.0, fontface= "bold")

# Saving our image using ggsave() function
ggsave("Palmer.jpeg")





