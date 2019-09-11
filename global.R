#library(data.table)

#acd = fread('./Data/US_Accidents.csv', sep=',')
#acd$Start_Time = as_datetime(acd$Start_Time)
#saveRDS(acd, file = "./Data/US_Accidents.rds")

acd <- readRDS("./Data/US_Accidents.rds")
