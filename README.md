# adCampaignAnalysisR
R file displaying how to analyse a Companies ad campaign. 

This README.md file is a brief explanation to help you follow the code I used, when analysing the Ad Campaigns datasets. The code is to show you how to the same analysis when using your own dataset(s). 

I will break the file into 3 sections to make it easy to follow:
  1. How the program runs (understanding the code used):
  2. Why I created certain graphs and analysed the data in this fashion.
  3. Show you how to interpret the graphs with example output.

## Section 1 - How the program runs:

I broke my coding file into 8 parts and also added comments throughout to makes it easier to understand what is occuring at different stages.

  ### Part I: Importing Data.
To begin I always make sure my file directory is where my target datasets are. If they are not then you will encounter problems, when trying to import the datasets. Lines 3 and 4 finds my directory and then I set that as my working directory. 
We also need to ensure we have the correct libraries loaded as this can affect some of our code runnning. I import the 2 libraries needed at line 7 and 8. 
The following block of code is when we load the datasets. Take line 10 for example, here I
decided to use 'read_csv' as it loads the dataset as a tibble which will benefit us when merging the datasets later. I also set the dataset to a variable advertiser. This is very important as it shows us what the file refers to. I.e. we would not want to save the amount of impressions we received as the amount of clicks we received it would impact our analysis. 

  ### Part II: Check datasets are loaded correctly.
The block of code lines 18-22 simply view the datasets. This is a quick way to allow us to visually see if there are any abnormalities within the data tables. Lines 26-30 check for any missing data within the data tables. Null values would affect our analysis so we need to eliminate any if present. Once all the datasets are loaded under the correct variable names and there are no null values we are ready to start using them for analysis.

  ### Part III Transforming and Tidying Data.
We saw from when we viewed the datasets that the clicks, impressions and conversions datasets contained the dates of when the action occured. The first thing we need to do is to transform the dates an action occured into a singular number that quickly shows how many times the action occured for a campaign. I.e. instead of having 4 dates associated with a campaign. The number 4 will be displayed in the column beside the campaign name.
I knew I was going to have to repeat this transformation 3 times so I decided to create a function to make it simpler for your use. The No_of_Function counts the number of times the campaign_id appears within a dataset and adds a column with this figure. In essence changes the dates to a number.
We call the function on line 44 and store the new table under the variable name 'No_of_clicks'. We then View the table we noticed the new column is labelled 'n' so we go ahead and change that using the code on lines 48-52. On line 50 is where we change 'n' to clicks. 
We repeat these two transformations, Counting and renaming for the impressions dataset and then for conversions dataset. All we do is just replace the dataset name within the No_of_Function and then for renaming you just change the table name, and then input your new column name on the left hand side of the = and the target column (column you want to change) on the right hand side. 

  ### Part IV: Joining/Merging Tables.
 Now that our data is useable the final step to complete, is joining the tables in order to allow us to analyse the data using EDA analysis techniques such as VARIATION and CO-VARIATION anlysis.
The first thing to notice is that we can only join tables using columns with the same name. Therefore to start we must rename certain columns before we try join. We use the exact same renaming technique as seen from before when renaming columns in the clicks,impressions and conversions datasets. 
We initially merge the ads and campaign datasets together using an INNER_JOIN so that any unmatched columns are dropped as they are redundant. Line 84 joins the two tables and stores the new table under adCampaign1. We view the new table to see we merged them correctly. Upon inspection we see that we need to rename some columns in order to give the table more meaning. We Once again use the exact same technique as seen above however we change 3 column names rather than just one. The new table with the apropriate column names is stored under adCampaign1WithColNames.
Now we merge the tibble just created (adCampaign1WithColNames) with the No_of_clicks table that we have tidied from earlier. We use a LEFT_JOIN in order to keep all campaigns which did not receive clicks, with N/A representing that specific cell. 
We use the exact same join to add the impressions column and the conversions column all we do is change the dataset name from No_of_clicks to No_of_impressions and then from No_of_impressions to No_of_conversions. We then View the final dataset (adCampaign) to check to see the data tables merged correctly.

  ### Part V: Tidying created Tibble.
