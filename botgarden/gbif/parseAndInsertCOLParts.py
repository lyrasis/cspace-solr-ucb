#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""originally this was parseNamesGBIF.py

"Use the GBIF name parser API (http://tools.gbif.org/nameparser/api.do) to
disect [sic] name strings into their components. Input should be a simple list of
name strings separated by newline-characters. The names can be read either
from textfile(s) or from <STDIN>.

Output will be written as JSON to <STDOUT> by default.

Usage: parseNamesGBIF.py filename1 [filename2 [...]]

from:

https://www.snip2code.com/Snippet/162694/Parse-taxon-names-with-Python--using-the"

However, I have hacked it substantially for this UCBG application, and it now takes three command line arguments,
caches the results, etc. etc.

... jblowe@berkeley.edu 4/6/2015

"""

import fileinput
import pickle
import requests
import re
import sys
import json
import time
import os
import csv


# empty class for counts
class count:
    pass


count.input = 0
count.output = 0
count.newnames = 0
count.source = 0
count.datasource = 0
count.cultivars = 0
count.cultivarsinoriginal = 0

numberWanted = 10
col_api_key = 'd0a905a9-75c9-466e-bbab-5b568f4e8b91'

parts = {}

# gbif
nameparts = ["authorsParsed",
             "authorship",
             "bracketAuthorship",
             "canonicalName",
             "canonicalNameComplete",
             "canonicalNameWithMarker",
             "genusOrAbove",
             "infraSpecificEpithet",
             "rankMarker",
             "scientificName",
             "cultivarEpithet",
             "specificEpithet",
             "type"]

# col
nameparts = ['NameId', 'ScientificName', 'ScientificNameWithAuthors',
     'Family', 'RankAbbreviation', 'NomenclatureStatusID',
     'NomenclatureStatusName', 'Symbol', 'Author',
     'DisplayReference', 'DisplayDate', 'TotalRows']


# from http://stackoverflow.com/questions/1158076/implement-touch-using-python
def touch(fname, times=None):
    with open(fname, 'a'):
        os.utime(fname, times)

def main():
    if len(sys.argv) < 4:
        print('usage: %s inputfileofnames.csv outputnameparts.csv picklefile column' % sys.argv[0])
        sys.exit(1)

    namecolumn = 0
    try:
        namecolumn = int(sys.argv[4])
    except:
        print("column is not an integer: %s " % sys.argv[4])
        sys.exit(1)

    try:
        namepartsfile = sys.argv[2]
        namepartsfh = csv.writer(open(namepartsfile, "w", encoding="utf-8"), delimiter='\t', quoting=csv.QUOTE_NONE,
                                 quotechar=chr(255))
        # namepartsfh.write('\t'.join(nameparts) + '\n')
    except:
        print("could not open output file")
        sys.exit(1)

    try:
        picklefile = sys.argv[3]
        picklefh = open(picklefile, "rb")
    except:
        print("could not open pickle file, will try to create")
        picklefh = open(picklefile, "wb")
        pickle.dump({}, picklefh)
        picklefh.close()
        picklefh = open(picklefile, "rb")

    try:
        parsednames = pickle.load(picklefh)
        picklefh.close()
        print("%s names in datasource." % len(parsednames.keys()))
    except:
        raise
        print("could not parse data in picklefile %s" % picklefile)
        sys.exit(1)

    try:
        inputfile = csv.reader(open(sys.argv[1], "r", encoding="utf-8"), delimiter='\t', quoting=csv.QUOTE_NONE,
                               quotechar=chr(255))
    except:
        raise
        print("could not open input file %s" % sys.argv[1])
        sys.exit(1)

    for cells in inputfile:
        count.input += 1
        name = cells[namecolumn]
        # handle cultivars without 'cv.'...
        # name = check4cultivars(name)
        if name in parsednames:
            count.source += 1
            row = parsednames[name]
        else:

            # do CoL search
            # params = urllib.urlencode({'name': taxon})
            colURL = "http://services.col.org/Name/Search"

            response = requests.get('https://api.catalogueoflife.org/nameusage/search', params={'q': name.replace('.', '%2E')})
            response.encoding = 'utf-8'
            ranks = 'kingdom phylum class order family genus species'.split(' ')
            try:
                names2use = response.json()
                if names2use['total'] != 0:
                    if 'Error' in names2use:
                        if names2use['Error'] != 'No names were found':
                            print('taxoneditor', 'ERROR: from CoL: %s' % names2use['Error'])
                        names2use = []
                    for n in names2use['result']:
                        if 'usage' in n:
                            if n['usage']['status'] == 'accepted':
                                break
                    names2use = n
                    usage = names2use['usage']
                    row = [usage['label'], usage['name']['id']]
                    try:
                        classification = names2use['classification']
                        for r in ranks:
                            value = ''
                            for n in classification:
                                if n['rank'] == r:
                                    value = n['name']
                            row.append(value)
                    except:
                        row += [''] * len(ranks)
                else:
                    continue
            except:
                raise
                print('name getter', 'ERROR: could not parse returned CoL JSON, or it was empty')
                name2use = []

            count.newnames += 1
            parsednames[name] = row

        if count.input == 1:
            row = [h + '_s' for h in ['name', 'id']+ ranks]
        cells = cells[:namecolumn] + row + cells[namecolumn:]
        namepartsfh.writerow(cells)

    try:
        pickle.dump(parsednames, open(picklefile, "wb"))
        count.datasource = len(parsednames.keys())
    except:
        print("could not write names to picklefile %s" % picklefile)
        sys.exit(1)

    print("%s names input." % count.input)
    print("%s parsenames output." % count.output)
    print("%s new names found." % count.newnames)
    print("%s names now in datasource." % count.datasource)
    print("%s cultivars indicated already (i.e 'cv.' in original)." % count.cultivarsinoriginal)
    print("%s total cultivars identified." % count.cultivars)

    print
    print('name parts:')
    for p in parts.keys():
        print("%s: %s" % (p, parts[p]))


if __name__ == '__main__':
    main()
