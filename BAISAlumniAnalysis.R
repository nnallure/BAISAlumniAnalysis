rm(list=ls())

library(readxl)
library(dplyr)
library(ggplot2)


#1
# Load data from Excel file
may14 <- read_excel("BAIS alumni.xlsx")

# Rename columns with consistent names
colnames(may14) <- c("Grad.Month", "Grad.Year", "My..Conn", "Job.Title", "Current.City", "Current.State", "Home.Country", "Gender", "Major1", "Major2", "Major3", "Minor1", "Minor2", "Minor3", "Certificate1", "Certificate2", "Certificate3")

# Load data from CSV files
may20 <- read.csv("BAIS alumni_05-2020.csv")
may20 <- may20 %>% select("Grad.Month", "Grad.Year", "My..Conn", "Job.Title", "Current.City", "Current.State", "Home.Country", "Gender", "Major1", "Major2", "Major3", "Minor1", "Minor2", "Minor3", "Certificate1", "Certificate2", "Certificate3")

dec20 <- read.csv("BAIS alumni_12-2020.csv")

# Remove the "Employer" column from dec20
dec20$Employer <- NULL
dec20 <- dec20 %>% select("Grad.Month", "Grad.Year", "My..Conn", "Job.Title", "Current.City", "Current.State", "Home.Country", "Gender", "Major1", "Major2", "Major3", "Minor1", "Minor2", "Minor3", "Certificate1", "Certificate2", "Certificate3")

# Combine the data frames vertically using rbind
BAIS_alumni <- rbind(may14, may20, dec20)

#Drop the bad row, leaving 887 observations in the data frame
BAIS_alumni <- BAIS_alumni[-c(586), ]

#Save as a csv
write.csv(BAIS_alumni, "BAIS_alumni.csv", row.names = FALSE)

#Define fields as NA
BAIS_alumni <- read.csv("BAIS_alumni.csv", header = TRUE, na.strings = c(""," ", "NA"))



#2 
# Calculate the total number of graduates
total_graduates <- nrow(BAIS_alumni)

# Calculate the number of students with LinkedIn contact
students_with_contact <- sum(BAIS_alumni$My..Conn == 1, na.rm = TRUE)

# Calculate the percentage of students with contact
percentage_with_contact <- round((students_with_contact / total_graduates) * 100)

# Display the results
cat("The BAIS department has graduated", total_graduates, "students between May 2014 and December 2020.\n")
cat("The department is connected via LinkedIn to", students_with_contact, "students, about", percentage_with_contact, "% of graduates.\n")



#3
# Convert Grad.Year to a factor with ordered levels
BAIS_alumni$Grad.Year <- factor(BAIS_alumni$Grad.Year, levels = c("2014", "2015", "2016", "2017", "2018", "2019", "2020"))

# Create a bar plot
plot <- ggplot(BAIS_alumni, aes(x = Grad.Year, fill = Grad.Year)) +
  geom_bar(stat = "count") +
  labs(title = "Number of Graduates Each Year",
       x = "Graduation Year",
       y = "Number of Graduates") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.5) +
  scale_fill_manual(values = c("#474184", "#6a659f", "#9590c5", "#c8c5eb", "#ebeafc" ,"#d9dafd", "#e4d7ff" )) +  # Specify colors if needed
  guides(fill = guide_legend(title = "Graduation Year"))  # Add legend with title

# Show the plot
print(plot)



#4
# Filter out rows where MyConn is 1 and Current.State is not available
filtered_data <- BAIS_alumni %>% filter(My..Conn == 1, !is.na(Current.State))

# Create a summary table
state_summary <- filtered_data %>%
  group_by(State = Current.State) %>%
  summarise(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1:5) %>%
  mutate(`%` = round((Count / sum(students_with_contact)) * 100, 2),
         `%` = paste0(`%`, "%"))

# Print the summary table
print(state_summary)



#5
# Filter out records where Current State is NA
filtered_data <- BAIS_alumni %>% filter(!is.na(Current.State))

# Convert all students not from a US state or Washington D.C. to "Intl"
filtered_data$State <- ifelse(filtered_data$Current.State %in% state.abb | 
                                filtered_data$Current.State %in% state.name |
                                filtered_data$Current.State == "Washington D.C.",
                              filtered_data$Current.State, "Intl")

# Create a bar chart with vertical bars and ordered states from greatest to least
state_bar_chart <- ggplot(filtered_data, aes(x = forcats::fct_infreq(State, order = TRUE))) +
  geom_bar(stat = "count", fill = "#6a659f") +
  labs(title = "Number of Graduates in Each State/Intl",
       x = "State/Intl",
       y = "Number of Graduates") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1)) +
  geom_text(stat = "count", aes(label = ..count..), hjust = -0.5, vjust = -0.5)

# Show the bar chart
print(state_bar_chart)



#6
# Load data from CSV file and define NAs
graduates_data <- read.csv("BAIS_alumni.csv", na.strings = c("", " ", "NA"))

# Define a new column indicating the student category
graduates_data$Student_Category <- ifelse(is.na(graduates_data$Major2) & is.na(graduates_data$Minor1) & is.na(graduates_data$Certificate1),
                                          "Only BAIS", "Other Major/Minor/Certificate")

