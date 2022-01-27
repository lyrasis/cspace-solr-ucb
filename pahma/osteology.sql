SELECT
  cc.id                              AS "id",
  h1.name                            AS "csid_s",
  cc.objectnumber                    AS "objectnumber_s",
  ost.acetabulum_l                   AS "acetabulum_l_s",
  ost.acetabulum_r                   AS "acetabulum_r_s",
  ost.auricular_surf_l               AS "auricular_surf_l_s",
  ost.auricular_surf_r               AS "auricular_surf_r_s",
  ost.c1_complete                    AS "c1_complete_s",
  ost.c1_l_arch                      AS "c1_l_arch_s",
  ost.c1_r_arch                      AS "c1_r_arch_s",
  ost.c2_centrum                     AS "c2_centrum_s",
  ost.c2_complete                    AS "c2_complete_s",
  ost.c2_l_arch                      AS "c2_l_arch_s",
  ost.c2_r_arch                      AS "c2_r_arch_s",
  ost.c3_centrum                     AS "c3_centrum_s",
  ost.c3_complete                    AS "c3_complete_s",
  ost.c3_l_arch                      AS "c3_l_arch_s",
  ost.c3_r_arch                      AS "c3_r_arch_s",
  ost.c4_centrum                     AS "c4_centrum_s",
  ost.c4_complete                    AS "c4_complete_s",
  ost.c4_l_arch                      AS "c4_l_arch_s",
  ost.c4_r_arch                      AS "c4_r_arch_s",
  ost.c5_centrum                     AS "c5_centrum_s",
  ost.c5_complete                    AS "c5_complete_s",
  ost.c5_l_arch                      AS "c5_l_arch_s",
  ost.c5_r_arch                      AS "c5_r_arch_s",
  ost.c6_centrum                     AS "c6_centrum_s",
  ost.c6_complete                    AS "c6_complete_s",
  ost.c6_l_arch                      AS "c6_l_arch_s",
  ost.c6_r_arch                      AS "c6_r_arch_s",
  ost.c7_centrum                     AS "c7_centrum_s",
  ost.c7_complete                    AS "c7_complete_s",
  ost.c7_l_arch                      AS "c7_l_arch_s",
  ost.c7_r_arch                      AS "c7_r_arch_s",
  ost.c_centra_count                 AS "c_centra_count_s",
  ost.c_l_arch_count                 AS "c_l_arch_count_s",
  ost.c_r_arch_count                 AS "c_r_arch_count_s",
  ost.calcaneus_l                    AS "calcaneus_l_s",
  ost.calcaneus_r                    AS "calcaneus_r_s",
  ost.capitate_l                     AS "capitate_l_s",
  ost.capitate_r                     AS "capitate_r_s",
  ost.carpals_l_complete             AS "carpals_l_complete_s",
  ost.carpals_r_complete             AS "carpals_r_complete_s",
  ost.clavicle_l                     AS "clavicle_l_s",
  ost.clavicle_r                     AS "clavicle_r_s",
  ost.coccyx                         AS "coccyx_s",
  ost.coccyx_complete                AS "coccyx_complete_s",
  ost.cranium                        AS "cranium_s",
  ost.cuboid_l                       AS "cuboid_l_s",
  ost.cuboid_r                       AS "cuboid_r_s",
  ost.ethmoid                        AS "ethmoid_s",
  ost.femur_l_complete               AS "femur_l_complete_s",
  ost.femur_l_js_d                   AS "femur_l_js_d_s",
  ost.femur_l_js_p                   AS "femur_l_js_p_s",
  ost.femur_l_shaft_d                AS "femur_l_shaft_d_s",
  ost.femur_l_shaft_m                AS "femur_l_shaft_m_s",
  ost.femur_l_shaft_p                AS "femur_l_shaft_p_s",
  ost.femur_r_complete               AS "femur_r_complete_s",
  ost.femur_r_js_d                   AS "femur_r_js_d_s",
  ost.femur_r_js_p                   AS "femur_r_js_p_s",
  ost.femur_r_shaft_d                AS "femur_r_shaft_d_s",
  ost.femur_r_shaft_m                AS "femur_r_shaft_m_s",
  ost.femur_r_shaft_p                AS "femur_r_shaft_p_s",
  ost.fibula_l_complete              AS "fibula_l_complete_s",
  ost.fibula_l_js_d                  AS "fibula_l_js_d_s",
  ost.fibula_l_js_p                  AS "fibula_l_js_p_s",
  ost.fibula_l_shaft_d               AS "fibula_l_shaft_d_s",
  ost.fibula_l_shaft_m               AS "fibula_l_shaft_m_s",
  ost.fibula_l_shaft_p               AS "fibula_l_shaft_p_s",
  ost.fibula_r_complete              AS "fibula_r_complete_s",
  ost.fibula_r_js_d                  AS "fibula_r_js_d_s",
  ost.fibula_r_js_p                  AS "fibula_r_js_p_s",
  ost.fibula_r_shaft_d               AS "fibula_r_shaft_d_s",
  ost.fibula_r_shaft_m               AS "fibula_r_shaft_m_s",
  ost.fibula_r_shaft_p               AS "fibula_r_shaft_p_s",
  ost.frontal_l                      AS "frontal_l_s",
  ost.frontal_r                      AS "frontal_r_s",
  ost.glenoid_l                      AS "glenoid_l_s",
  ost.glenoid_r                      AS "glenoid_r_s",
  ost.hamate_l                       AS "hamate_l_s",
  ost.hamate_r                       AS "hamate_r_s",
  ost.humerus_l_complete             AS "humerus_l_complete_s",
  ost.humerus_l_js_d                 AS "humerus_l_js_d_s",
  ost.humerus_l_js_p                 AS "humerus_l_js_p_s",
  ost.humerus_l_shaft_d              AS "humerus_l_shaft_d_s",
  ost.humerus_l_shaft_m              AS "humerus_l_shaft_m_s",
  ost.humerus_l_shaft_p              AS "humerus_l_shaft_p_s",
  ost.humerus_r_complete             AS "humerus_r_complete_s",
  ost.humerus_r_js_d                 AS "humerus_r_js_d_s",
  ost.humerus_r_js_p                 AS "humerus_r_js_p_s",
  ost.humerus_r_shaft_d              AS "humerus_r_shaft_d_s",
  ost.humerus_r_shaft_m              AS "humerus_r_shaft_m_s",
  ost.humerus_r_shaft_p              AS "humerus_r_shaft_p_s",
  ost.hyoid                          AS "hyoid_s",
  ost.id                             AS "id_s",
  ost.ilium_l                        AS "ilium_l_s",
  ost.ilium_r                        AS "ilium_r_s",
  ost.int_cuneif_2_l                 AS "int_cuneif_2_l_s",
  ost.int_cuneif_2_r                 AS "int_cuneif_2_r_s",
  REGEXP_REPLACE(ost.inventoryanalyst, '^.*\)''(.*)''$', '\1') AS "inventoryanalyst_s",
  TO_CHAR(ost.inventorydate at time zone 'UTC', 'YYYY-MM-DD"T"HH24:MI:SS"Z"') AS "inventorydate_dt",
  ost.inventoryid                    AS "inventoryid_s",
  ost.inventoryiscomplete            AS "inventoryiscomplete_b",
  ost.ischium_l                      AS "ischium_l_s",
  ost.ischium_r                      AS "ischium_r_s",
  ost.l1_centrum                     AS "l1_centrum_s",
  ost.l1_complete                    AS "l1_complete_s",
  ost.l1_l_arch                      AS "l1_l_arch_s",
  ost.l1_r_arch                      AS "l1_r_arch_s",
  ost.l2_centrum                     AS "l2_centrum_s",
  ost.l2_complete                    AS "l2_complete_s",
  ost.l2_l_arch                      AS "l2_l_arch_s",
  ost.l2_r_arch                      AS "l2_r_arch_s",
  ost.l3_centrum                     AS "l3_centrum_s",
  ost.l3_complete                    AS "l3_complete_s",
  ost.l3_l_arch                      AS "l3_l_arch_s",
  ost.l3_r_arch                      AS "l3_r_arch_s",
  ost.l4_centrum                     AS "l4_centrum_s",
  ost.l4_complete                    AS "l4_complete_s",
  ost.l4_l_arch                      AS "l4_l_arch_s",
  ost.l4_r_arch                      AS "l4_r_arch_s",
  ost.l5_centrum                     AS "l5_centrum_s",
  ost.l5_complete                    AS "l5_complete_s",
  ost.l5_l_arch                      AS "l5_l_arch_s",
  ost.l5_r_arch                      AS "l5_r_arch_s",
  ost.l_centra_count                 AS "l_centra_count_s",
  ost.l_l_arch_count                 AS "l_l_arch_count_s",
  ost.l_r_arch_count                 AS "l_r_arch_count_s",
  ost.lacrimal_l                     AS "lacrimal_l_s",
  ost.lacrimal_r                     AS "lacrimal_r_s",
  ost.lat_cuneif_3_l                 AS "lat_cuneif_3_l_s",
  ost.lat_cuneif_3_r                 AS "lat_cuneif_3_r_s",
  ost.lunate_l                       AS "lunate_l_s",
  ost.lunate_r                       AS "lunate_r_s",
  ost.mandible_l                     AS "mandible_l_s",
  ost.mandible_r                     AS "mandible_r_s",
  ost.manubrium                      AS "manubrium_s",
  ost.maxilla_l                      AS "maxilla_l_s",
  ost.maxilla_r                      AS "maxilla_r_s",
  ost.mc1_l                          AS "mc1_l_s",
  ost.mc1_r                          AS "mc1_r_s",
  ost.mc2_l                          AS "mc2_l_s",
  ost.mc2_r                          AS "mc2_r_s",
  ost.mc3_l                          AS "mc3_l_s",
  ost.mc3_r                          AS "mc3_r_s",
  ost.mc4_l                          AS "mc4_l_s",
  ost.mc4_r                          AS "mc4_r_s",
  ost.mc5_l                          AS "mc5_l_s",
  ost.mc5_r                          AS "mc5_r_s",
  ost.mc_l_complete                  AS "mc_l_complete_s",
  ost.mc_l_count                     AS "mc_l_count_s",
  ost.mc_r_complete                  AS "mc_r_complete_s",
  ost.mc_r_count                     AS "mc_r_count_s",
  ost.med_cuneif_1_l                 AS "med_cuneif_1_l_s",
  ost.med_cuneif_1_r                 AS "med_cuneif_1_r_s",
  ost.mt1_l                          AS "mt1_l_s",
  ost.mt1_r                          AS "mt1_r_s",
  ost.mt2_l                          AS "mt2_l_s",
  ost.mt2_r                          AS "mt2_r_s",
  ost.mt3_l                          AS "mt3_l_s",
  ost.mt3_r                          AS "mt3_r_s",
  ost.mt4_l                          AS "mt4_l_s",
  ost.mt4_r                          AS "mt4_r_s",
  ost.mt5_l                          AS "mt5_l_s",
  ost.mt5_r                          AS "mt5_r_s",
  ost.mt_l_complete                  AS "mt_l_complete_s",
  ost.mt_l_count                     AS "mt_l_count_s",
  ost.mt_r_complete                  AS "mt_r_complete_s",
  ost.mt_r_count                     AS "mt_r_count_s",
  ost.nasal_l                        AS "nasal_l_s",
  ost.nasal_r                        AS "nasal_r_s",
  ost.navicular_l                    AS "navicular_l_s",
  ost.navicular_r                    AS "navicular_r_s",
  ost.occipital                      AS "occipital_s",
  ost.occipital_l_pars_lateralis     AS "occipital_l_pars_lateralis_s",
  ost.occipital_pars_basilaris       AS "occipital_pars_basilaris_s",
  ost.occipital_r_pars_lateralis     AS "occipital_r_pars_lateralis_s",
  ost.orbit_l                        AS "orbit_l_s",
  ost.orbit_r                        AS "orbit_r_s",
  ost.os_coxae_l                     AS "os_coxae_l_s",
  ost.os_coxae_r                     AS "os_coxae_r_s",
  ost.palatine_l                     AS "palatine_l_s",
  ost.palatine_r                     AS "palatine_r_s",
  ost.parietal_l                     AS "parietal_l_s",
  ost.parietal_r                     AS "parietal_r_s",
  ost.patella_l                      AS "patella_l_s",
  ost.patella_r                      AS "patella_r_s",
  ost.phalanx_d_count_foot           AS "phalanx_d_count_foot_s",
  ost.phalanx_d_count_hand           AS "phalanx_d_count_hand_s",
  ost.phalanx_i_count_foot           AS "phalanx_i_count_foot_s",
  ost.phalanx_i_count_hand           AS "phalanx_i_count_hand_s",
  ost.phalanx_juv_count_foot         AS "phalanx_juv_count_foot_s",
  ost.phalanx_juv_count_hand         AS "phalanx_juv_count_hand_s",
  ost.phalanx_p_count_foot           AS "phalanx_p_count_foot_s",
  ost.phalanx_p_count_hand           AS "phalanx_p_count_hand_s",
  ost.pisiform_l                     AS "pisiform_l_s",
  ost.pisiform_r                     AS "pisiform_r_s",
  ost.pubis_l                        AS "pubis_l_s",
  ost.pubis_r                        AS "pubis_r_s",
  ost.radius_l_complete              AS "radius_l_complete_s",
  ost.radius_l_js_d                  AS "radius_l_js_d_s",
  ost.radius_l_js_p                  AS "radius_l_js_p_s",
  ost.radius_l_shaft_d               AS "radius_l_shaft_d_s",
  ost.radius_l_shaft_m               AS "radius_l_shaft_m_s",
  ost.radius_l_shaft_p               AS "radius_l_shaft_p_s",
  ost.radius_r_complete              AS "radius_r_complete_s",
  ost.radius_r_js_d                  AS "radius_r_js_d_s",
  ost.radius_r_js_p                  AS "radius_r_js_p_s",
  ost.radius_r_shaft_d               AS "radius_r_shaft_d_s",
  ost.radius_r_shaft_m               AS "radius_r_shaft_m_s",
  ost.radius_r_shaft_p               AS "radius_r_shaft_p_s",
  ost.rib1_l                         AS "rib10_l_s",
  ost.rib1_l_head_neck_complete      AS "rib10_l_head_neck_complete_s",
  ost.rib1_l_sternal_end_complete    AS "rib10_l_sternal_end_complete_s",
  ost.rib1_r                         AS "rib10_r_s",
  ost.rib1_r_head_neck_complete      AS "rib10_r_head_neck_complete_s",
  ost.rib1_r_sternal_end_complete    AS "rib10_r_sternal_end_complete_s",
  ost.rib2_l                         AS "rib11_l_s",
  ost.rib2_l_head_neck_complete      AS "rib11_l_head_neck_complete_s",
  ost.rib2_l_sternal_end_complete    AS "rib11_l_sternal_end_complete_s",
  ost.rib2_r                         AS "rib11_r_s",
  ost.rib2_r_head_neck_complete      AS "rib11_r_head_neck_complete_s",
  ost.rib2_r_sternal_end_complete    AS "rib11_r_sternal_end_complete_s",
  ost.rib3_l                         AS "rib12_l_s",
  ost.rib3_l_head_neck_complete      AS "rib12_l_head_neck_complete_s",
  ost.rib3_l_sternal_end_complete    AS "rib12_l_sternal_end_complete_s",
  ost.rib3_r                         AS "rib12_r_s",
  ost.rib3_r_head_neck_complete      AS "rib12_r_head_neck_complete_s",
  ost.rib3_r_sternal_end_complete    AS "rib12_r_sternal_end_complete_s",
  ost.rib4_l                         AS "rib1_l_s",
  ost.rib4_l_head_neck_complete      AS "rib1_l_head_neck_complete_s",
  ost.rib4_l_sternal_end_complete    AS "rib1_l_sternal_end_complete_s",
  ost.rib4_r                         AS "rib1_r_s",
  ost.rib4_r_head_neck_complete      AS "rib1_r_head_neck_complete_s",
  ost.rib4_r_sternal_end_complete    AS "rib1_r_sternal_end_complete_s",
  ost.rib5_l                         AS "rib2_l_s",
  ost.rib5_l_head_neck_complete      AS "rib2_l_head_neck_complete_s",
  ost.rib5_l_sternal_end_complete    AS "rib2_l_sternal_end_complete_s",
  ost.rib5_r                         AS "rib2_r_s",
  ost.rib5_r_head_neck_complete      AS "rib2_r_head_neck_complete_s",
  ost.rib5_r_sternal_end_complete    AS "rib2_r_sternal_end_complete_s",
  ost.rib6_l                         AS "rib3_l_s",
  ost.rib6_l_head_neck_complete      AS "rib3_l_head_neck_complete_s",
  ost.rib6_l_sternal_end_complete    AS "rib3_l_sternal_end_complete_s",
  ost.rib6_r                         AS "rib3_r_s",
  ost.rib6_r_head_neck_complete      AS "rib3_r_head_neck_complete_s",
  ost.rib6_r_sternal_end_complete    AS "rib3_r_sternal_end_complete_s",
  ost.rib7_l                         AS "rib4_l_s",
  ost.rib7_l_head_neck_complete      AS "rib4_l_head_neck_complete_s",
  ost.rib7_l_sternal_end_complete    AS "rib4_l_sternal_end_complete_s",
  ost.rib7_r                         AS "rib4_r_s",
  ost.rib7_r_head_neck_complete      AS "rib4_r_head_neck_complete_s",
  ost.rib7_r_sternal_end_complete    AS "rib4_r_sternal_end_complete_s",
  ost.rib8_l                         AS "rib5_l_s",
  ost.rib8_l_head_neck_complete      AS "rib5_l_head_neck_complete_s",
  ost.rib8_l_sternal_end_complete    AS "rib5_l_sternal_end_complete_s",
  ost.rib8_r                         AS "rib5_r_s",
  ost.rib8_r_head_neck_complete      AS "rib5_r_head_neck_complete_s",
  ost.rib8_r_sternal_end_complete    AS "rib5_r_sternal_end_complete_s",
  ost.rib9_l                         AS "rib6_l_s",
  ost.rib9_l_head_neck_complete      AS "rib6_l_head_neck_complete_s",
  ost.rib9_l_sternal_end_complete    AS "rib6_l_sternal_end_complete_s",
  ost.rib9_r                         AS "rib6_r_s",
  ost.rib9_r_head_neck_complete      AS "rib6_r_head_neck_complete_s",
  ost.rib9_r_sternal_end_complete    AS "rib6_r_sternal_end_complete_s",
  ost.rib10_l                        AS "rib7_l_s",
  ost.rib10_l_head_neck_complete     AS "rib7_l_head_neck_complete_s",
  ost.rib10_l_sternal_end_complete   AS "rib7_l_sternal_end_complete_s",
  ost.rib10_r                        AS "rib7_r_s",
  ost.rib10_r_head_neck_complete     AS "rib7_r_head_neck_complete_s",
  ost.rib10_r_sternal_end_complete   AS "rib7_r_sternal_end_complete_s",
  ost.rib11_l                        AS "rib8_l_s",
  ost.rib11_l_head_neck_complete     AS "rib8_l_head_neck_complete_s",
  ost.rib11_l_sternal_end_complete   AS "rib8_l_sternal_end_complete_s",
  ost.rib11_r                        AS "rib8_r_s",
  ost.rib11_r_head_neck_complete     AS "rib8_r_head_neck_complete_s",
  ost.rib11_r_sternal_end_complete   AS "rib8_r_sternal_end_complete_s",
  ost.rib12_l                        AS "rib9_l_s",
  ost.rib12_l_head_neck_complete     AS "rib9_l_head_neck_complete_s",
  ost.rib12_l_sternal_end_complete   AS "rib9_l_sternal_end_complete_s",
  ost.rib12_r                        AS "rib9_r_s",
  ost.rib12_r_head_neck_complete     AS "rib9_r_head_neck_complete_s",
  ost.rib12_r_sternal_end_complete   AS "rib9_r_sternal_end_complete_s",
  ost.ribs_l_complete                AS "ribs_l_complete_s",
  ost.ribs_r_complete                AS "ribs_r_complete_s",
  ost.s1_centrum                     AS "s1_centrum_s",
  ost.s1_complete                    AS "s1_complete_s",
  ost.s1_l_ala                       AS "s1_l_ala_s",
  ost.s1_r_ala                       AS "s1_r_ala_s",
  ost.s2_centrum                     AS "s2_centrum_s",
  ost.s2_complete                    AS "s2_complete_s",
  ost.s2_l_ala                       AS "s2_l_ala_s",
  ost.s2_r_ala                       AS "s2_r_ala_s",
  ost.s3_centrum                     AS "s3_centrum_s",
  ost.s3_complete                    AS "s3_complete_s",
  ost.s3_l_ala                       AS "s3_l_ala_s",
  ost.s3_r_ala                       AS "s3_r_ala_s",
  ost.s4_centrum                     AS "s4_centrum_s",
  ost.s4_complete                    AS "s4_complete_s",
  ost.s4_l_ala                       AS "s4_l_ala_s",
  ost.s4_r_ala                       AS "s4_r_ala_s",
  ost.s5_centrum                     AS "s5_centrum_s",
  ost.s5_complete                    AS "s5_complete_s",
  ost.s5_l_ala                       AS "s5_l_ala_s",
  ost.s5_r_ala                       AS "s5_r_ala_s",
  ost.s_centra_count                 AS "s_centra_count_s",
  ost.s_l_ala_count                  AS "s_l_ala_count_s",
  ost.s_r_ala_count                  AS "s_r_ala_count_s",
  ost.sacrum                         AS "sacrum_s",
  ost.sacrum_complete                AS "sacrum_complete_s",
  ost.sacrum_l_alae                  AS "sacrum_l_alae_s",
  ost.sacrum_r_alae                  AS "sacrum_r_alae_s",
  ost.scaphoid_l                     AS "scaphoid_l_s",
  ost.scaphoid_r                     AS "scaphoid_r_s",
  ost.scapula_l                      AS "scapula_l_s",
  ost.scapula_r                      AS "scapula_r_s",
  ost.sesamoid_l_count_foot          AS "sesamoid_l_count_foot_s",
  ost.sesamoid_l_count_hand          AS "sesamoid_l_count_hand_s",
  ost.sesamoid_r_count_foot          AS "sesamoid_r_count_foot_s",
  ost.sesamoid_r_count_hand          AS "sesamoid_r_count_hand_s",
  ost.sphenoid                       AS "sphenoid_s",
  ost.sternum                        AS "sternum_s",
  ost.t10_centrum                    AS "t10_centrum_s",
  ost.t10_complete                   AS "t10_complete_s",
  ost.t10_l_arch                     AS "t10_l_arch_s",
  ost.t10_r_arch                     AS "t10_r_arch_s",
  ost.t11_centrum                    AS "t11_centrum_s",
  ost.t11_complete                   AS "t11_complete_s",
  ost.t11_l_arch                     AS "t11_l_arch_s",
  ost.t11_r_arch                     AS "t11_r_arch_s",
  ost.t12_centrum                    AS "t12_centrum_s",
  ost.t12_complete                   AS "t12_complete_s",
  ost.t12_l_arch                     AS "t12_l_arch_s",
  ost.t12_r_arch                     AS "t12_r_arch_s",
  ost.t1_centrum                     AS "t1_centrum_s",
  ost.t1_complete                    AS "t1_complete_s",
  ost.t1_l_arch                      AS "t1_l_arch_s",
  ost.t1_r_arch                      AS "t1_r_arch_s",
  ost.t2_centrum                     AS "t2_centrum_s",
  ost.t2_complete                    AS "t2_complete_s",
  ost.t2_l_arch                      AS "t2_l_arch_s",
  ost.t2_r_arch                      AS "t2_r_arch_s",
  ost.t3_centrum                     AS "t3_centrum_s",
  ost.t3_complete                    AS "t3_complete_s",
  ost.t3_l_arch                      AS "t3_l_arch_s",
  ost.t3_r_arch                      AS "t3_r_arch_s",
  ost.t4_centrum                     AS "t4_centrum_s",
  ost.t4_complete                    AS "t4_complete_s",
  ost.t4_l_arch                      AS "t4_l_arch_s",
  ost.t4_r_arch                      AS "t4_r_arch_s",
  ost.t5_centrum                     AS "t5_centrum_s",
  ost.t5_complete                    AS "t5_complete_s",
  ost.t5_l_arch                      AS "t5_l_arch_s",
  ost.t5_r_arch                      AS "t5_r_arch_s",
  ost.t6_centrum                     AS "t6_centrum_s",
  ost.t6_complete                    AS "t6_complete_s",
  ost.t6_l_arch                      AS "t6_l_arch_s",
  ost.t6_r_arch                      AS "t6_r_arch_s",
  ost.t7_centrum                     AS "t7_centrum_s",
  ost.t7_complete                    AS "t7_complete_s",
  ost.t7_l_arch                      AS "t7_l_arch_s",
  ost.t7_r_arch                      AS "t7_r_arch_s",
  ost.t8_centrum                     AS "t8_centrum_s",
  ost.t8_complete                    AS "t8_complete_s",
  ost.t8_l_arch                      AS "t8_l_arch_s",
  ost.t8_r_arch                      AS "t8_r_arch_s",
  ost.t9_centrum                     AS "t9_centrum_s",
  ost.t9_complete                    AS "t9_complete_s",
  ost.t9_l_arch                      AS "t9_l_arch_s",
  ost.t9_r_arch                      AS "t9_r_arch_s",
  ost.t_centra_count                 AS "t_centra_count_s",
  ost.t_l_arch_count                 AS "t_l_arch_count_s",
  ost.t_r_arch_count                 AS "t_r_arch_count_s",
  ost.talus_l                        AS "talus_l_s",
  ost.talus_r                        AS "talus_r_s",
  ost.tarsals_l_complete             AS "tarsals_l_complete_s",
  ost.tarsals_r_complete             AS "tarsals_r_complete_s",
  ost.teeth_decid_ldc_l              AS "teeth_decid_ldc_l_s",
  ost.teeth_decid_ldc_r              AS "teeth_decid_ldc_r_s",
  ost.teeth_decid_ldi1_l             AS "teeth_decid_ldi1_l_s",
  ost.teeth_decid_ldi1_r             AS "teeth_decid_ldi1_r_s",
  ost.teeth_decid_ldi2_l             AS "teeth_decid_ldi2_l_s",
  ost.teeth_decid_ldi2_r             AS "teeth_decid_ldi2_r_s",
  ost.teeth_decid_ldm1_l             AS "teeth_decid_ldm1_l_s",
  ost.teeth_decid_ldm1_r             AS "teeth_decid_ldm1_r_s",
  ost.teeth_decid_ldm2_l             AS "teeth_decid_ldm2_l_s",
  ost.teeth_decid_ldm2_r             AS "teeth_decid_ldm2_r_s",
  ost.teeth_decid_udc_l              AS "teeth_decid_udc_l_s",
  ost.teeth_decid_udc_r              AS "teeth_decid_udc_r_s",
  ost.teeth_decid_udi1_l             AS "teeth_decid_udi1_l_s",
  ost.teeth_decid_udi1_r             AS "teeth_decid_udi1_r_s",
  ost.teeth_decid_udi2_l             AS "teeth_decid_udi2_l_s",
  ost.teeth_decid_udi2_r             AS "teeth_decid_udi2_r_s",
  ost.teeth_decid_udm1_l             AS "teeth_decid_udm1_l_s",
  ost.teeth_decid_udm1_r             AS "teeth_decid_udm1_r_s",
  ost.teeth_decid_udm2_l             AS "teeth_decid_udm2_l_s",
  ost.teeth_decid_udm2_r             AS "teeth_decid_udm2_r_s",
  ost.teeth_immvertfragscount        AS "teeth_immvertfragscount_s",
  ost.teeth_lc_l                     AS "teeth_lc_l_s",
  ost.teeth_lc_r                     AS "teeth_lc_r_s",
  ost.teeth_li1_l                    AS "teeth_li1_l_s",
  ost.teeth_li1_r                    AS "teeth_li1_r_s",
  ost.teeth_li2_l                    AS "teeth_li2_l_s",
  ost.teeth_li2_r                    AS "teeth_li2_r_s",
  ost.teeth_lm1_l                    AS "teeth_lm1_l_s",
  ost.teeth_lm1_r                    AS "teeth_lm1_r_s",
  ost.teeth_lm2_l                    AS "teeth_lm2_l_s",
  ost.teeth_lm2_r                    AS "teeth_lm2_r_s",
  ost.teeth_lm3_l                    AS "teeth_lm3_l_s",
  ost.teeth_lm3_r                    AS "teeth_lm3_r_s",
  ost.teeth_lp3_l                    AS "teeth_lp3_l_s",
  ost.teeth_lp3_r                    AS "teeth_lp3_r_s",
  ost.teeth_lp4_l                    AS "teeth_lp4_l_s",
  ost.teeth_lp4_r                    AS "teeth_lp4_r_s",
  ost.teeth_uc_l                     AS "teeth_uc_l_s",
  ost.teeth_uc_r                     AS "teeth_uc_r_s",
  ost.teeth_ui1_l                    AS "teeth_ui1_l_s",
  ost.teeth_ui1_r                    AS "teeth_ui1_r_s",
  ost.teeth_ui2_l                    AS "teeth_ui2_l_s",
  ost.teeth_ui2_r                    AS "teeth_ui2_r_s",
  ost.teeth_um1_l                    AS "teeth_um1_l_s",
  ost.teeth_um1_r                    AS "teeth_um1_r_s",
  ost.teeth_um2_l                    AS "teeth_um2_l_s",
  ost.teeth_um2_r                    AS "teeth_um2_r_s",
  ost.teeth_um3_l                    AS "teeth_um3_l_s",
  ost.teeth_um3_r                    AS "teeth_um3_r_s",
  ost.teeth_up3_l                    AS "teeth_up3_l_s",
  ost.teeth_up3_r                    AS "teeth_up3_r_s",
  ost.teeth_up4_l                    AS "teeth_up4_l_s",
  ost.teeth_up4_r                    AS "teeth_up4_r_s",
  ost.temporal_l                     AS "temporal_l_s",
  ost.temporal_r                     AS "temporal_r_s",
  ost.tibia_l_complete               AS "tibia_l_complete_s",
  ost.tibia_l_js_d                   AS "tibia_l_js_d_s",
  ost.tibia_l_js_p                   AS "tibia_l_js_p_s",
  ost.tibia_l_shaft_d                AS "tibia_l_shaft_d_s",
  ost.tibia_l_shaft_m                AS "tibia_l_shaft_m_s",
  ost.tibia_l_shaft_p                AS "tibia_l_shaft_p_s",
  ost.tibia_r_complete               AS "tibia_r_complete_s",
  ost.tibia_r_js_d                   AS "tibia_r_js_d_s",
  ost.tibia_r_js_p                   AS "tibia_r_js_p_s",
  ost.tibia_r_shaft_d                AS "tibia_r_shaft_d_s",
  ost.tibia_r_shaft_m                AS "tibia_r_shaft_m_s",
  ost.tibia_r_shaft_p                AS "tibia_r_shaft_p_s",
  ost.trapezium_l                    AS "trapezium_l_s",
  ost.trapezium_r                    AS "trapezium_r_s",
  ost.trapezoid_l                    AS "trapezoid_l_s",
  ost.trapezoid_r                    AS "trapezoid_r_s",
  ost.triquetral_l                   AS "triquetral_l_s",
  ost.triquetral_r                   AS "triquetral_r_s",
  ost.ulna_l_complete                AS "ulna_l_complete_s",
  ost.ulna_l_js_d                    AS "ulna_l_js_d_s",
  ost.ulna_l_js_p                    AS "ulna_l_js_p_s",
  ost.ulna_l_shaft_d                 AS "ulna_l_shaft_d_s",
  ost.ulna_l_shaft_m                 AS "ulna_l_shaft_m_s",
  ost.ulna_l_shaft_p                 AS "ulna_l_shaft_p_s",
  ost.ulna_r_complete                AS "ulna_r_complete_s",
  ost.ulna_r_js_d                    AS "ulna_r_js_d_s",
  ost.ulna_r_js_p                    AS "ulna_r_js_p_s",
  ost.ulna_r_shaft_d                 AS "ulna_r_shaft_d_s",
  ost.ulna_r_shaft_m                 AS "ulna_r_shaft_m_s",
  ost.ulna_r_shaft_p                 AS "ulna_r_shaft_p_s",
  ost.vertebrae_complete             AS "vertebrae_complete_s",
  ost.vomer                          AS "vomer_s",
  ost.zygomatic_l                    AS "zygomatic_l_s",
  ost.zygomatic_r                    AS "zygomatic_r_s",
  ost.notesonelementinventory        AS "notes_onelementinventory_s",
  osta.notes_postcranialpathology    AS "notes_postcranialpathology_s",
  osta.notes_cranialpathology        AS "notes_cranialpathology_s",
  osta.notes_dentalpathology         AS "notes_dentalpathology_s",
  osta.notes_nhtaphonomicalterations AS "notes_nhtaphonomicalterations_s",
  osta.notes_curatorialsuffixing     AS "notes_curatorialsuffixing_s",
  osta.notes_culturalmodifications   AS "notes_culturalmodifications_s",
  ostage.osteoageestimateupper       AS "osteoageestimateupper_f",
  ostage.osteoageestimatenote        AS "osteoageestimatenote_s",
  ostage.osteoageestimatelower       AS "osteoageestimatelower_f",
  ostage.osteoageestimateverbatim    AS "osteoageestimateverbatim_s",
  ostsex.sexdetermination            AS "sexdetermination_s",
  ostsex.sexdeterminationnote        AS "sexdeterminationnote_s"
