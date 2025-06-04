-- INSERT INTO "Theater" ("name", "adress", "category") VALUES
-- ('Большой театр', 'Москва, Театральная площадь, 1', 'Драматический театр'),
-- ('Театр на Таганке', 'Москва, Земляной Вал, 76/21', 'Театр комедии'),
-- ('Мариинский театр', 'Санкт-Петербург, Театральная площадь, 1', 'Музыкальный театр'),
-- ('Театр Кукол', 'Екатеринбург, Ленина, 40', 'Кукольный театр');


-- SELECT column_name, data_type
-- FROM information_schema.columns
-- WHERE table_name = 'Director';
-- TRUNCATE TABLE "Theater" RESTART IDENTITY CASCADE;

-- TRUNCATE TABLE "Theater" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Director" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Actor" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Genre" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Performance" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Author" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Repertoire" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Performance_Actors" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Director_Performance" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Author_Performance" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Performance_Genre" RESTART IDENTITY CASCADE;
-- TRUNCATE TABLE "Theater_Director" RESTART IDENTITY CASCADE;
-- добавить директора театру, добавить спектакль и уволить актера



INSERT INTO "Theater" ("name", "address", "category") VALUES
('Большой театр', 'Москва, Театральная пл., 1', 'Драматический театр'),
('Александринский театр', 'Санкт-Петербург, пл. Островского, 6', 'Театр комедии'),
('Мариинский театр', 'Санкт-Петербург, Театральная пл., 1', 'Музыкальный театр'),
('Театр кукол Образцова', 'Москва, Садовая-Самотёчная ул., 3', 'Кукольный театр');

INSERT INTO "Director" ("name") VALUES
('Константин Станиславский'),
('Лев Додин'),
('Кирилл Серебренников'),
('Андрей Могучий');

INSERT INTO "Actor" ("name", "experience") VALUES
('Сергей Безруков', 20),
('Чулпан Хаматова', 18),
('Константин Хабенский', 22),
('Елизавета Боярская', 15);

INSERT INTO "Genre" ("name") VALUES
('Трагедия'),
('Комедия'),
('Драма'),
('Мюзикл');

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") VALUES
('Гамлет', '02:30:00', 10, 'Взрослый'),
('Ревизор', '02:00:00', 12, 'Подростковый'),
('Щелкунчик', '01:45:00', 8, 'Детский'),
('Чайка', '02:20:00', 10, 'Взрослый');

INSERT INTO "Author" ("name") VALUES
('Уильям Шекспир'),
('Николай Гоголь'),
('Петр Чайковский'),
('Антон Чехов');

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") VALUES
(1, 1, '2024-03-15'),
(2, 2, '2024-04-10'),
(3, 3, '2024-05-20'),
(4, 1, '2024-06-05'),
(4, 2, '2025-09-15'),
(4, 3, '2026-12-12');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 1), (3, 3),
(4, 2), (4, 4);

INSERT INTO "Director_Performance" ("director_id", "performance_id") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO "Author_Performance" ("author_id", "performance_id") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO "Performance_Genre" ("performance_id", "genre_id") VALUES
(1, 1),
(2, 2),
(3, 4),
(4, 3);

INSERT INTO "Theater_Director" ("theater_id", "director_id") VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") VALUES
('Кроткая', '02:15:00', 1, 'Взрослый');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") VALUES
(5, 1);

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Три сестры', '02:45:00', 6, 'Взрослый');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") VALUES 
(6, 1);

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (6, 1, '2024-07-01'), 
       (6, 2, '2024-07-05');

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (6, 4, '2024-07-10');

INSERT INTO "Performance_Genre" ("performance_id", "genre_id") 
VALUES (3, 2), (6, 3); 

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (6, 2, '2024-08-10');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") 
VALUES (6, 2), (6, 3), (6, 4);

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Одинокий голос человека', '01:30:00', 1, 'Взрослый');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") 
VALUES (7, 3);

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Веселый солдат', '02:10:00', 5, 'Подростковый');

INSERT INTO "Performance_Genre" ("performance_id", "genre_id") 
VALUES (8, 2); 

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (8, 1, '2024-09-15');

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") 
VALUES (8, 4);

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Русская народная сказка', '01:20:00', 3, 'Детский');

INSERT INTO "Genre" ("name") VALUES ('Балет');

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Лебединое озеро', '02:40:00', 20, 'Взрослый');

INSERT INTO "Performance_Genre" ("performance_id", "genre_id") 
VALUES (10, 5);

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (10, 3, '2024-12-31');

INSERT INTO "Actor" ("name", "experience") VALUES
('Иван Иванов', 10);

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") VALUES
(5, (SELECT id FROM "Actor" WHERE name = 'Иван Иванов' LIMIT 1));

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (5, 4, '2024-07-01');

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date")
VALUES (9, 3, '2021-09-12'), (7, 1, '2023-02-12');

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES 
(1, 1, '2024-08-01'),  
(2, 1, '2024-08-05'), 
(4, 1, '2024-08-10'),  
(3, 1, '2024-08-15'), 
(10, 1, '2024-08-20');

SELECT * FROM "Performance_Genre"

SELECT * FROM "Performance"

SELECT * FROM "Actor"

UPDATE "Actor" SET surname = 'Чулпан хаматов' WHERE id = 2 
SELECT * FROM "Actor"
DELETE FROM "Actor" WHERE id = 2
INSERT INTO "Actor" ("name", "experience") VALUES
('Чулпан Хаматова', 18)

SELECT p.id, p.title 
FROM "Performance" p
LEFT JOIN "Repertoire" r ON p.id = r.performance_id
WHERE r.performance_id IS NULL;


SELECT * FROM "Theater"

INSERT INTO "Actor" ("name", "experience") 
VALUES ('Алексей Смирнов', 5)
RETURNING id;

INSERT INTO "Performance" ("title", "duration", "actorsCount", "age_category") 
VALUES ('Новый спектакль', '01:50:00', 1, 'Взрослый')
RETURNING id;

INSERT INTO "Performance_Actors" ("performance_id", "actor_id") 
VALUES (13, 8);

INSERT INTO "Repertoire" ("performance_id", "theater_id", "date") 
VALUES (13, 4, '2025-10-01');

INSERT INTO "Theater" ("name", "address") VALUES
('Театр юного зрителя', 'Вологда, улица Мира, 29');


