
/**
	Dataset Source Link

	https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows

**/


USE [Imdb Project]
GO

SELECT [Poster_Link]
      ,[Series_Title]
      ,[Released_Year]
      ,[Certificate]
      ,[Runtime]
      ,[Genre]
      ,[IMDB_Rating]
      ,[Overview]
      ,[Meta_score]
      ,[Director]
      ,[Star1]
      ,[Star2]
      ,[Star3]
      ,[Star4]
      ,[No_of_Votes]
      ,[Gross]
  FROM [dbo].[imdb_top_movies]

GO

select * from imdb_top_movies;

---1) Fetch all data from imdb table 

    select * from imdb_top_movies;
	
---2) Fetch only the name and release year for all movies.
	select series_title, released_year
	from imdb_top_movies;
	
---3) Fetch the name, release year and imdb rating of movies which are UA certified.
	select series_title, released_year,imdb_rating
	from imdb_top_movies
	where certificate ='UA';

---4) Fetch the name and genre of movies which are UA certified and have a Imdb rating of over 8.
	select series_title, genre
	from imdb_top_movies
	where certificate ='UA' and imdb_rating>8;



---5) Find out how many movies are of Drama genre.
	select count(*)
	from imdb_top_movies
	where genre like '%Drama%';

---6) How many movies are directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and "Rajkumar Hirani".
	select count(1)
	from imdb_top_movies
	where director in('Quentin Tarantino', 'Steven Spielberg'
	, 'Christopher Nolan', 'Rajkumar Hirani');




---7) What is the highest imdb rating given so far?
	select max(imdb_rating) as Highest_imdb_Rating_sofar
	from imdb_top_movies;

	---8) What is the highest and lowest imdb rating given so far?
	
	select max(imdb_rating) as Highest_imdb_Rating_sofar, min(imdb_rating) as Lowest_imdb_Rating_sofar
	from imdb_top_movies;


---8a) Solve the above problem but display the results in different rows.
	

	select max(imdb_rating) as highest_rating
	from imdb_top_movies
	union  
	select min(imdb_rating) as lowest_rating
	from imdb_top_movies
	


---8b) Solve the above problem but display the results in different rows.
--And have a column which indicates the value as lowest and highest.
	

	select max(imdb_rating) as movie_rating, 'Highest rating' as high_low
	from imdb_top_movies
	union  
	select min(imdb_rating) , 'Lowest rating' as high_low
	from imdb_top_movies

---9) Find out the total business done by movies staring "Aamir Khan".

	

	select sum(gross)
	from imdb_top_movies
	where star1 = 'Aamir Khan'
	or star2 = 'Aamir Khan'
	or star3 = 'Aamir Khan'
	or star4 = 'Aamir Khan';


	--OR

	
	select sum(gross)
	from imdb_top_movies
	where 'Aamir Khan' IN (star1, star2, star3, star4);

  
---10) Find out the average imdb rating of movies which are neither directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and are not acted by any of these stars "Christian Bale", "Liam Neeson", "Heath Ledger", "Leonardo DiCaprio", "Anne Hathaway".


	select avg(imdb_rating) as avg_rating
	from imdb_top_movies
	where director not in ('Quentin Tarantino', 'Steven Spielberg', 'Christopher Nolan')
	and (star1 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway') 
		and star2 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway') 
		and star3 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway') 
		and star4 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
		);

		
---11) Mention the movies involving both "Steven Spielberg" and "Tom Cruise".
	

	select * from imdb_top_movies
	where director = 'Steven Spielberg'
	and (star1 = 'Tom Cruise'
		or star2 = 'Tom Cruise'
		or star3 = 'Tom Cruise'
		or star4 = 'Tom Cruise');

	
---12) Display the movie name and watch time (in both mins and hours) which have over 9 imdb rating.
	

	select series_title
	, runtime as runtime_mins
	, cast(replace(runtime, ' min', '') as decimal)/60  as runtime_hrs
	, round(cast(replace(runtime, ' min', '') as decimal) /60,2)  as runtime_hrs
	from imdb_top_movies
	where imdb_rating > 9;



