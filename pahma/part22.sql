SELECT cc.id,
       STRING_AGG(DISTINCT ec.exhibitionnumber, '␥') AS "exhibitionnumber_ss",
       regexp_replace(STRING_AGG(DISTINCT ec.title, '␥'), E'[\\t\\n\\r]+', ' ', 'g') AS "exhibitiontitle_ss"
FROM collectionobjects_common cc
        LEFT OUTER JOIN collectionobjects_pahma cp ON (cc.id = cp.id)
        LEFT OUTER JOIN collectionobjects_anthropology ca ON (cc.id = ca.id)
        JOIN hierarchy h1 ON (cc.id = h1.id)
        JOIN relations_common rc ON (h1.name = rc.subjectcsid AND rc.objectdocumenttype = 'Exhibition')
        JOIN misc mrc on (rc.id = mrc.id and mrc.lifecyclestate != 'deleted')
        JOIN hierarchy h2 ON (rc.objectcsid = h2.name)
        LEFT OUTER JOIN exhibitions_common ec ON (h2.id = ec.id)
        LEFT OUTER JOIN misc mec ON (ec.id = mec.id and mec.lifecyclestate != 'deleted')
        LEFT OUTER JOIN hierarchy hn ON (cc.id = hn.parentid AND hn.name = 'collectionobjects_common:objectNameList' AND (hn.pos = 0 OR hn.pos IS NULL))
        LEFT OUTER JOIN objectnamegroup ong ON (ong.id = hn.id)
        LEFT OUTER JOIN exhibitionobjectgroup eog ON (eog.exhibitionobjectnumber = cc.objectnumber)

GROUP BY cc.id
