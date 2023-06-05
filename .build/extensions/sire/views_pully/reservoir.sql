-- View: qwat_ch_vd_sire.reservoir

-- DROP VIEW qwat_ch_vd_sire.reservoir;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.reservoir
 AS
 SELECT element.id AS id_num,
    element.qwat_ext_ch_vd_sire_remarque || element.remark AS remarque,
    precision.code_sire AS precision_geo,
    distributor.name AS nom_distributeur,
    distributor.id AS id_distributeur,
    element.qwat_ext_ch_vd_sire_etat_exploitation AS etat_exploitation,
    element.year AS annee_construction,
    installation.name AS nom_descriptif,
    folder.identification AS numero_dossier,
    pressurezone.name AS nom_zone_pression,
    pressurezone.id AS id_zone_pression,
    watertype.code_sire AS type_eau,
    tank.storage_total AS capacite_stockage,
    tank.storage_supply AS reserve_alimentation,
    tank.storage_fire AS reserve_incendie,
        CASE
            WHEN tank.cistern1_dimension_1 > 0::numeric THEN 1
            ELSE 0
        END +
        CASE
            WHEN tank.cistern2_dimension_1 > 0::numeric THEN 1
            ELSE 0
        END AS nombre_cuves,
    tank.altitude_overflow AS altitude_trop_plein,
    tank.altitude_apron AS altitude_radier,
        CASE
            WHEN tank.fire_valve IS TRUE THEN 1
            ELSE 0
        END AS vanne_incendie,
        CASE
            WHEN tank.fire_remote IS TRUE THEN 1
            ELSE 0
        END AS telecommande_incendie,
    0 AS centrale_telecommande,
    element.qwat_ext_ch_vd_sire_adesafecter AS a_desaffecter_pdde,
    element.pully_fk_chantier,
    st_force2d(node.geometry) AS geometry
   FROM qwat_od.installation installation
    JOIN qwat_od.network_element element ON installation.id = element.id
    JOIN qwat_od.node node ON element.id = node.id
    LEFT JOIN qwat_vl."precision" "precision" ON element.fk_precision = "precision".id
    LEFT JOIN qwat_od.distributor distributor ON distributor.id = ANY (node.fk_distributor)
    LEFT JOIN qwat_od.folder folder ON element.fk_folder = folder.id
    LEFT JOIN qwat_od.pressurezone pressurezone ON pressurezone.id = ANY (node.fk_pressurezone)
    LEFT JOIN qwat_vl.watertype watertype ON installation.fk_watertype = watertype.id
    LEFT JOIN qwat_od.tank tank ON installation.id = tank.id
  WHERE tank.id is not NULL;

ALTER TABLE qwat_ch_vd_sire.reservoir
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.reservoir TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.reservoir TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.reservoir TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.reservoir TO qwat_viewer;

