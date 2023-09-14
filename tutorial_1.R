# load data
Ethnicity <- read.csv("Camden/tables/KS201EW_oa11.csv")
Rooms <- read.csv("Camden/tables/KS403EW_oa11.csv")
Qualifications <- read.csv("Camden/tables/KS501EW_oa11.csv")
Employment <- read.csv("Camden/tables/KS601EW_oa11.csv")

# view tables and table columns
View(Employment)
names(Employment)

# select columns based on indices
Ethnicity <- Ethnicity[, c(1,21)]
Rooms <- Rooms[, c(1,13)]
Employment <- Employment[, c(1,20)]
Qualifications <- Qualifications[, c(1,20)]

# rename columns
names(Employment)[2] <- "Unemployed"
names(Ethnicity) <- c("OA", "White_British")
names(Rooms) <- c("OA", "Low_Occupancy")
names(Employment) <- c("OA", "Unemployed")
names(Qualifications) <- c("OA", "Qualifications")

# merge selected columns
merged_data_1 <- merge(Ethnicity, Rooms, by="OA")
merged_data_2 <- merge(merged_data_1, Employment, by="OA")
Census.Data <- merge(merged_data_2, Qualifications, by="OA")
rm(merged_data_1, merged_data_2)

# load and export merged data
View(Census.Data)
write.csv(Census.Data, "practical_data.csv", row.names = F)
