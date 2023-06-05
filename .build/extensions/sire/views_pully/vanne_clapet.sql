-- View: qwat_ch_vd_sire.vanne_clapet

-- DROP VIEW qwat_ch_vd_sire.vanne_clapet;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.vanne_clapet
 AS
  SELECT valve.id AS id_num,
    valve.qwat_ext_ch_vd_sire_remarque || valve.remark AS remarque,
    precision.code_sire AS precision_geo,
    distributor.name AS nom_distributeur,
    distributor.id AS id_distributeur,
    valve.qwat_ext_ch_vd_sire_etat_exploitation AS etat_exploitation,
    valve.year AS annee_construction,
    NULL::text AS nom_descriptif,
    folder.identification AS numero_dossier,
    pressurezone.name AS nom_zone_pression,
    pressurezone.id AS id_zone_pression,
    1 AS type_eau,
        CASE
            WHEN valve.fk_valve_function = 6107 THEN 0
            WHEN valve.fk_valve_type = 6307 THEN 3
            ELSE 1
        END AS genre,
        CASE
            WHEN valve.closed IS TRUE THEN 3
            WHEN valve.fk_valve_type = 6307 THEN 0
            WHEN valve.closed IS FALSE THEN 2
            ELSE 1
        END AS etat_connexion,
    valve.altitude,
    NULL::text AS id_distributeur_2,
    NULL::text AS id_zone_pression_2,
        CASE
            WHEN valve.fk_valve_function = 6107 AND valve.fk_valve_actuation = 6404 THEN 1
            ELSE 0
        END AS telecommande_incendie,
    6 AS type_transmission,
    valve.pully_fk_chantier,
    st_force2d(valve.geometry) AS geometry
  FROM qwat_od.valve
     LEFT JOIN qwat_vl."precision" "precision" ON valve.fk_precision = "precision".id
     LEFT JOIN qwat_od.distributor distributor ON valve.fk_distributor = distributor.id
     LEFT JOIN qwat_od.folder folder ON valve.fk_folder = folder.id
     LEFT JOIN qwat_od.pressurezone pressurezone ON valve.fk_pressurezone = pressurezone.id

  WHERE valve.networkseparation IS TRUE OR valve.fk_valve_function = 6107 OR valve.fk_valve_type = 6307;

ALTER TABLE qwat_ch_vd_sire.vanne_clapet
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.vanne_clapet TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.vanne_clapet TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.vanne_clapet TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.vanne_clapet TO qwat_viewer;

