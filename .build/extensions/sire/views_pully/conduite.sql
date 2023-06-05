-- View: qwat_ch_vd_sire.conduite

-- DROP VIEW qwat_ch_vd_sire.conduite;

CREATE OR REPLACE VIEW qwat_ch_vd_sire.conduite
 AS
  SELECT pipe.id AS id_num,
    pipe.qwat_ext_ch_vd_sire_remarque || pipe.remark AS remarque,
    "precision".code_sire AS precision_geo,
    distributor.name AS nom_distributeur,
    pipe.fk_distributor AS id_distributeur,
    pipe.qwat_ext_ch_vd_sire_etat_exploitation AS etat_exploitation,
    pipe.year AS annee_construction,
    NULL::text AS nom_descriptif,
    folder.identification AS numero_dossier,
    pressurezone.name AS nom_zone_pression,
    pressurezone.id AS id_zone_pression,
    watertype.code_sire AS type_eau,
    pipe_function.code_sire AS fonction,
    pipe_material.code_sire AS materiau,
    pipe_material.diameter_external AS diametre_externe,
    pipe.qwat_ext_ch_vd_sire_diametre AS diam_int_pdde,
    pipe_material.diameter_internal AS diametre_interne,
    pipe.year_rehabilitation AS annee_rehabilitation,
    pipe_material.pressure_nominal AS pression_fonc_admise,
    NULL::double precision AS rugosite_hydraulique,
    st_length(pipe.geometry) AS longueur_reelle,
    2 AS calcul_hydraulique,
    pipe.qwat_ext_ch_vd_sire_adesafecter AS a_desaffecter_pdde,
    pipe.pully_fk_chantier,
    st_force2d(pipe.geometry) AS geometry
  FROM qwat_od.pipe pipe
    LEFT JOIN qwat_vl."precision" "precision" ON pipe.fk_precision = "precision".id
    LEFT JOIN qwat_od.distributor distributor ON pipe.fk_distributor = distributor.id
    LEFT JOIN qwat_od.folder folder ON pipe.fk_folder = folder.id
	  LEFT JOIN qwat_od.pressurezone pressurezone ON pipe.fk_pressurezone = pressurezone.id
	  LEFT JOIN qwat_vl.watertype watertype ON pipe.fk_watertype = watertype.id
	  LEFT JOIN qwat_vl.pipe_function pipe_function ON pipe.fk_function = pipe_function.id
	  LEFT JOIN qwat_vl.pipe_material pipe_material ON pipe.fk_material = pipe_material.id
  WHERE pipe_function.major IS TRUE;

  ALTER TABLE qwat_ch_vd_sire.conduite
    OWNER TO postgres;

GRANT ALL ON TABLE qwat_ch_vd_sire.conduite TO postgres;
GRANT ALL ON TABLE qwat_ch_vd_sire.conduite TO qwat_manager;
GRANT ALL ON TABLE qwat_ch_vd_sire.conduite TO qwat_user;
GRANT REFERENCES, TRIGGER, SELECT ON TABLE qwat_ch_vd_sire.conduite TO qwat_viewer;