Now that we have one dataset (adCampaign) we just need to tidy and make sure we have not affected any of the values when tidying and joining the 5 datasets we were given. Firstly check that Advertiser ID's are unique (Lines 111-113), 11354 returns 3 times which is true as we know 1 advertiser ran 3 campaigns. More importantly we check all campaign IDs are unique (Lines 117-119). 0 is returned indicating all IDs are unique. When joining with the LEFT_JOIN we allocated some cells N/A when the value was equal 0. This will cause issues when analysing therefore we change all the N/A values to 0 (Lines 123-124). Now the data table is complete and ready for Analysing. 
 
  ### Part VI: EDA Variation analysis.
To start I remind myself of the different column names that are available to analyse (Line 130). Load ggplot2 library in order to plot graphs. The plotting of data itself is the easiest part of the analysis stage as the plot follow a uniform template. All we have to do is change the 'data = X', choose the graph we want i.e. geom_bar, and then add in the column name we want as 'x= column name' the rest is styling 'ggtitle' ads a title to the graph, 'xlab' labels the x-axis and 'ylab=' labels the y-axis (Line 135-136) *You must run these 2 lines together to get a graph*. There is certain graphs associated with certain data types. i.e. cant plot categorical data with a freqpoly. Plotting the continuous data follows the exact same template as categorical we just need to change the type of graph we want. With continuous data we can select a 'binwidth' this basically groups the data. I.e binwidth = 1000, will return a histogram whose bars are all 1000 in width (Lines 159-160).

  ### Part VII: EDA Co-Variation analysis.
Same again remind ourselves of the column names (Line 200). We have different tyoes of covariation analysis the first being Categorical VS Continuous (Part VII(A)). The good thing is that our graphs follow the same template as with the variation analysis. The KEY difference is that instead of just inputting one column name we input 2 to analyse the affects (if any) that one variable has on the other. Here I have x = budget and colour = campaign_name. This will return the budgets associated to each campaign (Lines 211-222). We then have Categorical VS Categorical (Part VII(B)). Exact same template just a changing the X and Y variables and styling and choosing a more appropriate graph(Lines 219-220). The final type being Continuous VS Continuous (Part VII(C)). Once again exact same layout just changing the graph type to cater for the variable types. 

## Section 2. Why I created certain graphs and analysed the data in this fashion:

  ### Part VI: EDA Variation Analysis.
Variation describes the difference in values from measurement to measurement. Each variable has its own pattern which may reveal interesting and useful information. Visualisations are the best way to understand these patterns. There are two types of data types that we will be analysing CATEGORICAL and CONTINUOUS data. Categorical data represents data that can be divided into groups (i.e Gender). Continuous data is data that can be any value and cannot be grouped (i.e. Height). 
I started off plotting the categorical data first (Part VI(A)). First graph I plotted was to show the amount of times an advertiser appeared in the dataset. This graph would show if one advertiser carried out more than 1 ad campaign. Then I thought to plot the campaign names to see how many times they appeared. Followed by the amount of times a campaign id appeared (Expect one time each as it is a unique key). 
I then plotted continuous data (Part VI(B)). I plotted the budget variable to see what were the different budget values. I plotted the amount of clicks to get a quick look at the most clicks received my campaign and the lease clicks recieved by a campaign. I also plotted a graph to see how many impressions campaigns received. Then leading on from this how many conversions campaigns received as I deemed the conversion count the most vital when measuring the success of the campaign.

  ### Part VII: EDA Co-Variation Analysis.
Co-Variation describes the relationship between variables. As one increases does the other decrease? As one decreases does the anything happen to the other? The three co-variation types I will look at are:
    1. Categorical VS Continuous
    2. Categorical VS Categorical
    3. Continuous VS Continuous
