-- 1) спектакли жанра драма;
SELECT p.id, p.title 
FROM "Performance" p 
JOIN "Performance_Genre" pg on p.id = pg.performance_id
JOIN "Genre" g on pg.genre_id = g.id
WHERE g.name = 'Драма';

-- 2) спектакли, в которых занят заданный актер;
SELECT p.id, p.title, a.name
FROM "Performance" p
JOIN "Performance_Actors" pa on p.id = pa.performance_id
JOIN "Actor" a on pa.actor_id = a.id
WHERE a.id = 3;

-- 3) спектакли, идущие более чем в одном театре;
SELECT r.performance_id, p.title, COUNT(DISTINCT r.theater_id) AS theater_count
FROM "Repertoire" r
JOIN "Performance" p on r.performance_id = p.id
GROUP BY r.performance_id, p.title
HAVING COUNT(DISTINCT r.theater_id) > 1;

-- 4) количество спектаклей для каждого из театров;
SELECT t.id, t.name, COUNT(r.performance_id) as perf_cnt
FROM "Theater" t
LEFT JOIN "Repertoire" r ON t.id =r.theater_id
GROUP BY t.id, t.name;

-- 5) театры, в которых количество драм превышает число комедий;
SELECT t.id, t.name
FROM "Theater" t
JOIN "Repertoire" r on t.id = r.theater_id
JOIN "Performance_Genre" pg on r.performance_id = pg.performance_id
JOIN "Genre" g on g.id = pg.genre_id
GROUP BY t.id, t.name
HAVING SUM(CASE WHEN g.name = 'Драма' THEN 1 ELSE 0 END) >
		SUM(CASE WHEN g.name = 'Комедия' THEN 1 ELSE 0 END);

-- 6) спектакли, в которых занято наибольшее число актеров;
SELECT p.id, p.title, COUNT(pa.actor_id) AS actor_count
FROM "Performance" p
JOIN "Performance_Actors" pa on p.id = pa.performance_id
GROUP BY p.id, p.title
ORDER BY actor_count DESC
LIMIT 3;

-- 7) спектакли одного актера;
SELECT p.id, p.title, a.name
FROM "Performance" p
JOIN "Performance_Actors" pa on p.id = pa.performance_id
JOIN "Actor" a on pa.actor_id = a.id
GROUP BY p.id, p.title, a.name
HAVING COUNT(pa.actor_id) = 1;

-- 8) театры, в которых идут спектакли всех жанров;
SELECT t.id, t.name
FROM "Theater" t
JOIN "Repertoire" r on r.theater_id = t.id
JOIN "Performance_Genre" pg on r.performance_id = pg.performance_id
JOIN "Genre" g on g.id = pg.genre_id
GROUP BY t.id, t.name
HAVING COUNT(DISTINCT g.id) = (SELECT COUNT(*) FROM "Genre");

-- 9) актеров, занятых только в одном театре;
SELECT a.id, a.name
FROM "Actor" a
JOIN "Performance_Actors" pa on a.id = pa.actor_id
JOIN "Repertoire" r on pa.performance_id = r.performance_id
GROUP BY a.id, a.name
HAVING COUNT(DISTINCT r.theater_id) = 1;

-- 10) спектакли, указав их категорию в зависимости от возраста зрителей – для  детей, для подростков, для взрослых;
SELECT id, title,
	CASE 
		WHEN age_category = 'Детский' THEN 'Для детей'
		WHEN age_category = 'Подростковый' THEN 'Для подростков'
		WHEN age_category = 'Взрослый' THEN 'Для взрослых'
	END AS audience_category
FROM "Performance";

-- 11) спектакли с указанием авторов; при отсутствии данных об авторе указать «Народная сказка»;
SELECT p.id, p.title, COALESCE(a.name, 'Народная сказка') AS author
FROM "Performance" p
LEFT JOIN "Author_Performance" ap on ap.performance_id = p.id
LEFT JOIN "Author" a on a.id = ap.author_id

-- 12) театры, указав их категорию в зависимости от жанра спектаклей - «Драматический театр», «Театр комедии», «Музыкальный театр», «Кукольный театр».
SELECT t.id, t.name,
	  CASE
		   WHEN SUM(CASE WHEN g.name = 'Драма' THEN 1 ELSE 0 END) > 
                SUM(CASE WHEN g.name = 'Комедия' THEN 1 ELSE 0 END)  THEN 'Драматический театр'
           WHEN SUM(CASE WHEN g.name = 'Комедия' THEN 1 ELSE 0 END) > 
                SUM(CASE WHEN g.name = 'Драма' THEN 1 ELSE 0 END) THEN 'Театр комедии'
           WHEN SUM(CASE WHEN g.name = 'Опера' OR g.name = 'Балет' OR g.name = 'Мюзикл' THEN 1 ELSE 0 END) > 0 THEN 'Музыкальный театр'
           WHEN SUM(CASE WHEN g.name = 'Кукольный театр' THEN 1 ELSE 0 END) > 0 THEN 'Кукольный театр'
           ELSE 'Разные жанры'
     END AS theater_category
FROM "Theater" t 
JOIN "Repertoire" r on r.theater_id = t.id
JOIN "Performance_Genre" pg on pg.performance_id = r.performance_id 
JOIN "Genre" g on g.id = pg.genre_id
GROUP BY t.id, t.name;

---Дополнительные запросы
-- IN
SELECT p.id, p.title
FROM "Performance" p
JOIN "Performance_Genre" pg ON p.id = pg.performance_id
JOIN "Genre" g ON g.id = pg.genre_id
WHERE g.name IN ('Драма', 'Комедия');

--BETWEEN
SELECT id, title
FROM "Performance" 
WHERE "actorsCount" BETWEEN 2 AND 4;

--IS NULL
SELECT id, name
FROM "Theater"
WHERE category IS NULL;

--LIKE
SELECT id, name
FROM "Theater"
WHERE name LIKE '%Большой театр%';

---AVG
SELECT AVG(perf_cnt) AS avg_performance_count
FROM (
    SELECT COUNT(r.performance_id) AS perf_cnt
    FROM "Theater" t
    LEFT JOIN "Repertoire" r ON t.id = r.theater_id
    GROUP BY t.id
) AS subquery;

--MAX
SELECT MAX(perf_cnt) AS max_performance_count
FROM (
    SELECT COUNT(r.performance_id) AS perf_cnt
    FROM "Theater" t
    LEFT JOIN "Repertoire" r ON t.id = r.theater_id
    GROUP BY t.id
) AS subquery;

-- WITH all_genres AS (
--     SELECT id AS genre_id, name AS genre_name 
--     FROM "Genre"
-- ),
-- theater_genres AS (
--     SELECT 
--         t.id AS theater_id,
--         t.name AS theater_name,
--         pg.genre_id
--     FROM "Theater" t
--     LEFT JOIN "Repertoire" r ON t.id = r.theater_id
--     LEFT JOIN "Performance_Genre" pg ON r.performance_id = pg.performance_id
--     GROUP BY t.id, t.name, pg.genre_id
-- )

-- SELECT 
--     tg.theater_id,
--     tg.theater_name,
--     ag.genre_id AS missing_genre_id,
--     ag.genre_name AS missing_genre_name
-- FROM theater_genres tg
-- CROSS JOIN all_genres ag
-- WHERE NOT EXISTS (
--     SELECT 1 
--     FROM theater_genres tg2 
--     WHERE 
--         tg2.theater_id = tg.theater_id 
--         AND tg2.genre_id = ag.genre_id
-- )
-- ORDER BY tg.theater_id, ag.genre_id;
