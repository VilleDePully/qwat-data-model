/*
	qWat - QGIS Water Module

	SQL file :: installation tank
*/

/* CREATE TABLE */
CREATE TABLE qwat_od.installation_tank ();

/* specific to tanks */
ALTER TABLE qwat_od.installation_tank ADD COLUMN id NOT NULL REFERENCES qwat_od.installation(id) PRIMARY KEY ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN fk_overflow          integer             ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN fk_firestorage       integer             ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN storage_total        numeric(10,1)       ; COMMENT ON COLUMN qwat_od.installation_tank.storage_total  IS 'litres';
ALTER TABLE qwat_od.installation_tank ADD COLUMN storage_supply       numeric(10,1)       ; COMMENT ON COLUMN qwat_od.installation_tank.storage_supply IS 'litres';
ALTER TABLE qwat_od.installation_tank ADD COLUMN storage_fire         numeric(10,1)       ; COMMENT ON COLUMN qwat_od.installation_tank.storage_fire   IS 'litres';
ALTER TABLE qwat_od.installation_tank ADD COLUMN altitude_overflow    numeric(7,3)        ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN altitude_apron       numeric(7,3)        ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN height_max           numeric(7,3)        ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN fire_valve           boolean default NULL;
ALTER TABLE qwat_od.installation_tank ADD COLUMN fire_remote          boolean default NULL;
ALTER TABLE qwat_od.installation_tank ADD COLUMN _litrepercm          numeric(9,3)        ;

ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern1_fk_type     integer      ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern1_dimension_1 numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern1_dimension_2 numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern1_storage     numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN _cistern1_litrepercm numeric(9,3) ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern2_fk_type     integer      ;
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern2_dimension_1 numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern2_dimension_2 numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN cistern2_storage     numeric(10,2);
ALTER TABLE qwat_od.installation_tank ADD COLUMN _cistern2_litrepercm numeric(9,3) ;

/* Constraints */
ALTER TABLE qwat_od.installation_tank ADD CONSTRAINT installation_tank_fk_overflow     FOREIGN KEY (fk_overflow)      REFERENCES qwat_vl.overflow(id)              MATCH FULL; CREATE INDEX fki_installation_tank_fk_overflow     ON qwat_od.installation_tank(fk_overflow)     ;
ALTER TABLE qwat_od.installation_tank ADD CONSTRAINT installation_tank_fk_firestorage  FOREIGN KEY (fk_firestorage)   REFERENCES qwat_vl.tank_firestorage(id)      MATCH FULL; CREATE INDEX fki_installation_tank_fk_firestorage  ON qwat_od.installation_tank(fk_firestorage)  ;
ALTER TABLE qwat_od.installation_tank ADD CONSTRAINT installation_tank_cistern1type    FOREIGN KEY (cistern1_fk_type) REFERENCES qwat_vl.cistern(id)               MATCH FULL; CREATE INDEX fki_installation_tank_cistern1type    ON qwat_od.installation_tank(cistern1_fk_type);
ALTER TABLE qwat_od.installation_tank ADD CONSTRAINT installation_tank_cistern2type    FOREIGN KEY (cistern2_fk_type) REFERENCES qwat_vl.cistern(id)               MATCH FULL; CREATE INDEX fki_installation_tank_cistern2type    ON qwat_od.installation_tank(cistern2_fk_type);


/* Function */
CREATE OR REPLACE FUNCTION qwat_od.fn_litres_per_cm(fk_type integer,dim1 double precision, dim2 double precision) RETURNS double precision AS
$BODY$
	BEGIN
		IF fk_type = 1 THEN
			return pi()*(dim1/2)^2*10;
		ELSEIF fk_type = 2 THEN
			return dim2*dim2*10;
		ELSE
			return NULL;
		END IF;
	END
$BODY$
LANGUAGE plpgsql;
COMMENT ON FUNCTION qwat_od.fn_litres_per_cm(integer, double precision, double precision) IS 'Calculate the litres_per_cm of a tank cistern.';

/* Triggers */

CREATE OR REPLACE FUNCTION qwat_od.ft_installation_tank() RETURNS trigger AS
$BODY$
	BEGIN
		NEW._cistern1_litrepercm := qwat_od.fn_litres_per_cm(NEW.cistern1_fk_type,NEW.cistern1_dimension_1,NEW.cistern1_dimension_2);
		NEW._cistern2_litrepercm := qwat_od.fn_litres_per_cm(NEW.cistern2_fk_type,NEW.cistern2_dimension_1,NEW.cistern2_dimension_2);
		NEW._litrepercm := COALESCE(NEW._cistern1_litrepercm,0)+COALESCE(NEW._cistern2_litrepercm,0);
		RETURN NEW;
	END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER tr_installation
	BEFORE INSERT OR UPDATE OF cistern1_fk_type,cistern1_dimension_1,cistern1_dimension_2,
							   cistern2_fk_type,cistern2_dimension_1,cistern2_dimension_2
	ON qwat_od.installation_tank
	FOR EACH ROW
	EXECUTE PROCEDURE qwat_od.ft_installation_tank();



/* VIEW */
CREATE OR REPLACE VIEW qwat_od.vw_installation_tank_fr AS
SELECT
	installation_tank.*,
	status.value_fr AS status,
	status.active AS active,
	distributor.name AS distributor,
	remote_type.value_fr AS remote,
	watertype.value_fr AS watertype,
	overflow.value_fr AS overflow,
	tank_firestorage.value_fr AS firestorage,
	cis1.value_fr AS cistern1,
	cis2.value_fr AS cistern2
	FROM qwat_od.installation_tank
	INNER JOIN      qwat_vl.status           ON status.id           = installation_tank.fk_status
	INNER JOIN      qwat_od.distributor      ON distributor.id      = installation_tank.fk_distributor
	LEFT OUTER JOIN qwat_vl.remote_type     ON remote_type.id       = installation_tank.fk_remote
	INNER JOIN      qwat_vl.watertype        ON watertype.id        = installation_tank.fk_watertype
	LEFT OUTER JOIN qwat_vl.overflow         ON overflow.id         = installation_tank.fk_overflow    
	LEFT OUTER JOIN qwat_vl.tank_firestorage ON tank_firestorage.id = installation_tank.fk_firestorage
	LEFT OUTER JOIN qwat_vl.cistern    cis1  ON cis1.id          = installation_tank.cistern1_fk_type
	LEFT OUTER JOIN qwat_vl.cistern    cis2  ON cis2.id          = installation_tank.cistern2_fk_type;

