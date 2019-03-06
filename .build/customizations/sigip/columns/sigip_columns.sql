--Ajout de l'identifiant de chantier

ALTER TABLE qwat_od.network_element ADD COLUMN pully_fk_chantier integer;
COMMENT ON COLUMN qwat_od.network_element.pully_fk_chantier IS 'Identifiant de chantier';

ALTER TABLE qwat_od.valve ADD COLUMN pully_fk_chantier integer;
COMMENT ON COLUMN qwat_od.valve.pully_fk_chantier IS 'Identifiant de chantier';

ALTER TABLE qwat_od.pipe ADD COLUMN pully_fk_chantier integer;
COMMENT ON COLUMN qwat_od.pipe.pully_fk_chantier IS 'Identifiant de chantier';

--Ajout de l'identifiant topobase

ALTER TABLE qwat_od.network_element ADD COLUMN pully_id_topobase integer;
COMMENT ON COLUMN qwat_od.network_element.pully_id_topobase IS 'Identifiant Topobase';

ALTER TABLE qwat_od.valve ADD COLUMN pully_id_topobase integer;
COMMENT ON COLUMN qwat_od.valve.pully_id_topobase IS 'Identifiant Topobase';

ALTER TABLE qwat_od.pipe ADD COLUMN pully_id_topobase integer;
COMMENT ON COLUMN qwat_od.pipe.pully_id_topobase IS 'Identifiant Topobase';
