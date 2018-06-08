# Run this script to generate the json configurationfor autocompletion
# The ontologies themselves are available from source, not stored in the project as duplicative

cat as.ttl | python convert.py "https://www.w3.org/TR/activitystreams-vocabulary/#dfn-" as > as.json
cat csvw.ttl | python convert.py "https://www.w3.org/TR/tabular-metadata/#" csvw > csvw.json
cat dc11.ttl | python convert.py "http://dublincore.org/documents/dcmi-terms/#terms-" dc11 > dc11.json
cat dcat.ttl | python convert.py "https://www.w3.org/TR/vocab-dcat/#" dcat > dcat.json
cat dcterms.ttl | python convert.py "http://dublincore.org/documents/dcmi-terms/#elements-" dcterms > dcterms.json
cat dqv.ttl | python convert.py "https://www.w3.org/TR/vocab-dqv/#dqv:" dqv > dqv.json
cat duv.ttl | python convert.py "https://www.w3.org/TR/vocab-duv/#" duv > duv.json
cat foaf.ttl | python convert.py "http://xmlns.com/foaf/spec/#" foaf > foaf.json
cat ma.ttl | python convert.py "https://www.w3.org/TR/2012/REC-mediaont-10-20120209/#" ma > ma.json
cat oa.ttl | python convert.py "https://www.w3.org/TR/annotation-vocab/#" oa > oa.json
cat odrl.ttl | python convert.py "https://www.w3.org/TR/odrl-vocab/#term-" odrl > odrl.json
cat owl.ttl | python convert.py "https://www.w3.org/TR/2012/REC-owl2-syntax-20121211/#a_" owl > owl.json
cat prov.ttl | python convert.py "https://www.w3.org/TR/2013/REC-prov-o-20130430/#" "" > prov.json
cat qb.ttl | python convert.py "https://www.w3.org/TR/vocab-data-cube/#dfn-qb-" qb > qb.json
cat rdf.ttl | python convert.py "https://www.w3.org/TR/2004/REC-rdf-mt-20040210/#" rdf > rdf.json
cat rdfs.ttl | python convert.py "https://www.w3.org/TR/rdf-schema/#ch_" rdfs > rdfs.json
cat ttl/rel.ttl | python convert.py "http://www.perceive.net/schemas/20031015/relationship/" rel > rel.json
cat rr.ttl | python convert.py "https://www.w3.org/ns/r2rml#" rr > rr.json
cat shacl.ttl | python convert.py "https://www.w3.org/TR/shacl/#" sh > shacl.json
cat skos.ttl | python convert.py "https://www.w3.org/2009/08/skos-reference/skos.html#" skos > skos.json
