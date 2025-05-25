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