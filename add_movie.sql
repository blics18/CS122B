DELIMITER $$
CREATE PROCEDURE `add_movie`(
IN movieTitle VARCHAR(100),
IN movieYear INT(4),
IN directorName VARCHAR(100),
IN bannerURL VARCHAR(200),
IN trailerURL VARCHAR(200), 
IN firstName VARCHAR(50),
IN lastName VARCHAR(50),
IN dateOfBirth date, 
IN photoURL VARCHAR(200),
IN genreName VARCHAR(32), 
OUT movieMessage VARCHAR(100), 
OUT starMessage VARCHAR(100), 
OUT genreMessage VARCHAR(100))
BEGIN
DECLARE movieID INT(20);
DECLARE starID INT(20);
DECLARE genreID INT(20);
DECLARE starCount INT(2);
DECLARE genreCount INT(2);

-- add movie if it does not exist
IF (movieTitle not in (SELECT m.title from movies m where m.title=movieTitle)) THEN 
	INSERT INTO movies (title, year, director, banner_url, trailer_url) VALUES (movieTitle, movieYear, directorName, 
    bannerURL, trailerURL);
    SET movieMessage = "Successfully added movie";
else
	SET movieMessage = "Movie already exists";
END IF;

-- check star name
IF (firstName in (SELECT s.first_name from stars s where s.first_name=firstName AND
s.last_name=lastName)) THEN -- star exists
	SET movieID = (SELECT m.id from movies m where m.title=movieTitle);
	SET starID = (SELECT s.id from stars s where s.first_name=firstName and s.last_name=lastName);
    SET starCount = (SELECT count(*) from stars_in_movies sim where sim.star_id=starID
	AND sim.movie_id=movieID);
	IF (starCount = 0) THEN -- star not linked to star_in_movie
		INSERT INTO stars_in_movies (star_id, movie_id) VALUES (starID, movieID);
        SET starMessage = "Successfully linked star and movie in star_in_movies";
	ELSE 
		SET starMessage = "Movie and star already linked together";
	END IF;
END IF;

SET starCount = (SELECT count(*) from stars s where s.first_name=firstName AND
s.last_name=lastName);
IF (starCount = 0 ) THEN -- star does not exist
	INSERT INTO stars (first_name, last_name, dob, photo_url) VALUES (firstName, lastName, dateOfBirth, photoURL);
	SET movieID = (SELECT m.id from movies m where m.title=movieTitle);
	SET starID = (SELECT s.id from stars s where s.first_name=firstName and s.last_name=lastName);
	INSERT INTO stars_in_movies (star_id, movie_id) VALUES (starID, movieID);
	SET starMessage = "Successfully linked and added star";
END IF;

IF (genreName in (SELECT g.name from genres g)) THEN -- genre exist
	SET genreID = (SELECT g.id from genres g where g.name = genreName);
    SET movieID = (SELECT m.id from movies m where m.title=movieTitle);
	IF (not (SELECT gim.genre_id from genres_in_movies gim where gim.genre_id=genreID
	AND gim.movie_id=movieID)) THEN  -- genre not linked in genre_in_moveies 
		SET genreID = (SELECT g.id from genres g where g.name = genreName);
		SET movieID = (SELECT m.id from movies m where m.title=movieTitle);
		INSERT INTO genres_in_movies (genre_id, movie_id) VALUES (genreID, movieID);
		SET genreMessage = "Successfully linked genre and movie";
	ELSE
		SET genreMessage = "Genre exist and linked already";
	END IF;
ELSE -- genre doesn't exist
	INSERT INTO genres (name) VALUES (genreName);
	SET genreID = (SELECT g.id from genres g where g.name = genreName);
    SET movieID = (SELECT m.id from movies m where m.title=movieTitle);
	INSERT INTO genres_in_movies (genre_id, movie_id) VALUES (genreID, movieID);
    SET genreMessage = "Successfully linked and added genre";
END IF;

        
END
$$ 
DELIMITER ;
CALL add_movie("CS122E", 2000, "Jeff", "google.com", "google.com", "Davids", "Pham", NULL, "", "gamer", @movieMessage, @starMessage, @genreMessage);