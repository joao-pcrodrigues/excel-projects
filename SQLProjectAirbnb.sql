/*
Airbnb Prices in European Cities - Data Exploration
The dataset used consists of information from Airbnb in some of the most popular European cities during the weekdays and weekends.
Data Source: https://zenodo.org/record/4446043#.Y9Y9ENJBwUE

Skills used: Temp Tables, Unions, Window Functions, Aggregate Functions, Joins
*/


-- Selecting the date we're going to use by using a temp table to unite both tables
Drop Table if exists #week
Create Table #week (
city nvarchar(255),
realSum float,
room_type nvarchar(255),
room_shared nvarchar(255),
room_private nvarchar(255),
person_capacity float,
host_is_superhost nvarchar(255),
multi float,
biz float,
cleanliness_rating float,
guest_satisfaction_overall float,
bedrooms float,
citycentre_dist float,
metro_distance float,
lng float,
lat float
)

Insert Into #week
Select *
From PortfolioAirbnb..weekdays
UNION
Select *
From PortfolioAirbnb..weekends


-- Number of listings per city
Select city, count(city) as NumbOfListings
From #week
Group by city
Order by NumbOfListings DESC


-- Number of room types, in quantity and percentage
Select room_type, count(room_type) AS RoomTypeQty, count(room_type)*100 / SUM(count(room_type)) OVER () as RoomTypePercent
From #week
Group by room_type
Order by RoomTypeQty DESC


-- Average price of a listing per city
-- Shows the average price of listings on weekdays and weekends per city, as well as the diference in cost
Select weekdays.city, AVG(weekdays.realSum) as WeekdayAvgPrice, AVG(weekends.realSum) as WeekendAvgPrice, (AVG(weekdays.realSum)-AVG(weekends.realSum)) as CostDiference
From PortfolioAirbnb..weekdays as weekdays
Full Outer Join PortfolioAirbnb..weekends as weekends
	ON weekdays.city = weekends.city
Group by weekdays.city


-- Average room cleanliness (0-10)
Select room_type, AVG(cleanliness_rating) as AvgRoomCleanliness
From #week
Group by room_type


-- Average distance from city centre and metro by city (in Km)
Select city, AVG(citycentre_dist) as AvgCityCentreDistance, AVG(metro_distance) as AvgMetroDistance
From #week
Group by city
Order by city
