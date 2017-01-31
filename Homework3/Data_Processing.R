library(readr)
#importing data in R dataframe
nsf_data <- read_csv(file.choose())
View(nsf_data)

#Removing unwanted columns or attributes
drops <- c("title", "id", "published_year", "state", "nsf_org", "date_last_amended", "award_number",	"award_instrument", "date_expires", "address", "city", "inst_ctry_code","nsf_program",	"pgm_ref_codes",	"pgm_ref_names1",	"pgm_ref_names2",	"abstract",	"foa_codes", "field_application", "date_started")
nsf_data_min <- nsf_data[ ,!(names(nsf_data) %in% drops)]

zips <- data.frame(unique(nsf_data_min$zipcode))

#Setting zip code for "Geological Society of America Today" as 80301 from 80301-9140
nsf_data_min$zipcode[which(nsf_data_min$inst_id == 4003455000)] = 80301
nsf_data_min$zipcode[which(nsf_data_min$inst_id == 4003455000)]

#Aggregation Level 1: Aggregating data according to Geolocation (ZipCodes)
zData <- aggregate(nsf_data_min$expected_total_amount ~ nsf_data_min$zipcode, nsf_data_min, sum)
zData <- zData[order(-zData$`nsf_data_min$expected_total_amount`), ]
top30_zData = head(zData, 30)
colnames(top30_zData)[colnames(top30_zData)=="nsf_data_min$zipcode"] <- "ZipCode"
colnames(top30_zData)[colnames(top30_zData)=="nsf_data_min$expected_total_amount"] <- "Total_Amount"
write.csv(top30_zData, file="gelocation.csv", row.names = FALSE)

#Agregation Level 2: Aggregating data according to Institution Name
pData <- aggregate(nsf_data_min$expected_total_amount ~ nsf_data_min$institution_name, nsf_data_min, sum)
pData <- pData[order(-pData$`nsf_data_min$expected_total_amount`), ]
top5_pData = head(pData, 5)
colnames(top5_pData)[colnames(top5_pData)=="nsf_data_min$institution_name"] <- "Institution_Name"
colnames(top5_pData)[colnames(top5_pData)=="nsf_data_min$expected_total_amount"] <- "Total_Amount"
write.csv(top5_pData, file="institutes.csv", row.names = FALSE)



