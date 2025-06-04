--check transactions
--before insert
SELECT * FROM "Repertoire";

INSERT INTO "Repertoire"(theater_id, performance_id, date)
VALUES (1, 2, '2024-04-10');

BEGIN;
INSERT INTO "Repertoire"(theater_id, performance_id, date)
VALUES (1, 2, '2024-04-10');

SELECT * FROM "Repertoire";

ROLLBACK;

--before update
BEGIN;

UPDATE "Repertoire"
SET theater_id = 3
WHERE id = 4;

ROLLBACK;

BEGIN;

UPDATE "Repertoire"
SET theater_id = 2
WHERE id = 6;

SELECT * FROM "Repertoire";
ROLLBACK;

--after delete
BEGIN;

SELECT * FROM "Performance_Actors";

SELECT * FROM "Repertoire";

DELETE FROM "Repertoire" WHERE performance_id = 13;

SELECT * FROM "Performance_Actors";

SELECT * FROM "Repertoire";

ROLLBACK;

--calc
BEGIN;

INSERT INTO "Performance_Actors"(performance_id, actor_id)
VALUES (4, 7);

SELECT id, title, "actorsCount" FROM "Performance" WHERE id = 4;

SELECT * FROM "Performance_History";

ROLLBACK;

--explicit log
BEGIN;

INSERT INTO "Performance"(title, age_category, duration, "actorsCount")
VALUES ('Новинка', 'Взрослый', '03:00:00', 2);

SELECT * FROM "Performance_History";
SELECT * FROM "Performance";

ROLLBACK;




