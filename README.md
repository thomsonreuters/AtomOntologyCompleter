# Turtle Autocompleter package
[![dependencies Status](https://david-dm.org/thomsonreuters/AtomOntologyCompleter/status.svg)](https://david-dm.org/thomsonreuters/AtomOntologyCompleter)
[![Build Status](https://travis-ci.org/thomsonreuters/AtomOntologyCompleter.svg?branch=master)](https://travis-ci.org/thomsonreuters/AtomOntologyCompleter)
[![Installs!](https://img.shields.io/apm/dm/atom-clock.svg?style=flat-square)](https://atom.io/packages/turtle-completer)
[![Version!](https://img.shields.io/apm/v/atom-clock.svg?style=flat-square)](https://atom.io/packages/turtle-completer)
[![License](https://img.shields.io/apm/l/atom-clock.svg?style=flat-square)](https://github.com/thomsonreuters/AtomOntologyCompleter/blob/master/LICENSE)

This is an autocompleter for the [Atom](http://atom.io) editor, compatible with AutoComplete+ that knows common ontologies and will suggest predicates based on your typing.

Current ontologies are:
* [Activity Vocabulary](http://dublincore.org/documents/dcmi-terms/)
* [Metadata for Tabular Data](https://www.w3.org/TR/tabular-metadata/)
* [Data Catalog Vocabulary](https://www.w3.org/TR/vocab-dcat/)
* [Data Quality Vocabulary](http://www.w3.org/TR/vocab-dqv)
* [Data Usage Vocabulary](https://www.w3.org/TR/vocab-duv/#)
* [Dublin Core & Terms](http://dublincore.org/documents/dcmi-terms/)
* [Friend of a Friend](http://xmlns.com/foaf/spec/)
* [Ontology for Media Resources](https://www.w3.org/TR/2012/REC-mediaont-10-20120209/)
* [OWL](https://www.w3.org/TR/owl2-overview/)
* [RDFS](https://www.w3.org/TR/rdf-schema/)
* [SHapes Constraint Language](https://www.w3.org/TR/shacl/)
* [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html)
* [W3C Provenance](https://www.w3.org/TR/2013/REC-prov-o-20130430/)
* [Web Annotation Vocabulary](http://www.w3.org/TR/annotation-vocab/)

If you'd like others added either raise an issue on the atom package or do a pull request with the conversion. Contributions are greatly appreciated.  Note that the ontology is matched based on common prefixes.

Known ontologies are referenced from the file `ontologies.json` in `\lib`. Each ontology has a JSON file that contains the completion info.

To generate a new file, run `convert.py` over a ttl version of the ontology to generate the JSON.
