SELECT hcc.name,
       cc.id,
       cc.objectnumber,
       STRING_AGG(DISTINCT ec.exhibitionnumber, '␥') AS "exhibitionnumber_ss",
       STRING_AGG(DISTINCT ec.title, '␥')            AS "exhibitiontitle_ss"
       -- mrc.lifecyclestate
FROM collectionobjects_common cc
         JOIN hierarchy hcc ON (cc.id = hcc.id)
         JOIN relations_common rc ON (hcc.name = rc.subjectcsid AND rc.objectdocumenttype = 'Exhibition')
         JOIN misc mrc on (rc.id = mrc.id and mrc.lifecyclestate != 'deleted')
         JOIN hierarchy hec ON (rc.objectcsid = hec.name)
         LEFT OUTER JOIN exhibitions_common ec ON (hec.id = ec.id)
         LEFT OUTER JOIN misc mec ON (ec.id = mec.id and mec.lifecyclestate != 'deleted')
    /* where hcc.name in ( '084a31f0-7abe-4e0c-b255-a35d472b44e4', '51db2add-8187-42d0-835d-91e296500a6e', '46f0b51e-f54b-4e75-8a53-bdaef9d40bc1', 'b6fffc9f-5bd1-4cc9-a8ae-92817fbb54e2')*/
GROUP BY hcc.name, cc.id, mrc.lifecyclestate
;