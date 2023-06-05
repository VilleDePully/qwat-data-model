-- View: qwat_ch_vd_sire.regulation_pression

-- DROP VIEW qwat_ch_vd_sire.regulation_pression;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.regulation_pression
  AS
  SELECT element.id AS id_num,
    element.qwat_ext_ch_vd_sire_remarque || element.remark AS remarque,
    precision.code_sire AS precision_geo,
    distributor.name AS nom_distributeur,
    distributor.id AS id_distributeur,
    element.qwat_ext_ch_vd_sire_etat_exploitation AS etat_exploitation,
    element.year AS annee_construction,
    NULL::text AS nom_descriptif,
    folder.identification AS numero_dossier,
    pressurezone.name AS nom_zone_pression,
    pressurezone.id AS id_zone_pression,
    watertype.code_sire AS type_eau,
      CASE
        WHEN pump.id IS NOT NULL THEN 2
        ELSE 0
      END AS genre,
    element.altitude,
    1 AS etat_connexion,
    NULL::text AS id_distributeur_2,
    NULL::text AS id_zone_pression_2,
    0 AS type_regulation,
    NULL::text AS valeur_consigne_reg,
    2 AS telecommande_incendie,
    0 AS centrale_telecommande,
    element.qwat_ext_ch_vd_sire_adesafecter AS a_desaffecter_pdde,
    element.pully_fk_chantier,
    st_force2d(node.geometry) AS geometry
  FROM qwat_od.installation installation
    JOIN qwat_od.network_element element ON installation.id = element.id
    JOIN qwat_od.node node ON element.id = node.id
    LEFT JOIN qwat_od.pump pump ON installation.id = pump.id
    LEFT JOIN qwat_vl."precision" "precision" ON element.fk_precision = "precision".id
    LEFT JOIN qwat_od.distributor distributor ON element.fk_distributor = distributor.id
    LEFT JOIN qwat_od.folder folder ON element.fk_folder = folder.id
    LEFT JOIN qwat_od.pressurezone pressurezone ON node.fk_pressurezone = pressurezone.id
    LEFT JOIN qwat_vl.watertype watertype ON installation.fk_watertype = watertype.id
    LEFT JOIN qwat_od.pressurecontrol pressurecontrol ON installation.id = pressurecontrol.id
  WHERE pressurecontrol.fk_pressurecontrol_type = ANY (ARRAY[2801, 2802])
UNION
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
    1 AS genre,
    valve.altitude,
    1 AS etat_connexion,
    NULL::text AS id_distributeur_2,
    NULL::text AS id_zone_pression_2,
    0 AS type_regulation,
    NULL::text AS valeur_consigne_reg,
    2 AS telecommande_incendie,
    0 AS centrale_telecommande,
    valve.qwat_ext_ch_vd_sire_adesafecter AS a_desaffecter_pdde,
    valve.pully_fk_chantier,
    st_force2d(valve.geometry) AS geometry
  FROM qwat_od.valve
    LEFT JOIN qwat_vl."precision" "precision" ON valve.fk_precision = "precision".id
    LEFT JOIN qwat_od.distributor distributor ON valve.fk_distributor = distributor.id
    LEFT JOIN qwat_od.folder folder ON valve.fk_folder = folder.id
    LEFT JOIN qwat_od.pressurezone pressurezone ON valve.fk_pressurezone = pressurezone.id
  WHERE valve.fk_valve_function = 6101;

ALTER TABLE qwat_ch_vd_sire.regulation_pression
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.regulation_pression TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.regulation_pression TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.regulation_pression TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.regulation_pression TO qwat_viewer;

