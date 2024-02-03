Create TABLE Rankings (
	 TEAM_ID int  references public."Teams"("TEAM_ID") not null,
	    SEASON_ID int not null ,
	STANDINGS_DATE DATE NOT NULL,
	
	TEAM text NOT NULL,
	GAMES_PLAYED int,
	WINNING_GAMES int,
	LOST_GAMES int,
	W_PCT double precision,
	HOME_RECORD varchar(20),
	ROAD_RECORD varchar(20),
	
       
	PRIMARY KEY(TEAM_ID,SEASON_ID,STANDINGS_DATE)