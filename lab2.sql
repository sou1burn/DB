-- DROP TABLE IF EXISTS "Repertoire" CASCADE;
-- DROP TABLE IF EXISTS "Performance_Actors" CASCADE;
-- DROP TABLE IF EXISTS "Director_Performance" CASCADE;
-- DROP TABLE IF EXISTS "Author_Performance" CASCADE;
-- DROP TABLE IF EXISTS "Performance_Genre" CASCADE;
-- DROP TABLE IF EXISTS "Theater_Director" CASCADE;
-- DROP TABLE IF EXISTS "Theater" CASCADE;
-- DROP TABLE IF EXISTS "Director" CASCADE;
-- DROP TABLE IF EXISTS "Actor" CASCADE;
-- DROP TABLE IF EXISTS "Genre" CASCADE;
-- DROP TABLE IF EXISTS "Performance" CASCADE;
-- DROP TABLE IF EXISTS "Author" CASCADE;

CREATE TABLE IF NOT EXISTS "Theater" (
    "id" serial PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "address" varchar(255) NOT NULL,
    "category" varchar(50) 
);
-- CHECK ("category" IN ('Драматический театр', 'Театр комедии', 'Музыкальный театр', 'Кукольный театр'))

CREATE TABLE IF NOT EXISTS "Director" (
    "id" serial PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Actor" (
    "id" serial PRIMARY KEY,
    "name" varchar(255) NOT NULL,
    "experience" bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS "Genre" (
    "id" serial PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Performance" (
    "id" serial PRIMARY KEY,
    "title" varchar(255) NOT NULL,
    "duration" time NOT NULL,
	"actorsCount" bigint NOT NULL,
    "age_category" VARCHAR(20) NOT NULL CHECK ("age_category" IN ('Детский', 'Подростковый', 'Взрослый'))
);

CREATE TABLE IF NOT EXISTS "Author" (
    "id" serial PRIMARY KEY,
    "name" varchar(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS "Repertoire" (
    "id" serial PRIMARY KEY,
    "performance_id" bigint NOT NULL,
    "theater_id" bigint NOT NULL,
    "date" DATE NOT NULL, 
    FOREIGN KEY ("performance_id") REFERENCES "Performance"("id") ON DELETE CASCADE,
    FOREIGN KEY ("theater_id") REFERENCES "Theater"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Performance_Actors" (
    "performance_id" bigint NOT NULL,
    "actor_id" bigint NOT NULL,
    PRIMARY KEY ("performance_id", "actor_id"),
    FOREIGN KEY ("performance_id") REFERENCES "Performance"("id") ON DELETE CASCADE,
    FOREIGN KEY ("actor_id") REFERENCES "Actor"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Director_Performance" (
    "director_id" bigint NOT NULL,
    "performance_id" bigint NOT NULL,
    PRIMARY KEY ("director_id", "performance_id"),
    FOREIGN KEY ("director_id") REFERENCES "Director"("id") ON DELETE CASCADE,
    FOREIGN KEY ("performance_id") REFERENCES "Performance"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Author_Performance" (
    "author_id" bigint NOT NULL,
    "performance_id" bigint NOT NULL,
    PRIMARY KEY ("author_id", "performance_id"),
    FOREIGN KEY ("author_id") REFERENCES "Author"("id") ON DELETE CASCADE,
    FOREIGN KEY ("performance_id") REFERENCES "Performance"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Performance_Genre" (
    "performance_id" bigint NOT NULL,
    "genre_id" bigint NOT NULL,
    PRIMARY KEY ("performance_id", "genre_id"),
    FOREIGN KEY ("performance_id") REFERENCES "Performance"("id") ON DELETE CASCADE,
    FOREIGN KEY ("genre_id") REFERENCES "Genre"("id") ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "Theater_Director" ( 
    "theater_id" bigint NOT NULL,
    "director_id" bigint NOT NULL,
    PRIMARY KEY ("theater_id", "director_id"),
    FOREIGN KEY ("theater_id") REFERENCES "Theater"("id") ON DELETE CASCADE,
    FOREIGN KEY ("director_id") REFERENCES "Director"("id") ON DELETE CASCADE
);

-- ALTER TABLE "Repertoire"
-- ADD CONSTRAINT "Repertoire_theater_id_fkey"
-- FOREIGN KEY ("theater_id") REFERENCES "Theater"("id") ON DELETE CASCADE;

-- ALTER TABLE "Theater_Director"
-- ADD CONSTRAINT "Theater_Director_theater_id_fkey"
-- FOREIGN KEY ("theater_id") REFERENCES "Theater"("id") ON DELETE CASCADE;

-- ALTER TABLE "Theater" 
-- ALTER COLUMN "category" TYPE varchar(50) 
-- USING "category"::varchar(50);

-- SELECT column_name, data_type 
-- FROM information_schema.columns 
-- WHERE table_name = 'Theater' AND column_name = 'category';

-- SELECT column_name, data_type 
-- FROM information_schema.columns 
-- WHERE table_name = 'Genre' AND column_name = 'id';

