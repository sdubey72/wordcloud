dracula<-gutenberg_download(345)

#create a column
dracula$line<-1:15568

#drop a column
dracula$gutenberg_id<-NULL

#create a dataframe, unnest takes two parameters, first is the name of the resultant column and second is the name of source column.
drac_df<-dracula%>%
  unnest_tokens(word,text)

#create a column
drac_df$group<-drac_df$line %/% 80

#one more column for sentiment types
bing<-get_sentiments('bing')

#create a new column for sentimenst joining it with tidytext's bing table.
drac_df<-inner_join(drac_df,bing)

#create a new column and store 1 in all the columns
drac_df$indicator<-1

#look for negative values and replace with -1
drac_df$indicator[which(drac_df$sentiment=='negative')]<--1

drac_sent<-drac_df%>%
  group_by(group)%>%
  summarize(group_sentiment=sum(indicator))

ggplot()+
  geom_col(data = drac_sent,aes(x=group,y=group_sentiment),stat='identity',fill='#D35400',color='black')
