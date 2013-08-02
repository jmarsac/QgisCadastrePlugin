﻿-- FORMATAGE DONNEES : DEBUT;
BEGIN;
DELETE FROM [PREFIXE]geo_tsurf WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_numvoie WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_voiep  WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_lieudit WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_zoncommuni WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_tpoint WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_tline WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_tronfluv WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_symblim WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_croix WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_borne WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_ptcanv WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_subdfisc WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_batiment WHERE lot='[LOT]';
DELETE FROM [PREFIXE]geo_commune WHERE lot='[LOT]';
-- geo_commune;
INSERT INTO [PREFIXE]geo_commune
( geo_commune, annee, object_rid, idu, tex2, creat_date, update_dat, geom,lot)
SELECT '[ANNEE]'||SUBSTRING(idu,1,3), '[ANNEE]', object_rid, idu, tex2, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_commune_id WHERE gid IN (SELECT max(gid) FROM [PREFIXE]impedigeo_commune_id);
UPDATE [PREFIXE]geo_commune set commune= p.commune FROM [PREFIXE]commune p WHERE p.annee='[ANNEE]' AND p.commune=SUBSTRING(geo_commune.geo_commune,1,4)||'[DEPDIR]'||SUBSTRING(geo_commune.geo_commune,5,3) AND geo_commune.annee='[ANNEE]';
UPDATE [PREFIXE]commune SET geo_commune=g.geo_commune FROM [PREFIXE]geo_commune g WHERE g.commune=commune.commune AND g.annee='[ANNEE]';
-- geo_section;
INSERT INTO [PREFIXE]geo_section
( geo_section, annee, object_rid, idu, tex, geo_commune, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||SUBSTRING(idu,1,8), '[ANNEE]', object_rid, idu, tex, '[ANNEE]'||SUBSTRING(idu,1,3), to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_section_id;
-- geo_subdsect;
INSERT INTO [PREFIXE]geo_subdsect 
(geo_subdsect, annee, object_rid, idu, geo_section, geo_qupl, geo_copl, eor, dedi, icl, dis, geo_inp, dred, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||SUBSTRING(idu,1,10), '[ANNEE]', object_rid, idu, '[ANNEE]'||SUBSTRING(idu,1,8), qupl, copl, to_number(eor,'0000000000'), to_date(dedi, 'DD/MM/YYYYY'), floor(icl), to_date(dis, 'DD/MM/YYYYY'), inp, to_date(dred,'DD/MM/YYYY'), to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom,'[LOT]'
FROM [PREFIXE]impedigeo_subdsect_id;
-- geo_parcelle;
INSERT INTO [PREFIXE]geo_parcelle
(geo_parcelle, annee, object_rid, idu, geo_section, supf, geo_indp, coar, tex, tex2, codm, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||idu, '[ANNEE]', object_rid, idu, '[ANNEE]'||SUBSTRING(idu,1,8), supf, indp, coar, tex, tex2, codm, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_parcelle_id;
UPDATE [PREFIXE]geo_parcelle set geo_subdsect=s.geo_subdsect FROM [PREFIXE]geo_subdsect s, [PREFIXE]edigeo_rel r 
WHERE s.annee=geo_parcelle.annee AND geo_parcelle.annee='[ANNEE]' AND r.nom='Rel_PARCELLE_SUBDSECT' AND r.de=geo_parcelle.object_rid AND vers=s.object_rid;
UPDATE [PREFIXE]geo_parcelle set parcelle= p.parcelle FROM [PREFIXE]parcelle p WHERE p.annee='[ANNEE]' AND p.parcelle=SUBSTRING(geo_parcelle.geo_parcelle,1,4)||'[DEPDIR]'||SUBSTRING(geo_parcelle.geo_parcelle,5,3)||replace(SUBSTRING(geo_parcelle.geo_parcelle,8,5),'0','-')||SUBSTRING(geo_parcelle.geo_parcelle,13,4) AND geo_parcelle.annee='[ANNEE]';
UPDATE [PREFIXE]parcelle SET geo_parcelle=g.geo_parcelle FROM [PREFIXE]geo_parcelle g WHERE g.parcelle=parcelle.parcelle AND g.annee='[ANNEE]';
-- geo_subdfisc;
INSERT INTO [PREFIXE]geo_subdfisc (geo_subdfisc, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||CASE WHEN tex IS NULL THEN '' ELSE tex END||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  CASE WHEN tex IS NULL THEN '' ELSE tex END, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_subdfisc_id;
-- geo_subdfisc_parcelle;
INSERT INTO [PREFIXE]geo_subdfisc_parcelle (annee, geo_subdfisc, geo_parcelle)
SELECT s.annee, s.geo_subdfisc, p.geo_parcelle
FROM [PREFIXE]geo_subdfisc s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_SUBDFISC_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_voiep;
INSERT INTO [PREFIXE]geo_voiep
( geo_voiep, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_voiep_id;
-- geo_numvoie;
INSERT INTO [PREFIXE]geo_numvoie
( geo_numvoie, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_numvoie_id;
-- geo_numvoie_parcelle;
INSERT INTO [PREFIXE]geo_numvoie_parcelle (annee, geo_numvoie, geo_parcelle)
SELECT s.annee, s.geo_numvoie, p.geo_parcelle
FROM [PREFIXE]geo_numvoie s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_NUMVOIE_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_lieudit;
INSERT INTO [PREFIXE]geo_lieudit
( geo_lieudit, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_lieudit_id;
-- geo_batiment;
INSERT INTO [PREFIXE]geo_batiment( geo_batiment, annee, object_rid, geo_dur, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, dur, tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_batiment_id;
-- geo_batiment_parcelle;
INSERT INTO [PREFIXE]geo_batiment_parcelle (annee, geo_batiment, geo_parcelle)
SELECT s.annee, s.geo_batiment, p.geo_parcelle
FROM [PREFIXE]geo_batiment s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_BATIMENT_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_zoncommuni;
INSERT INTO [PREFIXE]geo_zoncommuni( geo_zoncommuni, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, COALESCE(tex,'')||COALESCE(' '||tex2,'')||COALESCE(' '||tex3,'')||COALESCE(' '||tex4,'')||COALESCE(' '||tex5,'')||COALESCE(' '||tex6,'')||COALESCE(' '||tex7,'')||COALESCE(' '||tex8,'')||COALESCE(' '||tex9,'')||COALESCE(' '||tex10,'') as tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_zoncommuni_id;
-- geo_tronfluv;
INSERT INTO [PREFIXE]geo_tronfluv( geo_tronfluv, annee, object_rid, tex, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, COALESCE(tex,'')||COALESCE(' '||tex2,'')||COALESCE(' '||tex3,'')||COALESCE(' '||tex4,'')||COALESCE(' '||tex5,'')||COALESCE(' '||tex6,'')||COALESCE(' '||tex7,'')||COALESCE(' '||tex8,'')||COALESCE(' '||tex9,'')||COALESCE(' '||tex10,'') as tex, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_tronfluv_id;
-- geo_sym;
INSERT INTO [PREFIXE]geo_sym SELECT DISTINCT sym, 'Inconnu '||sym  FROM [PREFIXE]impedigeo_ptcanv_id WHERE sym NOT IN (SELECT geo_sym FROM [PREFIXE]geo_sym);
INSERT INTO [PREFIXE]geo_ptcanv( geo_ptcanv, annee, object_rid, idu, geo_can, geo_ppln, geo_palt, geo_map, geo_sym, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid, idu, can, ppln, palt, map, sym, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_ptcanv_id;
-- geo_borne;
INSERT INTO [PREFIXE]geo_borne( geo_borne, annee, object_rid, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_borne_id;
-- geo_borne_parcelle;
INSERT INTO [PREFIXE]geo_borne_parcelle (annee, geo_borne, geo_parcelle)
SELECT s.annee, s.geo_borne, p.geo_parcelle
FROM [PREFIXE]geo_borne s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_BORNE_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_croix;
INSERT INTO [PREFIXE]geo_croix( geo_croix, annee, object_rid, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_croix_id;
-- geo_croix_parcelle;
INSERT INTO [PREFIXE]geo_croix_parcelle (annee, geo_croix, geo_parcelle)
SELECT s.annee, s.geo_croix, p.geo_parcelle
FROM [PREFIXE]geo_croix s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_CROIX_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_symblim;
INSERT INTO [PREFIXE]geo_symblim( geo_symblim, annee, object_rid, ori, geo_sym, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  ori, sym, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_symblim_id;
UPDATE [PREFIXE]geo_symblim set ori=360-ori WHERE annee='[ANNEE]';
-- geo_symblim_parcelle;
INSERT INTO [PREFIXE]geo_symblim_parcelle (annee, geo_symblim, geo_parcelle)
SELECT s.annee, s.geo_symblim, p.geo_parcelle
FROM [PREFIXE]geo_symblim s, [PREFIXE]geo_parcelle p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_SYMBLIM_PARCELLE' AND s.object_rid=r.de AND p.object_rid=r.vers;
-- geo_tpoint;
INSERT INTO [PREFIXE]geo_tpoint( geo_tpoint, annee, object_rid, ori,tex, geo_sym, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  ori, tex, sym, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_tpoint_id;
UPDATE [PREFIXE]geo_tpoint SET ori=360-ori WHERE annee='[ANNEE]' AND ori IS NOT NULL;
-- geo_tpoint_commune;
INSERT INTO [PREFIXE]geo_tpoint_commune (annee, geo_tpoint, geo_commune)
SELECT s.annee, s.geo_tpoint, p.geo_commune
FROM [PREFIXE]geo_tpoint s, [PREFIXE]geo_commune p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_DETOPO_COMMUNE' AND p.object_rid=r.de AND s.object_rid=r.vers;
-- geo_tline;
INSERT INTO [PREFIXE]geo_tline( geo_tline, annee, object_rid, tex, geo_sym, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  tex, sym, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_tline_id;
-- geo_tline_commune;
INSERT INTO [PREFIXE]geo_tline_commune (annee, geo_tline, geo_commune)
SELECT s.annee, s.geo_tline, p.geo_commune
FROM [PREFIXE]geo_tline s, [PREFIXE]geo_commune p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_DETOPO_COMMUNE' AND p.object_rid=r.de AND s.object_rid=r.vers;
-- geo_tsurf;
INSERT INTO [PREFIXE]geo_tsurf( geo_tsurf, annee, object_rid, tex, geo_sym, creat_date, update_dat, geom, lot)
SELECT '[ANNEE]'||'[LOT]'||replace(to_char(gid,'0000000'),' ',''), '[ANNEE]', object_rid,  tex, sym, to_date(to_char(creat_date,'00000000'), 'YYYYMMDD'), to_date(to_char(update_dat,'00000000'), 'YYYYMMDD'), geom, '[LOT]'
FROM [PREFIXE]impedigeo_tsurf_id;
-- geo_tsurf_commune;
INSERT INTO [PREFIXE]geo_tsurf_commune (annee, geo_tsurf, geo_commune)
SELECT s.annee, s.geo_tsurf, p.geo_commune
FROM [PREFIXE]geo_tsurf s, [PREFIXE]geo_commune p, [PREFIXE]edigeo_rel r
WHERE s.annee='[ANNEE]' AND s.annee=p.annee AND r.nom='Rel_DETOPO_COMMUNE' AND p.object_rid=r.de AND s.object_rid=r.vers;
-- geo_label;
SELECT pg_catalog.setval('[PREFIXE]geo_label_seq', (select CASE WHEN cast(max(substring(geo_label,5,10)) as int) IS NULL THEN 1 ELSE cast(max(substring(geo_label,5,10)) as int)+1 END from [PREFIXE]geo_label WHERE ANNEE='[ANNEE]'), true);
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_parcelle, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_parcelle,'[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_parcelle p
WHERE i.ogr_obj__1='PARCELLE_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_section,lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_section,'[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_section p
WHERE i.ogr_obj__1='SECTION_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_voiep, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_voiep, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_voiep p
WHERE i.ogr_obj__1='VOIEP_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_tsurf, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_tsurf, '[LOT]' 
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_tsurf p
WHERE i.ogr_obj__1='TSURF_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_numvoie, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_numvoie, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_numvoie p
WHERE i.ogr_obj__1='NUMVOIE_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_lieudit, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_lieudit, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_lieudit p
WHERE i.ogr_obj__1='LIEUDIT_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_zoncommuni, lot)
SELECT distinct '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_zoncommuni, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_zoncommuni p
WHERE i.ogr_obj__1='ZONCOMMUNI_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_tpoint, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_tpoint, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_tpoint p
WHERE i.ogr_obj__1='TPOINT_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_subdfisc, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_subdfisc, '[LOT]' 
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_subdfisc p
WHERE i.ogr_obj__1='SUBDFISC_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_tline, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_tline, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_tline p
WHERE i.ogr_obj__1='TLINE_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, creat_date, update_dat, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, geo_tronfluv, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, p.creat_date, p.update_dat, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, p.geo_tronfluv, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i, [PREFIXE]geo_tronfluv p
WHERE i.ogr_obj__1='TRONFLUV_id' AND p.annee='[ANNEE]' AND p.object_rid=i.ogr_obj_ln;
INSERT INTO [PREFIXE]geo_label( 
 geo_label, annee, ogc_fid, object_rid, geom, fon, hei, tyu, cef, csp, di1, di2,
 di3, di4, tpa, hta, vta, atr, ogr_obj_ln, ogr_obj__1, ogr_atr_va, ogr_angle, ogr_font_s, lot)
SELECT '[ANNEE]'||replace(to_char(nextval('[PREFIXE]geo_label_seq'),'0000000000'),' ',''), '[ANNEE]', i.gid, i.object_rid, i.geom,
i.fon, i.hei, i.tyu, i.cef, i.csp, i.di1, i.di2, i.di3, i.di4, i.tpa, i.hta, i.vta, i.atr, i.ogr_obj_ln, i.ogr_obj__1, i.ogr_atr_va, i.ogr_angle, i.ogr_font_s, '[LOT]'
FROM [PREFIXE]impedigeo_id_s_obj_z_1_2_2 i
WHERE gid NOT IN (select gid FROM [PREFIXE]geo_label WHERE annee='[ANNEE]');
-- ANALYSES;
ANALYSE [PREFIXE]geo_commune;
ANALYSE [PREFIXE]geo_section;
ANALYSE [PREFIXE]geo_subdsect;
ANALYSE [PREFIXE]geo_parcelle;
ANALYSE [PREFIXE]geo_subdfisc;
ANALYSE [PREFIXE]geo_subdfisc_parcelle;
ANALYSE [PREFIXE]geo_voiep;
ANALYSE [PREFIXE]geo_numvoie;
ANALYSE [PREFIXE]geo_numvoie_parcelle;
ANALYSE [PREFIXE]geo_lieudit;
ANALYSE [PREFIXE]geo_batiment;
ANALYSE [PREFIXE]geo_batiment_parcelle;
ANALYSE [PREFIXE]geo_zoncommuni;
ANALYSE [PREFIXE]geo_tronfluv;
ANALYSE [PREFIXE]geo_sym;
ANALYSE [PREFIXE]geo_ptcanv;
ANALYSE [PREFIXE]geo_borne;
ANALYSE [PREFIXE]geo_borne_parcelle;
ANALYSE [PREFIXE]geo_croix;
ANALYSE [PREFIXE]geo_croix_parcelle;
ANALYSE [PREFIXE]geo_symblim;
ANALYSE [PREFIXE]geo_symblim_parcelle;
ANALYSE [PREFIXE]geo_tpoint;
ANALYSE [PREFIXE]geo_tpoint_commune;
ANALYSE [PREFIXE]geo_tline;
ANALYSE [PREFIXE]geo_tline_commune;
ANALYSE [PREFIXE]geo_tsurf;
ANALYSE [PREFIXE]geo_tsurf_commune;
ANALYSE [PREFIXE]geo_label;
COMMIT;
-- FORMATAGE DONNEES : FIN;