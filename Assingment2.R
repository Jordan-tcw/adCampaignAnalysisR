#Part I: Getting your data imported
#Get your directory and set it.
print(getwd())
setwd("/Users/jordanwilkes/Documents/3rdYear/Statistical Programming/Assignment2")

#Load the neccessary libraries needed.
library(tidyverse)
library(tibble)
#Load the target datasets for analysis.
advertiser <- read_csv('advertiser.csv', col_names = TRUE)
campaign <- read_csv('campaigns.csv', col_names = TRUE)
clicks <- read_csv('clicks.csv', col_names = TRUE)
conversions <- read_csv('conversions.csv', col_names = TRUE)
impressions <- read_csv('impressions.csv', col_names = TRUE)

#Part II: Check Datasets imported properly
#View the loaded datasets to ensure they are loaded correctly.
view(advertiser)
view(campaign)
view(clicks)
view(conversions)
view(impressions)


#Tidy data: Check for any null values within the datasets. 
is.na(advertiser)
is.na(campaign)
is.na(noOfClicks)
is.na(conversions)
is.na(impressions)
#The 'False' idicates that there is no null data present.

#Part III: Transforming and Tidying data (renaming columns).  
#The dates within the datasets clicks, conversions and impressions make it very hard to use them efficiently
#Therefore we need to tidy them in order to make them useful.

#The following function translates the dates people performed an action into useful integers. i.e amount of times a campaign was clicked
No_of_Function <- function(dataset) {
  N = dataset %>% count(campaign_id)
  return(N)
}

#Now we call this function to tidy our clicks dataset.
No_of_clicks <- No_of_Function(dataset = clicks)
view(No_of_clicks)

#rename column clicks for clarity as 'n' does not tell us what the column represents. 
No_of_clicks <- No_of_clicks %>%
  rename(
    clicks = n
  )
view(No_of_clicks)

#We need to repeat this transformation for impressions and conversions.
#Tidy impressions.
No_of_impressions <- No_of_Function(dataset = impressions)
view(No_of_impressions)
#rename column 'n' 
No_of_impressions <- No_of_impressions %>%
  rename(
    impressions = n
  )
view(No_of_impressions)

#Tidy Conversions 
No_of_conversions <- No_of_Function(dataset = conversions)
view(No_of_conversions)
#Rename column 'n' in No_of_conversions table.
No_of_conversions <- No_of_conversions %>%
  rename(
    conversions = n
  )
view(No_of_conversions)

#Part IV: Joining/Merging tables
#Rename columns to allow us to join tables.
library(dplyr)
ads <- advertiser %>%
  rename(
    advertiser_id = ID
  )

#Join advertiser and campaign using inner_join in order to drop any unmatched column names between the datasets.
adCampaign1 <- inner_join(ads, campaign, by = "advertiser_id")
view(adCampaign1)

#Rename column names (name.x, name.y) for clarity
adCampaign1WithColNames <- adCampaign1 %>%
  rename(
    advertiser_name = name.x,
    campaign_name = name.y,
    campaign_id = id
  )
view(adCampaign1WithColNames)

#Merge the tibble just created (adCampaign1WithColNames) with No_of_clicks tibble. 
#Use left_join to keep all campaigns but campaigns which did not receive clicks showing N/A.
adCampaign <- left_join(adCampaign1WithColNames, No_of_clicks, by = 'campaign_id')
view(adCampaign)

#Add impressions to adCampaign tibble. Using same method as No_of_clicks tibble.
adCampaign <- left_join(adCampaign, No_of_impressions, by = 'campaign_id')
view(adCampaign)

#Add conversions to adCampaign tibble using the same method as before.
adCampaign <- left_join(adCampaign, No_of_conversions, by = 'campaign_id')
view(adCampaign)

#Part V: Tidy Created tibble
#Check all Advertiser ID's are unique.
ad_counts <- count(adCampaign, advertiser_id)
filter(counts, n > 1)
view(ad_counts)
# Advertiser_id 11354 is returned 3 times. We see from Viewing the adCampaign table that this is correct as Coca-cola have 3 campaigns.

#Check all campaign ID's are unique
camp_counts <- count(adCampaign, campaign_id)
filter(counts, n > 1)
view(camp_counts)
#Returns 0 showing all campaigns have a unique ID

#N/A values will cause issues therefore change N/A values to 0.
adCampaign[is.na(adCampaign)] = 0
view(adCampaign)
#Complete data table ready for analysing 

#Part VI: Analysing the dataset (adCampaign) -EDA Variation.

#Get column names to help decide what columns you want to analyse. 
colnames(adCampaign)
#Load ggplot2 library for plotting.
library(ggplot2)
#Part VI(A): Plotting Categorical data
#Plot amount of times advertiser appears within the dataset.
advertiser_count <- ggplot(data = adCampaign) + geom_bar(mapping = aes(x= advertiser_name))
advertiser_count + ggtitle("Number of campaigns by each company") + xlab("Company Name") + ylab("Count")

#Plot similar graph for campaign count.
campaign_count <- ggplot(data = adCampaign) + geom_bar(mapping = aes(x= campaign_name))
campaign_count + ggtitle("Number of times a campaign occured") + xlab("Campaign Name") + ylab("Count")

