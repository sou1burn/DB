--before insert
CREATE OR REPLACE FUNCTION check_duplicate_in_repertoire()
RETURNS TRIGGER AS $$
BEGIN
	IF EXISTS(SELECT 1 FROM "Repertoire" 
				WHERE theater_id = NEW.theater_id 
				AND performance_id = NEW.performance_id
				AND date = NEW.date)
		THEN 
			RAISE EXCEPTION 'Найден дупликат в базе';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_insert_reperoire
BEFORE INSERT ON "Repertoire"
FOR EACH ROW EXECUTE FUNCTION check_duplicate_in_repertoire();

--before update
CREATE OR REPLACE FUNCTION restrict_theater_change()
RETURNS TRIGGER AS $$
BEGIN
	IF OLD.theater_id != NEW.theater_id AND OLD.date < CURRENT_DATE
	THEN
		RAISE EXCEPTION 'Нельзя изменить дату у прошедшей постановки';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_before_update_repertoire
BEFORE UPDATE ON "Repertoire"
FOR EACH ROW EXECUTE FUNCTION restrict_theater_change();


--after delete
CREATE OR REPLACE FUNCTION delete_related_actors()
RETURNS TRIGGER AS $$
BEGIN
	DELETE FROM "Performance_Actors" WHERE performance_id = OLD.performance_id;
	RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_after_delete_repertoire
AFTER DELETE ON "Repertoire"
FOR EACH ROW EXECUTE FUNCTION delete_related_actors();

--calc
CREATE OR REPLACE FUNCTION update_actors_count()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE "Performance"
	SET "actorsCount" = (SELECT COUNT(*) FROM "Performance_Actors" WHERE performance_id = NEW.performance_id)
	WHERE id = NEW.performance_id;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_after_insert_actor
AFTER INSERT ON "Performance_Actors"
FOR EACH ROW EXECUTE FUNCTION update_actors_count();

CREATE TRIGGER trg_after_delete_actor
AFTER DELETE ON "Performance_Actors"
FOR EACH ROW EXECUTE FUNCTION update_actors_count();

CREATE OR REPLACE TRIGGER trg_after_update_actor
AFTER UPDATE ON "Performance_Actors"
FOR EACH ROW EXECUTE FUNCTION update_actors_count();

--change history
CREATE TABLE "Performance_History" (
  id SERIAL PRIMARY KEY,
  performance_id INT,
  title TEXT,
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  operation TEXT CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE OR REPLACE FUNCTION log_performance_history()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'UPDATE'
		THEN 
			INSERT INTO "Performance_History" (performance_id, title, operation)
			VALUES(NEW.id, NEW.title, 'UPDATE');
			RETURN NEW;
	ELSIF TG_OP = 'INSERT'
		THEN 
			INSERT INTO "Performance_History" (performance_id, title, operation)
			VALUES(NEW.id, NEW.title, 'INSERT');
			RETURN NEW;
	ELSIF TG_OP = 'DELETE'
		THEN 
			INSERT INTO "Performance_History" (performance_id, title, operation)
			VALUES(OLD.id, OLD.title, 'DELETE');
			RETURN OLD;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_insert_performance
AFTER INSERT ON "Performance"
FOR EACH ROW EXECUTE FUNCTION log_performance_history();

CREATE TRIGGER trg_update_performance
AFTER UPDATE ON "Performance"
FOR EACH ROW EXECUTE FUNCTION log_performance_history();

CREATE TRIGGER trg_delete_performance
AFTER DELETE ON "Performance"
FOR EACH ROW EXECUTE FUNCTION log_performance_history();