1. For me the first obvious comparison to make is to see what budgets were associated to each advertiser. This gave me a quick look at what advertisers invested the most capital into their campaigns. Then from this I wanted to see what specific campaigns received the most financial support.
2. The main categorical vs categorical analysis we could run is to see what campaigns each advertiser ran. This is helpful as when we find out what campaign is most successful we immediately know what company to associate it with.
3. The final type of co-variation is continuous vs continuous. In my eyes the main measure of success for a campaign is how many conversions the campaign receives and the amount spent on that campaign. Then to clarify this graph I ran the same graph but showed the advertiser rather than the campaign. I than plotted the amount of clicks a campaign received with regards to the amount of impressions it had. Then from this I wanted to see how many people clicked on the ad and then preformed the final step (conversion). This all seemed appropriate as I could measure what campaign and associated company received the most conversions in conjunction with the financial backing received. As well as seeing how many people performed an action i.e. if someone clicked did they then perform the conversion action.

## Section 3: Show you how to interpret the graphs with example output.
In this final section I will show you how to interpret the graphs we have created and how to link them.

### Part VI: Variation graphs.

#### Part VI(A): Categorical graphs.

![CompanyCount](https://user-images.githubusercontent.com/75272172/103785223-dc53d300-5032-11eb-8621-7b29bf82c512.png)

This graph just simply plots the amount of times an advertiser (company) appears in the dataset. Quickly we see Coca-Cola appears 3 times with Nintendo and Lever Brows appearing once each. We see this as the x-axis shows the 3 different companies represented as bars the y-axis shows the count (number of times). We see that Coca-cola bar goes to 3 therefore showing it appears 3 times. 

![CampaignCount](https://user-images.githubusercontent.com/75272172/103785097-b4fd0600-5032-11eb-82cd-dc90c5050aa5.png)

This is the exact same graph just representing campaign instead of company. Notice that for all campaigns they have a corresponding value of 1, which is expected. However, 'Run of Network' has an associated value of 2. Why is this? We stated that all campaigns have a unique_id. Did a company run the same campaign twice? 

![CampaignIDCount](https://user-images.githubusercontent.com/75272172/103785102-b5959c80-5032-11eb-8fd7-eeb062d094ce.png)

Plot the exact same graph but the x-axis represents campaign_id. This graph returns 5 bars which represent 5 unique IDs. Therefore our statement holds true. All campaigns do infact have unique ids although may have the same campaign name. Therefore our previous graph should say "Number of times a campaign name was used"

![CampaignCount2](https://user-images.githubusercontent.com/75272172/103785101-b5959c80-5032-11eb-8f88-8c8ad0765586.png)

This is the resulting graph after changing the code. Notice the graph represents the information more accurately.

#### Part VI(B): Continuous graphs.

![budgetHIst](https://user-images.githubusercontent.com/75272172/103785090-b3334280-5032-11eb-9f65-b890a44bd3b4.png)

This histogram is quite hard to read try a freqpoly graph.

![BudgetFreqPoly](https://user-images.githubusercontent.com/75272172/103784998-90089300-5032-11eb-9822-1dbaeaa7f936.png)

This was a good idea as the freqpoly graph is easier to read off. We noticed the freqpoly and the histogram are slightly thicker at the first bin. This is because the first bin is representing two campaigns. We also see that one campaign has received a significantly bigger budget than the others. (outlier)

![ClickHIST](https://user-images.githubusercontent.com/75272172/103785219-db22a600-5032-11eb-967e-fccb346bfa77.png)

From the histogram we can see 2 campaigns failed to receive 1 click. We see that 2 campaigns received 4 clicks. We also see that 6 is the most amount of clicks any campaign received. We can see all the information we need from the histogram so theres no need for a freqpoly. Questions: What campaigns received the most clicks, did budget come into play? We will see when we do Co-Variation Analysis. Histograms seem to work better for whole numbers with a uniform increase.

![Impression_hist](https://user-images.githubusercontent.com/75272172/103785227-dd850000-5032-11eb-9a8b-8a61151c023c.png)

We see that no two campaigns received the same amount of impressions. We see one campaign created no impressions. Whilst one campaign created 13 impressions. Lets see what factors lead to campaigns creating more or less impressions later using co variation.

![conversionHIST](https://user-images.githubusercontent.com/75272172/103785224-dcec6980-5032-11eb-8e05-54e48dd9a8cb.png)
We see that 2 campaigns saw not conversions. 1 campaign got 2 conversions. 2 campaigns got 3 conversions. Lets also use Covariation to see what factors affected conversion rates.

### Part VII: Covariation plots.

#### Part VII(A): Categorical VS Continuous graphs.

![advertiserBUDG](https://user-images.githubusercontent.com/75272172/103784833-53d53280-5032-11eb-8b15-47b25381c6dc.png)

From the graph we can see that Lever Brows were the company who injected €250,000 into their advertising campaign. We also see that the orange line has 3 spikes this coincides with the fact Coca-cola had 3 seperate advertising campaigns. We also see the blue line which represents nintendo spikes early around €1000 which coinicides with the data table. 

![campaignBUDG](https://user-images.githubusercontent.com/75272172/103785095-b4646f80-5032-11eb-8aa6-2d67b2cfbf91.png)

We can now use knowledge from the previous graph and this graph to see that Lever Brows ran the campaign Q4 performance, with the largest budget. We can also see that 'Run of network' appears twice. Lets see if we can find out why.

#### Part VII(B): Categorical VS Categorical.

![CampADVERT](https://user-images.githubusercontent.com/75272172/103785092-b4646f80-5032-11eb-950a-173e06897486.png)

First thing that jumps out at us is that coca-cola is the only company to run more than 1 campaign. Secondly if you remember from our variation analysis and from the previous graph, we noticed 1 campaign name, appeared twice. We wondered if it was the same company running the same campaign again. From this graph we clearly see that this was not the case and that Nintendo and Coca-Cola ran ad campaigns that had the same name.

#### Part VII(C): Continuous VS Continuous.

![BudgetCONVERS](https://user-images.githubusercontent.com/75272172/103784945-82eba400-5032-11eb-95bb-41430aac58b8.png)

We see that the Q4 performance campaign which had the biggest budget had the most conversions. We also see that Test campaign had the lowest budget and received 0 conversions. These two pieces of information are kind of expected. However we see that one of the 'Run of network' campaigns had one of the lowest budgets but also received 3 conversions. The same amount of conversions as the Q4 performance campaign which had a much larger budget. We still need to find out if it was the Nintendo or Coca-cola Run of network campaign.

![BUDGconversionCompany](https://user-images.githubusercontent.com/75272172/103784916-7404f180-5032-11eb-858c-9fda8604fa62.png)

This graph quickly shows us that the blue dot that is in the same position as the target dot, is associated with Nintendo. We also see that Coca-cola ran 2 campaigns that received no conversions and only when they increased their budget that they managed to get some conversions.

![impressionsvsclick](https://user-images.githubusercontent.com/75272172/103785230-dd850000-5032-11eb-8840-46f9ddc42e70.png)

We see that Test campaign received 0 impressions and therefore received 0 clicks as it did not appear for people. We know that Coca-colas 'Run of network' campaign received 0 conversions (from previous graph) and therefore we can associate the 'Run of network' on the x axis with coca-cola. We also see that although they had 4 impressions no one clicked on the ad. We see that Q4 performance received the most clicks(6) even though Nintendos Run of Network had more impressions(13)

![clicksvsconversions](https://user-images.githubusercontent.com/75272172/103785221-dc53d300-5032-11eb-9628-40351ed51421.png)

We see that Nintendos Run of Network and Q4 performance received the same amount of conversions(3), even though Nintendo received less clicks(4) with the Run of network than Lever Brow did (6 clicks) with their Q4 performance campaign.

## Conclusion.
At the end of all this analysis. For me the graph which allows us to gauge how successful an ad campaign was. Is the graph where we compare campaign_name with the budget associated with the campaign. For me this graph addequately shows what all campaigns are trying to achieve. The most conversions with the lowest budget. After finding out the different 'Run of network' campaigns we can safely say that Nintendo had the most succesful ad campaign. Receiving 3 conversions whilst using a small budget. That is the beauty about this file, it is a template for others to use to perform their own analysis on similar datasets. You may decide that there is better graphs to use and to decide how successful a campaign is. This file is to be used as the skeleton for that analysis, with the user only having to change variable names at most. 





