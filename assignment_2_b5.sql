-- Active: 1747580400581@@127.0.0.1@5432@conservation_db
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(50) NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT,
    species_id INT,
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes TEXT,
    
    FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
    Foreign Key (species_id) REFERENCES species(species_id)
);

INSERT INTO rangers(name, region) VALUES 
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');


INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);

--* PostgreSQL Problems

INSERT INTO rangers(name, region) VALUES('Derek Fox', 'Coastal Plains');

SELECT COUNT(DISTINCT species_id) FROM sightings;

--* Find all sightings where the location includes "Pass".
SELECT * FROM sightings WHERE location LIKE '%Pass%';


--List each ranger's name and their total number of sightings.
SELECT r.name, COUNT(s.sighting_id) as total_sightings 
FROM sightings s
INNER JOIN rangers r ON r.ranger_id = s.ranger_id
GROUP BY r.name;

SELECT s.common_name 
 FROM species s 
 LEFT JOIN sightings r ON s.species_id = r.species_id
 WHERE r.species_id IS NULL;

SELECT sp.common_name, si.sighting_time, r.name 
 FROM sightings si
 INNER JOIN species sp ON sp.species_id = si.species_id
 INNER JOIN rangers r ON r.ranger_id = si.ranger_id
 ORDER BY sighting_time DESC LIMIT 2;

UPDATE species SET conservation_status = 'Historic'
 WHERE EXTRACT(year from discovery_date) < 1800;

SELECT sighting_id,
    CASE 
        WHEN EXTRACT(hour from sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(hour from sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
    FROM sightings;


SELECT r.name, s.location 
    FROM rangers r 
    INNER JOIN sightings s ON r.ranger_id = s.ranger_id;

ALTER TABLE sightings DROP CONSTRAINT sightings_ranger_id_fkey;

ALTER TABLE sightings 
    ADD CONSTRAINT sightings_ranger_id_fkey 
    FOREIGN KEY(ranger_id) REFERENCES rangers(ranger_id) 
    ON DELETE CASCADE;

DELETE FROM rangers r
    WHERE r.ranger_id NOT IN (
        SELECT DISTINCT s.ranger_id from sightings s
    );

    SELECT * FROM rangers;


    
