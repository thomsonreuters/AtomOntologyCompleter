## 1.0.0
* Now supports the TriG serialization in addition to Turtle
## 0.6.0
* Fixed bug that suggestions wouldn't be provided mid-line
* Fixed bug in converter that wouldn't allow predicates with a number in. Thanks again to Stefan for reporting.
* More unit tests
* Added the relationship ontology

## 0.5.1
* Code and documentation clean up

## 0.5.0
* Added capability to load local ontologies
* Fixed convert.py to work on Python 2 or 3 (thanks again to Stefan for reporting that)

## 0.4.2
* Fixed rdf.json. Thanks to Stefan Münnich for the issue

## 0.4.1
* Updated README, patched for ontologies missed on checkin

## 0.4.0
* Added unit tests
* Now builds on travis.ci so we know the tests work
* Added OWL, Ontology for Media Resources, Data Usage Vocabulary, Web Annotation Vocabulary
* Data Cubes, RDF, R2RML, ODRL

## 0.3.0
* The growth of ontologies is slowing load time. Lazy loading, engage!
* Sometimes the completions wouldn't be accepted when you press enter. After rewriting in CoffeeScript I discovered that this is because you need to pass a copy of your suggestions to the provider API otherwise it seems to get confused

## 0.2.0
* Added Activity Streams, Tabular Metadata, DCAT, Data Quality Vocabulary

## 0.1.1
* License fixes, improved readme

## 0.1.0
* Initial release
