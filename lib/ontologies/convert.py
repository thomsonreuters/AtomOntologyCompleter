# Copyright 2018 Thomson Reuters

# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Convert a turtle file to a JSON object suitable for the autocompleter
# For example:
# cat foaf.ttl | python convert.py "http://xmlns.com/foaf/spec/#" foaf > foaf.json

# Prefixes for documentation are found in ontologies.json
# Push turtle via cat

import sys
import re
import json

if len(sys.argv) < 3:
    sys.exit('Usage %s <documentation_url_base> <desired_prefix_to_extract>' % sys.argv[0])
urlPrefix=sys.argv[1]
desiredPrefix=sys.argv[2]
predicates = []
predicateRegex = re.compile(ur'^([^:\s]*):([a-zA-Z\-_]+)')
typeRegex = re.compile(ur'a (rdf|owl|rdfs|dcam):([\w]+)')
commentRegex = re.compile(ur'\s+(rdfs:comment|skos:definition|rdfs:label) \"([^\"]+)\"(@\w\w)?')
currentPredicate = None
for line in sys.stdin:
    predicateName = predicateRegex.match(line)
    if predicateName is not None and predicateName.group(1) == desiredPrefix:
        if currentPredicate is not None:
            currentPredicate['descriptionMoreURL']=urlPrefix+currentPredicate['text']
            predicates.append(currentPredicate)
        currentPredicate = {}
        currentPredicate['text'] = predicateName.group(2)
        # continue - no continue here since some specs the type is on the same line
    if currentPredicate is not None:
        predicateType = typeRegex.search(line)
        if predicateType is not None and 'type' not in currentPredicate:
            if predicateType.group(2) == 'Class' \
                or predicateType.group(2) == 'Datatype' \
                or predicateType.group(2) == 'VocabularyEncodingScheme':
                currentPredicate['type']='class'
            elif 'Property' in predicateType.group(2): # bit of a hack
                currentPredicate['type']='property'
            elif predicateType.group(2) == 'Resource':
                currentPredicate['type']='snippet'
            else:
                currentPredicate['type']='Something weird: '+predicateType.group(2)
            continue
        predicateComment = commentRegex.match(line)
        if predicateComment is not None and (predicateComment.group(3) is None or predicateComment.group(3) == '@en'):
            if 'description' not in currentPredicate:
                currentPredicate['description']=predicateComment.group(2)
            else:
                if predicateComment.group(1) != 'rdfs:label':   # permit rdfs:label as a fallback
                    currentPredicate['description']=predicateComment.group(2)

json.dump(predicates,sys.stdout,indent=3,sort_keys=True)