---13) What is the average imdb rating of movies which are released in the last 10 years and have less than 2 hrs of runtime.





select round(avg(imdb_rating),2) as avg_rating
from imdb_top_movies
where (year(GETDATE())-(cast([Released_year] as int))<= 10
and round(cast(nullif(replace(runtime, ' min', ''), '') as decimal )/60,2) < 2);




	
	
---14) Identify the Batman movie which is not directed by "Christopher Nolan".


	select * from imdb_top_movies
	where upper(series_title) like '%BATMAN%'
		and director <> 'Christopher Nolan';


---15) Display all the A and UA certified movies 
---which are either directed by "Steven Spielberg", "Christopher Nolan" or which are
---directed by other directors but have a rating of over 8.
with mv as 

	(select*
	from imdb_top_movies
			where certificate in ('A', 'UA') 	
  )
select * from mv
where (director in ('Steven Spielberg', 'Christopher Nolan') 
or (director not in ('Steven Spielberg', 'Christopher Nolan') and imdb_rating>8)) ;


--OR


select * from imdb_top_movies
where certificate in ('A','UA')
and (director in ('Steven Spielberg', 'Christopher Nolan')
	 or 
		 (director not in ('Steven Spielberg', 'Christopher Nolan')
		  and imdb_rating > 8
		 )
	);






--16) What are the different certificates given to movies?
	
 select distinct(certificate)
 from imdb_top_movies
 where certificate is not null


---17) Display all the movies acted by Tom Cruise in the order of their release. 
--Consider only movies which have a meta score.
select * 

from imdb_top_movies

where star1= 'Tom Cruise' or star2= 'Tom Cruise' or star3= 'Tom Cruise' or star4= 'Tom Cruise' 
and meta_score is not null
order by released_year;



---18) Segregate all the Drama and Comedy movies released in the last 10 years as per their runtime.
--Movies shorter than 1 hour should be termed as short film. Movies longer than 2 hrs should be termed as longer movies. All others can be termed as Good watch time.
	
with [Latest Movies] as	
	(SELECT *
	from imdb_top_movies
	where ((genre like '%Drama%' or genre like '%Comedy%') and 
	 (year(getdate())-(cast(released_year as int)))<=10)
)

select  
	case when (round((cast(replace([Runtime], 'min', '') as decimal)/60),2))<1.00 then 'Short Film'
		when (round((cast(replace([Runtime], 'min', '') as decimal)/60),2))>2.00 then 'Longer Movies'
	else 'Good Watch Time'
	end as Category
	,(round((cast(replace([Runtime], 'min', '') as decimal)/60),2)) as run_time
	,[Series_Title]
	,[Genre]
from [Latest Movies];

  
---19) Write a query to display the "Christian Bale" movies which released in odd year and even year.
--Sort the data as per Odd year at the top.
select case 
			when (cast(Released_Year as int)%2)=0 then 'Even Year'
			else 'Odd Year'
		end as Year_Type
		,[Released_Year]
		,[Series_Title]

	from imdb_top_movies

	where [director] like 'Christian Bale' or [star1] like 'Christian Bale' 
	or [star2] like 'Christian Bale'
	or [star3] like 'Christian Bale'
	or [star4] like 'Christian Bale'
	order by Year_Type desc;







---20) Re-write problem #18 without using case statement.

	select 'Odd Year' as Year_Type
		,[Released_Year]
		,[Series_Title]

	from imdb_top_movies

	where (([director] like 'Christian Bale' or [star1] like 'Christian Bale' 
	or [star2] like 'Christian Bale'
	or [star3] like 'Christian Bale'
	or [star4] like 'Christian Bale') and (cast(Released_Year as int)%2)<>0)
	
	
	union all


	select 'Even Year' as Yaer_Type
		,[Released_Year]
		,[Series_Title]

	from imdb_top_movies

	where (([director] like 'Christian Bale' or [star1] like 'Christian Bale' 
	or [star2] like 'Christian Bale'
	or [star3] like 'Christian Bale'
	or [star4] like 'Christian Bale') and (cast(Released_Year as int)%2)=0);


