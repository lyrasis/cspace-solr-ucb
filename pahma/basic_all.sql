SELECT cc.id,
       h1.name                                                             AS "csid_s",
       cp.sortableobjectnumber                                             AS "objsortnum_s",
       cc.objectnumber                                                     AS "objmusno_s",
       regexp_replace(cp.pahmatmslegacydepartment, '^.*\)''(.*)''$', '\1') AS "objdept_s",
       regexp_replace(cc.collection, '^.*\)''(.*)''$', '\1')               AS "objtype_s",
       cc.numberofobjects                                                  AS "objcount_s",
       cp.inventorycount                                                   AS "objcountnote_s",
       cp.portfolioseries                                                  AS "objkeelingser_s",
       regexp_replace(cp.pahmafieldlocverbatim, E'[\\t\\n\\r]+', ' ', 'g') AS "objfcpverbatim_s"
FROM collectionobjects_common cc
         JOIN hierarchy h1 ON (h1.id = cc.id)
         LEFT OUTER JOIN collectionobjects_pahma cp ON (cp.id = cc.id)
         JOIN misc ON (cc.id = misc.id and misc.lifecyclestate <> 'deleted')