# Create a pie chart with a legend and labels
category_pie <- ggplot(graduates_data, aes(x = "", fill = Student_Category)) +
  geom_bar(width = 1, stat = "count", show.legend = TRUE) +
  coord_polar(theta = "y") +
  labs(title = "Graduates with Second Major, Minor, or Certificate vs. Only BAIS",
       x = NULL,
       y = NULL) +
  theme_minimal() +
  scale_fill_manual(values = c("#6a659f", "#c8c5eb"))  # Specify colors if needed

# Create labels separately
label_data <- graduates_data %>%
  group_by(Student_Category) %>%
  summarise(count = n())

# Add text labels to the plot
category_pie +
  geom_text(data = label_data, aes(x = 1, y = cumsum(count) - 0.5*count, label = count),
            position = position_stack(vjust = 0.5), color = "white", size = 5)



#7
#Majors
# Separate majors into three data frames
major1_df <- BAIS_alumni %>%
  select(Grad.Year, Major1) %>%
  filter(!is.na(Major1) & !(Major1 %in% c("Business Analytics", "Information Systems", "Management Information Systems"))) %>%
  rename(Major = Major1)

major2_df <- BAIS_alumni %>%
  select(Grad.Year, Major2) %>%
  filter(!is.na(Major2) & !(Major2 %in% c("Business Analytics", "Information Systems", "Management Information Systems"))) %>%
  rename(Major = Major2)

major3_df <- BAIS_alumni %>%
  select(Grad.Year, Major3) %>%
  filter(!is.na(Major3) & !(Major3 %in% c("Business Analytics", "Information Systems", "Management Information Systems"))) %>%
  rename(Major = Major3)

# Combine the three data frames
majors_combined <- rbind(major1_df, major2_df, major3_df)

# Group by major, summarize counts, and arrange in descending order
top_majors <- majors_combined %>%
  group_by(Major) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1:5)

# Create a bar plot with legend
majors_plot <- ggplot(top_majors, aes(x = reorder(Major, -Count), y = Count, fill = Major)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 5 Majors for BAIS Alumni",
       x = "Major",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_text(aes(label = Count), vjust = -0.5) +
  scale_fill_manual(values = c("#FF9999", "#66B2FF", "#99FF99", "#FFCC99", "#FFD700"))  # Specify colors for the legend

# Show the plot
print(majors_plot)


#Minors
# Separate minors into three data frames
minor1_df <- BAIS_alumni %>%
  select(Grad.Year, Minor1) %>%
  filter(!is.na(Minor1)) %>%
  rename(Minor = Minor1)

minor2_df <- BAIS_alumni %>%
  select(Grad.Year, Minor2) %>%
  filter(!is.na(Minor2)) %>%
  rename(Minor = Minor2)

minor3_df <- BAIS_alumni %>%
  select(Grad.Year, Minor3) %>%
  filter(!is.na(Minor3)) %>%
  rename(Minor = Minor3)

# Combine the three data frames
minors_combined <- rbind(minor1_df, minor2_df, minor3_df)

# Group by minor, summarize counts, and arrange in descending order
top_minors <- minors_combined %>%
  group_by(Minor) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1:5)

# Create a bar plot with legend
minors_plot <- ggplot(top_minors, aes(x = reorder(Minor, -Count), y = Count, fill = Minor)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 5 Minors for BAIS Alumni",
       x = "Minor",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_text(aes(label = Count), vjust = -0.5) +
  scale_fill_manual(values = c("#FF9999", "#66B2FF", "#99FF99", "#FFCC99", "#FFD700"))  # Specify colors for the legend

# Show the plot
print(minors_plot)


#Certificates
# Separate certificates into three data frames
cert1_df <- BAIS_alumni %>%
  select(Grad.Year, Certificate1) %>%
  filter(!is.na(Certificate1)) %>%
  rename(Certificate = Certificate1)

cert2_df <- BAIS_alumni %>%
  select(Grad.Year, Certificate2) %>%
  filter(!is.na(Certificate2)) %>%
  rename(Certificate = Certificate2)

cert3_df <- BAIS_alumni %>%
  select(Grad.Year, Certificate3) %>%
  filter(!is.na(Certificate3)) %>%
  rename(Certificate = Certificate3)

# Combine the three data frames
certificates_combined <- rbind(cert1_df, cert2_df, cert3_df)

# Group by certificate, summarize counts, and arrange in descending order
top_certificates <- certificates_combined %>%
  group_by(Certificate) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1:5)

# Create a bar plot with legend
certificates_plot <- ggplot(top_certificates, aes(x = reorder(Certificate, -Count), y = Count, fill = Certificate)) +
  geom_bar(stat = "identity") +
  labs(title = "Top 5 Certificates for BAIS Alumni",
       x = "Certificate",
       y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  geom_text(aes(label = Count), vjust = -0.5) +
  scale_fill_manual(values = c("#FF9999", "#66B2FF", "#99FF99", "#FFCC99", "#FFD700"))  # Specify colors for the legend

# Show the plot
print(certificates_plot)