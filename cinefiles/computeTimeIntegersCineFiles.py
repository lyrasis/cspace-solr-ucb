import sys, csv, re

delim = '\t'


def get_date_rows(row):
    date_rows = []
    for i, r in enumerate(row):
        if r in 'filmyear pubdate'.split(' '):
            row.append(r.replace('filmyear', 'film_year_i').replace('pubdate', 'pubdate_i'))
            date_rows.append(i)
    return date_rows


def get_year(date_value):
    try:
        return re.search('(\d{4}?)', date_value).group(0)
    except:
        return ''


with open(sys.argv[1], 'w') as f2:
    file_with_integer_times = csv.writer(f2, delimiter=delim, quoting=csv.QUOTE_NONE, quotechar=chr(255), escapechar='\\')
    reader = csv.reader(sys.stdin, delimiter=delim, quoting=csv.QUOTE_NONE, quotechar=chr(255))
    try:
        for i, row in enumerate(reader):
            if i == 0:
                date_rows = get_date_rows(row)
            else:
                for d in date_rows:
                    row.append(get_year(row[d]))
            file_with_integer_times.writerow(row)
    except:
        # really someday we should do something better than just die here...
        raise
        print('couldnt')
        exit()
