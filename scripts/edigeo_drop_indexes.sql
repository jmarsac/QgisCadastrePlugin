-- annee
DROP INDEX IF EXISTS geo_commune_annee_idx;
DROP INDEX IF EXISTS geo_section_annee_idx;
DROP INDEX IF EXISTS geo_subdsect_annee_idx;
DROP INDEX IF EXISTS geo_parcelle_annee_idx;
DROP INDEX IF EXISTS geo_subdfisc_annee_idx;
DROP INDEX IF EXISTS geo_voiep_annee_idx;
DROP INDEX IF EXISTS geo_numvoie_annee_idx;
DROP INDEX IF EXISTS geo_lieudit_annee_idx;
DROP INDEX IF EXISTS geo_batiment_annee_idx;
DROP INDEX IF EXISTS geo_zoncommuni_annee_idx;
DROP INDEX IF EXISTS geo_tronfluv_annee_idx;
DROP INDEX IF EXISTS geo_ptcanv_annee_idx;
DROP INDEX IF EXISTS geo_borne_annee_idx;
DROP INDEX IF EXISTS geo_croix_annee_idx;
DROP INDEX IF EXISTS geo_symblim_annee_idx;
DROP INDEX IF EXISTS geo_tpoint_annee_idx;
DROP INDEX IF EXISTS geo_tline_annee_idx;
DROP INDEX IF EXISTS geo_tsurf_annee_idx;

-- geometries
DROP INDEX IF EXISTS geo_commune_geom_idx;
DROP INDEX IF EXISTS geo_section_geom_idx;
DROP INDEX IF EXISTS geo_subdsect_geom_idx;
DROP INDEX IF EXISTS geo_parcelle_geom_idx;
DROP INDEX IF EXISTS geo_parcelle_geomuf_idx;
DROP INDEX IF EXISTS geo_subdfisc_geom_idx;
DROP INDEX IF EXISTS geo_voiep_geom_idx;
DROP INDEX IF EXISTS geo_numvoie_geom_idx;
DROP INDEX IF EXISTS geo_lieudit_geom_idx;
DROP INDEX IF EXISTS geo_batiment_geom_idx;
DROP INDEX IF EXISTS geo_zoncommuni_geom_idx;
DROP INDEX IF EXISTS geo_tronfluv_geom_idx;
DROP INDEX IF EXISTS geo_ptcanv_geom_idx;
DROP INDEX IF EXISTS geo_borne_geom_idx;
DROP INDEX IF EXISTS geo_croix_geom_idx;
DROP INDEX IF EXISTS geo_symblim_geom_idx;
DROP INDEX IF EXISTS geo_tpoint_geom_idx;
DROP INDEX IF EXISTS geo_tline_geom_idx;
DROP INDEX IF EXISTS geo_tsurf_geom_idx;
DROP INDEX IF EXISTS geo_label_geom_idx;
-- attributes
DROP INDEX IF EXISTS geo_commune_tex2_idx;
DROP INDEX IF EXISTS geo_section_idu_idx;
DROP INDEX IF EXISTS geo_parcelle_idu_idx;
DROP INDEX IF EXISTS parcelle_geo_parcelle_idx;
DROP INDEX IF EXISTS geo_section_geo_commune_idx;
DROP INDEX IF EXISTS geo_parcelle_geo_section_idx;
DROP INDEX IF EXISTS geo_parcelle_comptecommunal_idx;
DROP INDEX IF EXISTS geo_parcelle_voie_idx;
DROP INDEX IF EXISTS geo_label_x_label_idx ;
DROP INDEX IF EXISTS geo_label_y_label_idx ;
DROP INDEX IF EXISTS geo_label_ogr_obj_lnk_layer_idx;