FROM collectionobjects_common cc
  LEFT OUTER JOIN collectionobjects_pahma cp
    ON (cc.id = cp.id AND regexp_replace(cp.pahmatmslegacydepartment, '^.*\)''(.*)''$', '\1') IN ('Human Remains', 'Mixed faunal and human remains'))
  JOIN hierarchy h1 ON (cc.id = h1.id)
  JOIN relations_common rc ON (rc.subjectcsid = h1.name AND rc.objectdocumenttype = 'Osteology')
  JOIN hierarchy h2 ON (rc.objectcsid = h2.name)
  JOIN osteology_common ost ON (h2.id = ost.id)
  LEFT OUTER JOIN osteology_anthropology osta ON (ost.id = osta.id)
  LEFT OUTER JOIN hierarchy hage
    ON (hage.parentid = ost.id AND hage.primarytype = 'osteoAgeEstimateGroup' AND hage.pos = 0)
  LEFT OUTER JOIN osteoageestimategroup ostage ON (hage.id = ostage.id)
  LEFT OUTER JOIN hierarchy hsex
    ON (hsex.parentid = ost.id AND hsex.primarytype = 'sexDeterminationGroup' AND hsex.pos = 0)
  LEFT OUTER JOIN sexdeterminationgroup ostsex ON (hsex.id = ostsex.id)
ORDER BY cp.sortableobjectnumber
