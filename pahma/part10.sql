SELECT cc.id,
       regexp_replace(com.item, E'[\\t\\n\\r]+', ' ', 'g') AS "objcomment_s"
FROM collectionobjects_common cc
         JOIN collectionobjects_common_comments com ON (com.id = cc.id AND (com.pos = 0 OR com.pos IS NULL))