-- View: qwat_ch_vd_sire.captage

-- DROP VIEW qwat_ch_vd_sire.captage;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.captage
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
    source_type.code_sire AS genre,
    source.flow_lowest AS q_etiage,
    source.flow_average AS q_moyen,
    source_quality.code_sire AS qualite_captage,
    source.flow_concession AS q_concession,
    source.contract_end AS date_fin_concession,
        CASE
            WHEN source.gathering_chamber IS TRUE THEN 1
            WHEN source.gathering_chamber IS FALSE THEN 0
            ELSE 2
        END AS chambre_de_rassemblement,
    element.altitude,
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
    LEFT JOIN qwat_od.source source ON installation.id = source.id
    LEFT JOIN qwat_vl.source_type source_type ON source.fk_source_type = source_type.id
    LEFT JOIN qwat_vl.source_quality source_quality ON source.fk_source_quality = source_quality.id
  WHERE source.id is not NULL;

ALTER TABLE qwat_ch_vd_sire.captage
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.captage TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.captage TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.captage TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.captage TO qwat_viewer;

