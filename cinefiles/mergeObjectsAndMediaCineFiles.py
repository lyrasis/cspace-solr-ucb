import sys
import collections
import csv

count = collections.defaultdict(int)
delim = '\t'
film_fields = '''film_id
film_name_id
doc_count
filmtitle
country
filmyear
director
filmlanguage
prodco
subject
genre
title_variations
prodco_id
film_updated_at'''.split('\n')

has = [
    ('biblio_s', 'bibliography'),
    ('bx_info_s', 'box info'),
    ('cast_cr_s', 'cast credits'),
    ('costinfo_s', 'cost info'),
    ('dist_co_s', 'distribution co'),
    ('filmog_s', 'filmography'),
    ('illust_s', 'illustrations'),
    ('prod_co_s', 'production co'),
    ('tech_cr_s', 'tech credits')
]

has_labels = ['has ' + has[i][1] for i in range(len(has))]


def open_file(filename, handle):
    try:
        f = open(filename, 'r', encoding='utf-8')
        return csv.reader(f, delimiter=delim, quoting=csv.QUOTE_NONE, quotechar=chr(255))
    except:
        raise
        print(f'couldn\'t open {handle} file {filename}')
        sys.exit(1)


MEDIA = open_file(sys.argv[1], 'media')
media = collections.defaultdict(dict)
for line in MEDIA:
    count['media'] += 1
    (objectcsid, objectnumber, mediacsid, description, filename, creatorrefname, creator, blobcsid, copyrightstatement,
     identificationnumber, rightsholderrefname, rightsholder, contributor, mimetype, md5) = line
    type = 'pdf' if mimetype == 'application/pdf' else 'image'
    if type not in media[objectcsid]:
        media[objectcsid][type] = []
    media[objectcsid][type].append(blobcsid)

LINK = open_file(sys.argv[2], 'link')
link = collections.defaultdict(list)
for line in LINK:
    count['link'] += 1
    (filmid, docid) = line[:2]
    link[docid].append(filmid)

LINK2 = open_file(sys.argv[3], 'link2')
link2 = {}
for line in LINK2:
    count['link2'] += 1
    (csid, docid) = line[:2]
    link2[docid] = csid

FILMS = open_file(sys.argv[4], 'films')
films = collections.defaultdict(tuple)
for line in FILMS:
    count['films'] += 1
    filmid = line[0]
    wanted_film_info = [line[i] for i in [3,6,4,5]]
    # TODO: what delimiters to use to join multiple values
    film_summary = [l.replace('|','; ') for l in wanted_film_info]
    films[filmid] = (film_summary, line)

METADATA = open_file(sys.argv[5], 'docs')
media['csid']['image'] = ['blob_ss']
media['csid']['pdf'] = ['pdf_ss']
link2['doc_id'] = 'csid'

try:
    outputfh = csv.writer(open(sys.argv[6], 'w', encoding='utf-8'), delimiter="\t", quoting=csv.QUOTE_NONE, quotechar=chr(255), escapechar='\\')
except:
    print("could not open output file for write %s" % sys.argv[5])
    parameters_ok = False

for line in METADATA:
    count['metadata'] += 1

    docid = line[0]
    # format 'Has X' values as a single multi-valued field
    if line[0] == 'doc_id':
        has = 'has'
    else:
        has = '|'.join([has_labels[i] for i,l in enumerate(line[12:21]) if l == 't'])

    # insert list of blobs and pdfs as final columns
    try:
        objectcsid = link2[docid]
    except:
        print(f'CSID for {docid} not found in links')
        count['docs unmatched with CSIDs'] += 1
        continue
    mediablobs = media[objectcsid]['image'] if 'image' in media[objectcsid] else []
    pdfblobs = media[objectcsid]['pdf'] if 'pdf' in media[objectcsid] else []
    filmids = link[docid]
    if (filmids != []):
        count['films matched'] += 1
        # TODO: what delimiters to use to join multiple values
        film_info = [' -- '.join(films[filmid][0]) for filmid in filmids if films[filmid][0] != '']
        if filmids[0] == 'film_id': film_info = ['film_info']
        film_facets = collections.defaultdict(set)
        film_field_values = []
        for filmid in filmids:
            for i, fld in enumerate(film_fields):
                film_facets[fld].add(films[filmid][1][i])
        for i, fld in enumerate(film_fields):
            film_field_values.append('|'.join([f for f in film_facets[fld]]))
    else:
        count['films unmatched'] += 1
        film_info = [] * 12
    film_info = '|'.join(film_info)

    if (mediablobs == []):
        count['media unmatched'] += 1

    else:
        count['media matched'] += 1

    outputfh.writerow(line + [has] + film_field_values + [film_info] + [objectcsid] + [','.join(mediablobs)] + [','.join(pdfblobs)])

for s in sorted(count):
    print(f'{s}: {count[s]}')
