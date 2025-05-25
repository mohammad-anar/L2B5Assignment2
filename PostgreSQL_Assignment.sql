-- Active: 1747572375367@@127.0.0.1@5432@b5_psql_cs

-- Create database named conservation_db;
CREATE DATABASE conservation_db;

-- creating table named rangers 
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT null,
    region VARCHAR(100) NOT NULL,
    email TEXT NOT NULL UNIQUE
);

-- cteating species table
CREATE Table species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50),
    discovery_date DATE NOT NULL DEFAULT now(),
    conservation_status VARCHAR(30) NOT NULL
);

-- create sightings table
CREATE Table sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INTEGER REFERENCES rangers(ranger_id),
    species_id INTEGER REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT null,
    location TEXT NOT null,
    notes TEXT
)

-- insert value on rangers table 
INSERT into rangers ( name, region, email) VALUES
('Alice Johnson', 'Yellowstone National Park', 'alice.johnson@nps.gov'),
('Brian Lee', 'Yosemite National Park', 'brian.lee@nps.gov'),
('Carla Mendes', 'Kruger National Park', 'carla.mendes@sanparks.org'),
('David Kim', 'Banff National Park', 'david.kim@parkscanada.ca'),
('Elena Petrova', 'Serengeti National Park', 'elena.petrova@tzparks.tz');

SELECT * FROM rangers;


-- insert value on sightings table 
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES 
('African Elephant', 'Loxodonta africana', '1990-06-12', 'Vulnerable'),
('Bald Eagle', 'Haliaeetus leucocephalus', '1985-03-24', 'Least Concern'),
('Snow Leopard', 'Panthera uncia', '2001-11-02', 'Endangered'),
('Mountain Gorilla', 'Gorilla beringei beringei', '1995-09-18', 'Critically Endangered'),
('Grizzly Bear', 'Ursus arctos horribilis', '1988-07-29', 'Least Concern');

SELECT * FROM species;


-- insert value on sightings table 
INSERT INTO sightings (ranger_id, species_id, sighting_time, location, notes) VALUES 
    (1, 3, '2024-04-12 07:10:00', 'North Ridge Path', 'Snow Leopard seen briefly at sunrise.'),
(2, 1, '2024-04-18 17:45:00', 'East River Bank', 'Elephant herd of 8 crossing river.'),
(3, 5, '2024-04-20 11:30:00', 'Snowfall Pass', 'Grizzly feeding on berries.'),
(4, 2, '2024-04-25 13:00:00', 'Eagle Nest Point', 'Pair circling overhead.'),
(5, 4, '2024-04-29 15:20:00', 'Jungle Sector C', 'One juvenile separated from group.'),
(1, 2, '2024-05-01 06:50:00', 'Hilltop Rocks', 'Bald eagle spotted perched.'),
(2, 4, '2024-05-02 12:05:00', 'Rainforest Basin', 'Gorilla tracks found nearby.'),
(3, 1, '2024-05-03 16:40:00', 'Savannah Tree Line', 'Young elephant playing.'),
(4, 5, '2024-05-06 18:00:00', 'Grizzly Hollow', 'Bear sighted before dusk.'),
(5, 3, '2024-05-08 09:25:00', 'Rocky Cliffs', 'Snow Leopard resting in shade.');

SELECT * from sightings;


-- ============================================Question start=============================================================

-- 1️⃣ Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains'

INSERT into rangers ( name, region, email) VALUES
('Derek Fox', 'Coastal Plains', 'derekfox@nps.gov');


-- 2️⃣ Count unique species ever sighted.

SELECT count(*) from (SELECT count(species_id ) as unique_species_count  FROM sightings 
    GROUP BY species_id); 




-- 3️⃣ Find all sightings where the location includes "Pass".

SELECT * from sightings WHERE location LIKE '%Pass%';




-- 4️⃣ List each ranger's name and their total number of sightings.

SELECT r.name as rangers_name, count(s.sighting_id) as total_sightings from sightings s 
    JOIN rangers r USING(ranger_id) 
        GROUP BY r.name;




-- 5️⃣ List species that have never been sighted.

SELECT common_name from sightings right JOIN species USING(species_id ) WHERE sightings.sighting_id IS NULL;




-- 6️⃣ Show the most recent 2 sightings. 

SELECT * FROM sightings ORDER BY sighting_time LIMIT 2;



-- 7️⃣ Update all species discovered before year 1800 to have status 'Historic'.

UPDATE species
    SET conservation_status = 'Historic'
    WHERE EXTRACT(year from discovery_date) < '1800';




-- 8️⃣ Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'.

    SELECT sighting_id, sighting_time,
        CASE 
            WHEN extract(HOUR from sighting_time) < 12 THEN  'Morning'
            WHEN extract(HOUR from sighting_time) >= 12 AND extract(HOUR from sighting_time) > 17 THEN 'Afternoon'
            ELSE  'Evening'
        END as time_of_day
        FROM sightings;




-- 9️⃣ Delete rangers who have never sighted any species

    DELETE FROM rangers 
        WHERE ranger_id = (SELECT ranger_id from sightings 
            RIGHT JOIN rangers USING(ranger_id) 
                WHERE sightings.ranger_id IS NULL);

