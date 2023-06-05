-- View: qwat_ch_vd_sire.station_traitement

-- DROP VIEW qwat_ch_vd_sire.station_traitement;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.station_traitement
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
        CASE
            WHEN treatment.sanitization_uv IS TRUE THEN 1
            ELSE 0
        END AS uv_rayon_desinfection,
        CASE
            WHEN treatment.sanitization_chlorine_liquid IS TRUE THEN 1
            ELSE 0
        END AS chlore_liquide_desinfection,
        CASE
            WHEN treatment.sanitization_chlorine_gas IS TRUE THEN 1
            ELSE 0
        END AS chlore_gazeux_desinfection,
        CASE
            WHEN treatment.sanitization_ozone IS TRUE THEN 1
            ELSE 0
        END AS ozone_desinfection,
        CASE
            WHEN treatment.filtration_membrane IS TRUE THEN 1
            ELSE 0
        END AS membrane_filtration,
        CASE
            WHEN treatment.filtration_sandorgravel IS TRUE THEN 1
            ELSE 0
        END AS sable_ou_gravier_filtration,
        CASE
            WHEN treatment.flocculation IS TRUE THEN 1
            ELSE 0
        END AS floculation,
        CASE
            WHEN treatment.activatedcharcoal IS TRUE THEN 1
            ELSE 0
        END AS charbon_actif_filtration,
        CASE
            WHEN treatment.settling IS TRUE THEN 1
            ELSE 0
        END AS decantation,
    treatment.treatment_capacity AS capacite_traitement,
    2 AS electricite_fonctionnement,
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
    LEFT JOIN qwat_od.treatment treatment ON installation.id = treatment.id
  WHERE treatment.id is not NULL;

ALTER TABLE qwat_ch_vd_sire.station_traitement
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.station_traitement TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.station_traitement TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.station_traitement TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.station_traitement TO qwat_viewer;