#Plot Campaign_id to try find an answer to this.
campaignID_count <- ggplot(data = adCampaign) + geom_bar(mapping = aes(x= campaign_id))
campaignID_count + ggtitle("Number of times a campaign ID occured") + xlab("Campaign ID") + ylab("Count")

campaign_count <- ggplot(data = adCampaign) + geom_bar(mapping = aes(x= campaign_name))
campaign_count + ggtitle("Number of times a campaign name was used") + xlab("Campaign Name") + ylab("Count")
#above code is how we should have described the plot regarding campaign name.

#Part VI(B): Plotting continuous data. 
#Plot the budgets of each campaign.
budget_hist <- ggplot(data = adCampaign)+ geom_histogram(mapping = aes(x=budget), binwidth = 1000)
budget_hist + ggtitle("Budget Histogram") + xlab("Budget Value") + ylab("Amount")
#The Histogram is quite hard to read so lets use a freqpoly to see if it makes it clearer.

budget_freq <- ggplot(data = adCampaign)+ geom_freqpoly(mapping = aes(x=budget), binwidth = 1000.0)
budget_freq + ggtitle("Budget Histogram") + xlab("Budget Value") + ylab("Amount")
#This was a good idea as the freqpoly graph is easier to read off.

#Plot histogram using bin width 1, as the clicks can only increase by 1.
click_hist <- ggplot(data = adCampaign)+ geom_histogram(mapping = aes(x=clicks), binwidth = 1)
click_hist + ggtitle("Click Histogram") + xlab("Number of Clicks Received") + ylab("Campaign Count")

#Plot histogram to show impressions.
impression_hist <- ggplot(data = adCampaign)+ geom_histogram(mapping = aes(x=impressions), binwidth = 1)
impression_hist + ggtitle("Impression Histogram") + xlab("Number of Impressions") + ylab("Campaign Count")

#Plot histogram to show conversion information.
conversion_hist <- ggplot(data = adCampaign)+ geom_histogram(mapping = aes(x=conversions), binwidth = 1)
conversion_hist + ggtitle("Conversion Histogram") + xlab("Number of Conversions") + ylab("Campaign Count")

#Part VII: Dataset Analysis continued - Covariation

#Remind yourself of the column names again.
colnames(adCampaign)

#Part VII(A): Categorical VS Continuous
#Advertiser VS Budget
advertiser_budg <- ggplot(data = adCampaign) + geom_freqpoly(mapping = aes(x = budget, colour = advertiser_name), binwidth = 600)
advertiser_budg + ggtitle("Advertiser VS Budget") + xlab("Budget") + ylab("Count")

#Now lets see what budget is associated with each campaign 
campaign_budg <- ggplot(data = adCampaign) + geom_freqpoly(mapping = aes(x = budget, colour = campaign_name), binwidth = 600)
campaign_budg + ggtitle("Campaign VS Budget") + xlab("Budget") + ylab("Count")


#Part VII(B): Categorical VS Categorical
#Lets now see what campaigns each advertiser ran.
campaign_advertiser <- ggplot(data = adCampaign, aes(x = advertiser_name, fill = campaign_name)) + geom_bar(position = 'stack')
campaign_advertiser + ggtitle("Advertiser vs Campaigns") + xlab("Advertiser") + ylab("Campaign Count")

#Part VII(C): Continuous vs Continuous
#Lets have a look at how budget affected conversions.
budget_conversion <- ggplot(data = adCampaign) + geom_point(mapping = aes(x = budget, y = conversions, colour = campaign_name), size =2, stroke=2)
budget_conversion + ggtitle("Budget vs Conversions") + xlab("Budget") + ylab("Conversions")

budget_conversion <- ggplot(data = adCampaign) + geom_point(mapping = aes(x = budget, y = conversions, colour = advertiser_name), size =2, stroke=2)
budget_conversion + ggtitle("Budget vs Conversions") + xlab("Budget") + ylab("Conversions")


#The geom_point graph is a very easy and clear way to view continuous data so we will stick with that method.
impressions_click <- ggplot(data = adCampaign) + geom_point(mapping = aes(x = impressions, y = clicks, colour = campaign_name), size=2, stroke=2)
impressions_click + ggtitle("Clicks vs Impressions") + xlab("Impressions") + ylab("Clicks") + labs(fill = "Campaign")

#Lets see what campaigns received conversions after a user clicked the ad
click_conversion <- ggplot(data = adCampaign) + geom_point(mapping = aes(x = clicks, y = conversions, colour = campaign_name), size=2, stroke=2)
click_conversion + ggtitle("Clicks vs conversions") + xlab("Clicks") + ylab("Conversions") + labs(fill = "Campaign")

#Part VIII: Conclusion
#At the end of the day for me the graph which allows us to gauge how successful an ad campaign was is the graph where we compare campaign_name with the budget associated with the campaign.
#Graph:
budget_conversion <- ggplot(data = adCampaign) + geom_point(mapping = aes(x = budget, y = conversions, colour = campaign_name), size =2, stroke=2)
budget_conversion + ggtitle("Budget vs Conversions") + xlab("Budget") + ylab("Conversions")



