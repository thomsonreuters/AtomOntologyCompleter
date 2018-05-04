# Run this script to generate the json configurationfor autocompletion
# The ontologies themselves are available from source, not stored in the project as duplicative

cat as.ttl | python convert.py "https://www.w3.org/TR/activitystreams-vocabulary/#dfn-" as > as.json
cat csvw.ttl | python convert.py "https://www.w3.org/TR/tabular-metadata/#" csvw > csvw.json
cat dc11.ttl | python convert.py "http://dublincore.org/documents/dcmi-terms/#terms-" dc11 > dc11.json
cat dcterms.ttl | python convert.py "http://dublincore.org/documents/dcmi-terms/#elements-" dcterms > dcterms.json
cat foaf.ttl | python convert.py "http://xmlns.com/foaf/spec/#" foaf > foaf.json
cat prov.ttl | python convert.py "https://www.w3.org/TR/2013/REC-prov-o-20130430/#" "" > prov.json
cat rdfs.ttl | python convert.py "https://www.w3.org/TR/rdf-schema/#ch_" rdfs > rdfs.json
cat shacl.ttl | python convert.py "https://www.w3.org/TR/shacl/#" sh > shacl.json
cat skos.ttl | python convert.py "https://www.w3.org/2009/08/skos-reference/skos.html#" skos > skos.json
