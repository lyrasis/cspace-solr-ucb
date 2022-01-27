SELECT
  h2.name                                                 AS objectcsid,
  cc.objectnumber,
  h1.name                                                 AS mediacsid,
  regexp_replace(mc.description,E'[\\t\\n\\r]+', ' ', 'g') AS description,
  bc.name,
  mc.creator                                              AS creatorRefname,
  REGEXP_REPLACE(mc.creator, '^.*\)''(.*)''$', '\1')      AS creator,
  mc.blobcsid,
  mc.copyrightstatement,
  mc.identificationnumber,
  mc.rightsholder                                          AS rightsholderRefname,
  REGEXP_REPLACE(mc.rightsholder, '^.*\)''(.*)''$', '\1')  AS rightsholder,
  mc.contributor,
  mp.approvedforweb,
  regexp_replace(cp.pahmatmslegacydepartment, '^.*\)''(.*)''$', '\1') AS pahmatmslegacydepartment,
  (SELECT STRING_AGG(DISTINCT REGEXP_REPLACE(osl.item, '^.*\)''(.*)''$', '\1'),'␥') AS "status_ss"
     FROM collectionobjects_common cc
     LEFT OUTER JOIN collectionobjects_pahma_pahmaobjectstatuslist osl ON (cc.id=osl.id)
     JOIN misc m ON (m.id=cc.id AND m.lifecyclestate<>'deleted')
     WHERE cc.id=h2.id) AS objectstatus,
  mp.primarydisplay                                       AS primarydisplay,
  bc.mimetype                                             AS mimetype,
  c.data                                                  AS md5

FROM media_common mc
  LEFT OUTER JOIN media_pahma mp ON (mp.id = mc.id)

  JOIN misc ON (mc.id = misc.id AND misc.lifecyclestate <> 'deleted')
  LEFT OUTER JOIN hierarchy h1 ON (h1.id = mc.id)
  INNER JOIN relations_common rc ON (h1.name = rc.objectcsid AND rc.subjectdocumenttype = 'CollectionObject')
  LEFT OUTER JOIN hierarchy h2 ON (rc.subjectcsid = h2.name)
  LEFT OUTER JOIN collectionobjects_common cc ON (h2.id = cc.id)
  JOIN collectionobjects_pahma cp ON (cc.id = cp.id)
  JOIN hierarchy h3 ON (mc.blobcsid = h3.name)
  LEFT OUTER JOIN blobs_common bc ON (h3.id = bc.id)
  LEFT OUTER JOIN hierarchy h4 ON (bc.repositoryid = h4.parentid AND h4.primarytype = 'content')
  LEFT OUTER JOIN content c ON (h4.id = c.id)
