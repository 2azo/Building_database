--make any number which is not given, a default value of 0

CREATE TABLE project
(
project_name VARCHAR(30) NOT NULL PRIMARY KEY,
notes VARCHAR
);

CREATE TABLE experiment(
experiment_name VARCHAR NOT NULL,
project_name VARCHAR REFERENCES project(project_name),
experiment_date DATE NOT NULL,
required_mass_g Double Precision NOT NULL,
required_solid_contents_percentage Double Precision NOT NULL,
mixing_tool VARCHAR(30),
mixer VARCHAR(30),
primary key (experiment_name, project_name)
);

CREATE TABLE measurement_step(
measurement_step_number SMALLINT NOT NULL PRIMARY KEY,
experiment_name VARCHAR ,
project_name VARCHAR ,
viscosity_high_1_over_s Double Precision,
viscosity_low_1000_over_s Double Precision,
grindometer_mu_m Double Precision,
solid_contents_percentage Double Precision,
temperature_celsius Double Precision,
notes VARCHAR,
FOREIGN KEY (experiment_name,project_name) REFERENCES experiment(experiment_name,project_name)
);


CREATE TABLE processing_step(
processing_step_number SMALLINT NOT NULL PRIMARY KEY,
experiment_name VARCHAR,
project_name VARCHAR,
measurement_step_number SMALLINT REFERENCES measurement_step(measurement_step_number),
description VARCHAR,
mixing_speed_1_rpm SMALLINT,
mixing_speed_2_rpm SMALLINT,
mixing_time_minutes DOUBLE PRECISION,
sieve_size_mu_m DOUBLE PRECISION,
partial_pressure_mbar DOUBLE PRECISION,
notes VARCHAR,
FOREIGN KEY (experiment_name,project_name) REFERENCES experiments(experiment_name,project_name)
);


CREATE TABLE material_addition_step
(
material_addition_step_number SMALLINT NOT NULL,
experiment_name VARCHAR NOT NULL,
project_name VARCHAR NOT NULL,
processing_step_number SMALLINT REFERENCES processing_step(processing_step_number),
slurry_material_id SMALLINT, -- add REFERENCES slurry_material(slurry_material_id) after creating slurry material table
material_mass_g SMALLINT -- REFERENCES measurement_step(measurement_step_number) -- most likely a mistake 
primary key (material_addition_step_number, experiment_name, project_name)
);


CREATE TABLE slurry_material(
slurry_material_id SMALLINT NOT NULL PRIMARY KEY,
experiment_name VARCHARNOT NOT NULL,
project_name VARCHARNOT NOT NULL,
material_addition_step_number SMALLINT REFERENCES material_addition_step(material_addition_step_number),
material_name VARCHAR NOT NULL,
percentage DOUBLE PRECISION,
density_gram_over_cupic_cm DOUBLE PRECISION,
material_function VARCHAR,
material_type VARCHAR,
concentration_percentage DOUBLE PRECISION,
solved_in SMALLINT REFERENCES slurry_material(slurry_material_id)
primary key (slurry_material_id, experiment_name, project_name)
);


-- ALTER TABLE material_addition_step
-- ADD CONSTRAINT adding_foreign_key_in_material_addition_step
-- FOREIGN KEY (slurry_material_id)
-- REFERENCES slurry_material (slurry_material_id);