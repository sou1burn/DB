--Вставка нового значения
CREATE OR REPLACE FUNCTION insert_performance_with_genre(
    perf_title VARCHAR,
    perf_duration TIME,
    perf_age_category VARCHAR,
    perf_actors_count BIGINT,
    genre_name VARCHAR
)
RETURNS VOID AS $$
DECLARE
    genre_id BIGINT;
    performance_id BIGINT;
BEGIN
    SELECT id INTO genre_id FROM "Genre" WHERE name = genre_name;
    IF genre_id IS NULL THEN
        INSERT INTO "Genre" (name) VALUES (genre_name) RETURNING id INTO genre_id;
    END IF;

    INSERT INTO "Performance"(title, duration, age_category, "actorsCount")
    VALUES (perf_title, perf_duration, perf_age_category, perf_actors_count)
    RETURNING id INTO performance_id;

    INSERT INTO "Performance_Genre"(performance_id, genre_id)
    VALUES (performance_id, genre_id);
END;
$$ LANGUAGE plpgsql;

--Вставка нового значения через процедуру
-- CREATE OR REPLACE PROCEDURE insert_performance_with_genre_in_proc(
--     perf_title VARCHAR,
--     perf_duration TIME,
--     perf_age_category VARCHAR,
--     perf_actors_count BIGINT,
--     genre_name VARCHAR
-- )
-- LANGUAGE plpgsql AS $$
-- DECLARE
--     genre_id BIGINT;
--     performance_id BIGINT;
-- BEGIN
--     SELECT id INTO genre_id FROM "Genre" WHERE name = genre_name;
--     IF genre_id IS NULL THEN
--         INSERT INTO "Genre" (name) VALUES (genre_name) RETURNING id INTO genre_id;
--     END IF;

--     INSERT INTO "Performance"(title, duration, age_category, "actorsCount")
--     VALUES (perf_title, perf_duration, perf_age_category, perf_actors_count)
--     RETURNING id INTO performance_id;

--     INSERT INTO "Performance_Genre"(performance_id, genre_id)
--     VALUES (performance_id, genre_id);
-- END;
-- $$;

-- -- Процедура
-- CREATE OR REPLACE PROCEDURE insert_theater(theater_name varchar, theater_adress varchar)
-- LANGUAGE plpgsql AS $$
-- BEGIN
-- 	INSERT INTO "Theater" (name, address)
-- 	VALUES (theater_name, theater_adress);
-- END;
-- $$;

---Удаление значения 
CREATE OR REPLACE FUNCTION delete_performance_and_delete_genre_if_not_used(perfomance_id BIGINT)
RETURNS VOID AS $$
DECLARE 
	g_id BIGINT;
BEGIN
	FOR g_id IN (
        SELECT genre_id FROM "Performance_Genre" WHERE performance_id = $1
    )
	LOOP
        DELETE FROM "Performance" WHERE id = $1;
		IF NOT EXISTS 
			(SELECT 1 FROM "Performance_Genre" WHERE genre_id = g_id)
		THEN
			DELETE FROM "Genre" where id = g_id;
		END IF;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Процедура удаления
-- CREATE OR REPLACE PROCEDURE delete_performance_and_delete_genre_if_not_used_as_proc(perfomance_id BIGINT)
-- LANGUAGE plpgsql AS $$
-- DECLARE 
-- 	g_id BIGINT;
-- BEGIN
-- 	FOR g_id IN (
--         SELECT genre_id FROM "Performance_Genre" WHERE performance_id = performance_id
--     )
--     LOOP
--     END LOOP;
-- 	DELETE FROM "Performance" WHERE id = $1;
-- 	FOR g_id IN (
--         SELECT genre_id FROM "Performance_Genre" WHERE performance_id = performance_id
--     )
--     LOOP
--         IF NOT EXISTS (
--             SELECT 1 FROM "Performance_Genre" WHERE genre_id = g_id
--         ) THEN
--             DELETE FROM "Genre" WHERE id = g_id;
--         END IF;
--     END LOOP;
-- END;
-- $$;

-- --Процедура удаления
-- CREATE OR REPLACE PROCEDURE delete_theater(theater_name varchar, theater_adress varchar)
-- LANGUAGE plpgsql AS $$
-- BEGIN
-- 	DELETE FROM "Theater"
-- 	WHERE name = theater_name AND address = theater_adress;
-- END;
-- $$;

-- Подсчет значения агрегатной функции
-- DROP FUNCTION count_average_performances_in_theater(bigint)
CREATE OR REPLACE FUNCTION count_performances_in_theater(theater_id_param BIGINT)
RETURNS INT AS $$
DECLARE
    performance_count INT;
BEGIN
    SELECT COUNT(*) INTO performance_count
    FROM "Repertoire"
    WHERE theater_id = theater_id_param;

    RETURN performance_count;
END;
$$ LANGUAGE plpgsql;

--Формирование статистики во временной таблице
-- DROP FUNCTION generate_theater_statistics;
CREATE OR REPLACE FUNCTION generate_theater_statistics()
RETURNS TABLE(theater_id INT,
			theater_name VARCHAR,
			performance_count BIGINT,
			actors_count BIGINT,
			genres_count BIGINT,
			average_actors_per_performance NUMERIC) AS $$ 
BEGIN
		RETURN QUERY
		SELECT 
	        t.id,
	        t.name,
	        COUNT(DISTINCT r.performance_id),
	        COUNT(DISTINCT pa.actor_id),
	        COUNT(DISTINCT pg.genre_id),
	        ROUND(AVG(p."actorsCount"), 2)
		FROM "Theater" t
		LEFT JOIN "Repertoire" r ON t.id = r.theater_id
	    LEFT JOIN "Performance" p ON r.performance_id = p.id
	    LEFT JOIN "Performance_Actors" pa ON p.id = pa.performance_id
	    LEFT JOIN "Performance_Genre" pg ON p.id = pg.performance_id
	    GROUP BY t.id, t.name;
END;
$$ LANGUAGE plpgsql;

--Вставка
SELECT insert_performance_with_genre('Гамeлет12', '02:15:00', 'Взрослый', 7, 'Трагедия12');

CALL insert_performance_with_genre_in_proc('Тишина12121SS', '01:30:00', 'Взрослый', 9, 'Трагедия');

SELECT p.id, p.title, g.name
FROM "Performance" p 
JOIN "Performance_Genre" pg on p.id = pg.performance_id
JOIN "Genre" g on g.id = pg.genre_id
GROUP BY p.id, p.title, g.name

SELECT * FROM "Genre"

--Удаление
SELECT delete_performance_and_delete_genre_if_not_used(18);

CALL delete_performance_and_delete_genre_if_not_used_as_proc(5);

SELECT EXISTS (SELECT 1 FROM "Performance" WHERE id = 18) AS performance_exists;

SELECT g.id, g.name
FROM "Genre" g
LEFT JOIN "Performance_Genre" pg ON g.id = pg.genre_id
WHERE pg.genre_id IS NULL;

-- Подсчет значения агрегатной функции
SELECT count_performances_in_theater(1);

SELECT COUNT(*)
    FROM "Repertoire"
    WHERE theater_id = 1;

--Формирование статистики во временной таблице
SELECT * FROM generate_theater_statistics();

-- Процедура
SELECT * FROM "Theater"
call insert_theater('Драматический театр', 'Вологда, ул. Герцена 27');


