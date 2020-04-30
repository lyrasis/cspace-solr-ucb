SELECT DISTINCT cc.id,
                regexp_replace(STRING_AGG(ins.inscriptioncontent, '␥'), E'[\\t\\n\\r]+', ' ', 'g') AS "objinscrtext_ss"
FROM collectionobjects_common cc
         JOIN hierarchy hti ON (hti.parentid = cc.id AND hti.primarytype = 'textualInscriptionGroup')
         JOIN textualinscriptiongroup ins ON (ins.id = hti.id)
WHERE ins.inscriptioncontent IS NOT NULL
GROUP BY cc.id