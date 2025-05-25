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

