SELECT cc.id,
       cx.updatedat as updatedat_dt,
       cx.updatedat as updatedat_s
FROM collectionobjects_common cc
         JOIN collectionspace_core cx on cx.id = cc.id
         JOIN misc ON (cc.id = misc.id and misc.lifecyclestate <> 'deleted')
