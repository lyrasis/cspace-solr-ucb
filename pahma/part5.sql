SELECT cc.id,
       regexp_replace(bd.item, E'[\\t\\n\\r]+', ' ', 'g') AS "objdescr_s"
FROM collectionobjects_common cc
         JOIN collectionobjects_common_briefdescriptions bd ON (bd.id = cc.id AND (bd.pos = 0 OR bd.pos IS NULL))
WHERE bd.item IS NOT NULL
