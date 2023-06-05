-- View: qwat_ch_vd_sire.station_pompage

-- DROP VIEW qwat_ch_vd_sire.station_pompage;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.station_pompage
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
    pump_type.code_sire AS genre,
    element.altitude,
    pump.rejected_flow AS q_max_refoule,
    pump.no_pumps AS nombre_pompes,
    pump.manometric_height AS h_manometrique,
    pump_operating.code_sire AS fonctionnement,
    element.qwat_ext_ch_vd_sire_adesafecter AS a_desaffecter_pdde,
    element.pully_fk_chantier,
    st_force2d(node.geometry) AS geometry
  FROM qwat_od.installation installation
    JOIN qwat_od.network_element element ON installation.id = element.id
    JOIN qwat_od.node node ON element.id = node.id
    LEFT JOIN qwat_vl."precision" "precision" ON element.fk_precision = "precision".id
    LEFT JOIN qwat_od.distributor distributor ON element.fk_distributor = distributor.id
    LEFT JOIN qwat_od.folder folder ON element.fk_folder = folder.id
    LEFT JOIN qwat_od.pressurezone pressurezone ON node.fk_pressurezone = pressurezone.id
    LEFT JOIN qwat_vl.watertype watertype ON installation.fk_watertype = watertype.id
    LEFT JOIN qwat_od.pump pump ON installation.id = pump.id
    LEFT JOIN qwat_vl.pump_type pump_type ON pump.fk_pump_type = pump_type.id
    LEFT JOIN qwat_vl.pump_operating pump_operating ON pump.fk_pump_operating = pump_operating.id
  WHERE pump.id is not NULL;

ALTER TABLE qwat_ch_vd_sire.station_pompage
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.station_pompage TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.station_pompage TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.station_pompage TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.station_pompage TO qwat_viewer;

