SELECT DISTINCT cc.id,
                STRING_AGG(DISTINCT loc.loanoutnumber || ': ' ||
                                    CASE
                                        WHEN lop.loannotapprovedforpublic IS TRUE THEN '[not public] ' ELSE '' END ||
                                    CASE
                                        WHEN loc.borrower IS NULL OR loc.borrower = '' THEN 'unknown borrower'
                                        ELSE REGEXP_REPLACE(loc.borrower, '^.*\)''(.*)''$', '\1') END ||
                                    CASE
                                        WHEN (loc.loanpurpose ILIKE '%research%' OR loc.loanpurpose ILIKE '%teaching%') AND
                                             loc.borrowerscontact IS NOT NULL
                                            THEN '/' || REGEXP_REPLACE(loc.borrowerscontact, '^.*\)''(.*)''$', '\1')
                                        WHEN (loc.loanpurpose NOT ILIKE '%research%' AND
                                              loc.loanpurpose NOT ILIKE '%teaching%') OR loc.loanpurpose IS NULL OR
                                             loc.borrowerscontact IS NULL THEN '' END ||
                                    CASE
                                        WHEN sdg1.datedisplaydate IS NOT NULL AND sdg1.datedisplaydate <> '' AND
                                             sdg2.datedisplaydate IS NOT NULL AND sdg2.datedisplaydate <> ''
                                            THEN ' (' || sdg1.datedisplaydate || '–' || sdg2.datedisplaydate || ')'
                                        WHEN sdg1.datedisplaydate IS NOT NULL AND sdg1.datedisplaydate <> '' AND
                                             (sdg2.datedisplaydate IS NULL OR sdg2.datedisplaydate = '')
                                            THEN ' (' || sdg1.datedisplaydate || '–unknown)'
                                        WHEN (sdg1.datedisplaydate IS NULL OR sdg1.datedisplaydate = '') AND
                                             sdg2.datedisplaydate IS NOT NULL AND sdg2.datedisplaydate <> ''
                                            THEN ' (unknown–' || sdg2.datedisplaydate || ')'
                                        WHEN (sdg1.datedisplaydate IS NULL OR sdg1.datedisplaydate = '') AND
                                             (sdg2.datedisplaydate IS NULL OR sdg2.datedisplaydate = '')
                                            THEN ' (dates unknown)' END, '␥')                          AS loan_info_all_ss

FROM collectionobjects_common cc
         JOIN hierarchy h1 ON (h1.id = cc.id)
         JOIN relations_common rca ON (h1.name = rca.subjectcsid AND rca.objectdocumenttype = 'Loanout')
         JOIN hierarchy hlo ON (hlo.name = rca.objectcsid)
         JOIN loansout_common loc ON (hlo.id = loc.id)
         LEFT OUTER JOIN loansout_pahma lop ON (hlo.id = lop.id)
         JOIN misc mx ON (loc.id = mx.id AND mx.lifecyclestate = 'project')
         LEFT OUTER JOIN hierarchy h3 ON (h3.parentid = loc.id AND h3.name = 'loansout_pahma:loanOutDateGroup')
         LEFT OUTER JOIN structureddategroup sdg1 ON (h3.id = sdg1.id)
         LEFT OUTER JOIN hierarchy h4 ON (h4.parentid = loc.id AND h4.name = 'loansout_pahma:loanReturnDateGroup')
         LEFT OUTER JOIN structureddategroup sdg2 ON (h4.id = sdg2.id)
WHERE loc.loanoutnumber NOT ILIKE '%Proposed%'
  AND loc.loanoutnumber NOT ILIKE '%Cancelled%'
GROUP BY cc.id;
