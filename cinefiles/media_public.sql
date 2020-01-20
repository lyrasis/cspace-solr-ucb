SELECT 
h2.name objectcsid,
cc.objectnumber,
h1.name mediacsid,
mc.description,
b.name,
mc.creator creatorRefname,
mc.creator creator,
mc.blobcsid,
mc.copyrightstatement,
mc.identificationnumber,
mc.rightsholder rightsholderRefname,
mc.rightsholder rightsholder,
mc.contributor,
b.mimetype,
c.data AS md5

FROM media_common mc

LEFT OUTER JOIN media_cinefiles mp ON (mp.id = mc.id)

JOIN misc ON (mc.id = misc.id AND misc.lifecyclestate <> 'deleted')
LEFT OUTER JOIN media_cinefiles mx on (mx.id = mc.id)
LEFT OUTER JOIN hierarchy h1 ON (h1.id = mc.id)
INNER JOIN relations_common rc ON (h1.name = rc.objectcsid AND rc.subjectdocumenttype = 'CollectionObject')
LEFT OUTER JOIN hierarchy h2 ON (rc.subjectcsid = h2.name)
LEFT OUTER JOIN collectionobjects_common cc ON (h2.id = cc.id)
JOIN collectionobjects_cinefiles cp ON (cc.id = cp.id)

JOIN hierarchy h3 ON (mc.blobcsid = h3.name)
LEFT OUTER JOIN blobs_common b ON (h3.id = b.id)

LEFT OUTER JOIN hierarchy h4 ON (b.repositoryid = h4.parentid AND h4.primarytype = 'content')
LEFT OUTER JOIN content c ON (h4.id = c.id)

ORDER BY mx.page ASC
