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
typeRegex = re.compile(ur'a (rdf|owl|rdfs):([\w]+)')
commentRegex = re.compile(ur'\s+(rdfs:comment|skos:definition) \"([^\"]+)\"')
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
            if predicateType.group(2) == 'Class' or predicateType.group(2) == 'Datatype':
                currentPredicate['type']='class'
            elif predicateType.group(2) == 'Property' or predicateType.group(2) == 'ObjectProperty' \
                or predicateType.group(2) == 'AnnotationProperty'or predicateType.group(2) == 'DatatypeProperty':
                currentPredicate['type']='property'
            elif predicateType.group(2) == 'Resource':
                currentPredicate['type']='snippet'
            else:
                currentPredicate['type']='Something weird: '+predicateType.group(2)
            continue
        predicateComment = commentRegex.match(line)
        if predicateComment is not None and 'description' not in currentPredicate:
            currentPredicate['description']=predicateComment.group(2)

json.dump(predicates,sys.stdout,indent=3,sort_keys=True)
