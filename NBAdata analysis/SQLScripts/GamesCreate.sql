Create TABLE Games (
	GAME_DATE_EST varchar not null,
	    GAME_ID int not null primary key,
        HOME_TEAM_ID int  references public."Teams"("TEAM_ID") not null,
	   SEASON int not null,
	PTS_home double precision,
	FT_PCT_home double precision,
	FG3_PCT_home double precision,
	AST_home double precision,
	REB_home double precision,
	TEAM_ID_away int  references public."Teams"("TEAM_ID") not null,
	PTS_away double precision,
	FT_PCT_away double precision,
	FG3_PCT_away double precision,
	AST_away double precision,
	REB_away double precision,
	HOME_TEAM_WINS double precision
    
);