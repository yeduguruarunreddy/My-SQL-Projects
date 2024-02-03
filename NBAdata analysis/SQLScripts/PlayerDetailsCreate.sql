CREATE TABLE PlayerDetails (
	    PLAYER_NAME varchar(100),
        TEAM_ID int  references public."Teams"("TEAM_ID"),
        PLAYER_ID int  references public."Players"("PLAYER_ID"),
       SEASON int,
       PRIMARY KEY(TEAM_ID,PLAYER_ID,Season)
);