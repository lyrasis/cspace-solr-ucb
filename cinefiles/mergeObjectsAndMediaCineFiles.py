import sys
import collections
import csv

count = collections.defaultdict(int)
count['media: pdf'] = 0
count['media: image'] = 0

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

has_labels = [has[i][1] for i in range(len(has))]


def open_file(filename, handle):
    try:
        f = open(filename, 'r', encoding='utf-8')
        return csv.reader(f, delimiter=delim, quoting=csv.QUOTE_NONE, quotechar=chr(255))
    except:
        raise


def make_associated_films(films, filmids):
    associated_films = []
    for filmid in filmids:
        if films[filmid][0] != '':
            film_info = []
            for i, e in enumerate(films[filmid][0]):
                if e == '':
                    e = 'No ' + films['film_id'][0][i].replace('film','') + ' known'
                # make href to film using film id if this is the title
                if i == 0:
                    e = f'{films[filmid][1][0]}++{e}++'
                elif i == 3:
                    year = e
                film_info.append(e)
            associated_films.append((year, ' — '.join(film_info)))

    return [e[1] for e in sorted(associated_films, key=lambda x: x[0])]


MEDIA = open_file(sys.argv[1], 'media')
media = collections.defaultdict(dict)
for line in MEDIA:
    count['media (images, pdfs)'] += 1
    (objectcsid, objectnumber, mediacsid, description, filename, creatorrefname, creator, blobcsid, copyrightstatement,
     identificationnumber, rightsholderrefname, rightsholder, contributor, mimetype, md5) = line
    type = 'pdf' if mimetype == 'application/pdf' else 'image'
    count[f'media: {type}'] += 1
    if type not in media[objectcsid]:
        media[objectcsid][type] = []
    media[objectcsid][type].append(blobcsid)

LINK = open_file(sys.argv[2], 'link')
link = collections.defaultdict(list)
for line in LINK:
    count['link'] += 1
    (filmid, docid) = line[:2]
    link[docid.strip()].append(filmid.strip())

LINK2 = open_file(sys.argv[3], 'link2')
link2 = {}
for line in LINK2:
    count['link2'] += 1
    (csid, docid, canonical_url) = line[:3]
    link2[docid.strip()] = (csid, canonical_url)

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
link2['doc_id'] = ('csid', 'canonical_url')

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
        objectcsid = link2[docid][0]
        canonical_url = link2[docid][1]
    except:
        print(f'CSID for {docid} not found in links')
        count['docs unmatched with CSIDs'] += 1
        continue
    mediablobs = media[objectcsid]['image'] if 'image' in media[objectcsid] else []
    pdfblobs = media[objectcsid]['pdf'] if 'pdf' in media[objectcsid] else []
    filmids = link[docid]

    if (filmids != []):
        count['documents matched one or more films'] += 1
        associated_films = make_associated_films(films, filmids)
        if filmids[0] == 'film_id': associated_films = ['film_info']
        film_facets = collections.defaultdict(set)
        for filmid in filmids:
            for i, fld in enumerate(film_fields):
                film_facets[fld].add(films[filmid][1][i])
        film_field_values = []
        for i, fld in enumerate(film_fields):
            uniques = set()
            for facets_values in film_facets[fld]:
                [uniques.add(f) for f in facets_values.split('|') if f != '']
            film_field_values.append('|'.join(sorted(uniques)))
    else:
        count['documents did not match a film'] += 1
        associated_films = [] * 12
        film_field_values = [''] * len(film_fields)
    associated_films = '|'.join(associated_films)

    if (mediablobs == []):
        count['media did not match a document'] += 1

    else:
        count['media matched a document'] += 1

    outputfh.writerow(line + [has] + film_field_values + [associated_films] + [objectcsid] + [canonical_url] + ['|'.join(mediablobs)] + ['|'.join(pdfblobs)])

for s in sorted(count):
    print(f'{s}: {count[s]}')
