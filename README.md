# Turtle Autocompleter package
[![dependencies Status](https://david-dm.org/thomsonreuters/AtomOntologyCompleter/status.svg?style=flat-square)](https://david-dm.org/thomsonreuters/AtomOntologyCompleter)
[![Build Status](https://travis-ci.org/thomsonreuters/AtomOntologyCompleter.svg?branch=master&style=flat-square)](https://travis-ci.org/thomsonreuters/AtomOntologyCompleter)
[![Installs!](https://img.shields.io/apm/dm/atom-clock.svg?style=flat-square)](https://atom.io/packages/turtle-completer)
[![Version!](https://img.shields.io/apm/v/atom-clock.svg?style=flat-square)](https://atom.io/packages/turtle-completer)
[![License](https://img.shields.io/apm/l/atom-clock.svg?style=flat-square)](https://github.com/thomsonreuters/AtomOntologyCompleter/blob/master/LICENSE)
[![Gitter chat](https://badges.gitter.im/thomsonreuters/AtomOntologyCompleter.svg?style=flat-square)](https://gitter.im/thomsonreuters/AtomOntologyCompleter)

This is an autocompleter for the [Atom](http://atom.io) editor, compatible with [AutoComplete+](https://atom.io/packages/autocomplete-plus) that knows common ontologies and will suggest predicates based on your typing. Both the [Turtle](https://www.w3.org/TR/turtle/) and [TriG](https://www.w3.org/TR/trig/) serializations are supported.

![Short video of the completer in action](/docs/completer-sample-video.gif?raw=true)

Current ontologies are:
* [Activity Vocabulary](http://dublincore.org/documents/dcmi-terms/)
* [Metadata for Tabular Data](https://www.w3.org/TR/tabular-metadata/)
* [Data Catalog Vocabulary](https://www.w3.org/TR/vocab-dcat/)
* [Data Cubes](https://www.w3.org/TR/vocab-data-cube/)
* [Data Quality Vocabulary](http://www.w3.org/TR/vocab-dqv)
* [Data Usage Vocabulary](https://www.w3.org/TR/vocab-duv/#)
* [Dublin Core & Terms](http://dublincore.org/documents/dcmi-terms/)
* [Friend of a Friend](http://xmlns.com/foaf/spec/)
* [ODRL](https://www.w3.org/TR/odrl-vocab/)
* [Ontology for Media Resources](https://www.w3.org/TR/2012/REC-mediaont-10-20120209/)
* [OWL](https://www.w3.org/TR/owl2-overview/)
* [R2RML](http://www.w3.org/TR/2012/REC-r2rml-20120927/)
* [RDF](https://www.w3.org/TR/2004/REC-rdf-mt-20040210/)
* [RDFS](https://www.w3.org/TR/rdf-schema/)
* [Relationship](http://www.perceive.net/schemas/20031015/relationship/)
* [SHapes Constraint Language](https://www.w3.org/TR/shacl/)
* [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html)
* [W3C Provenance](https://www.w3.org/TR/2013/REC-prov-o-20130430/)
* [Web Annotation Vocabulary](http://www.w3.org/TR/annotation-vocab/)

If you'd like others added either raise an issue on the atom package, comment on gitter, tweet @nonodename or do a pull request with the conversion. Contributions are greatly appreciated.  Note that the ontology is matched based on common prefixes.

Known ontologies are referenced from the file `ontologies.json` in `\lib`. Each ontology has a JSON file that contains the completion info.

To generate a new file, run `convert.py` over a [ttl](https://en.wikipedia.org/wiki/Turtle_(syntax)) version of the ontology to generate the JSON. convert.py supports a few command line options, run without any parameters to see them.

Note that quality of anchor links into the specs varies on whether the naming convention for the anchors is sufficiently predictable. Feel free to fix any that are wrong in the relevant JSON file and do a pull request
to get added.

## Testing ontologies
To test a new ontology without the palaver of pull requests:
* Create a copy of the file ontologies.json in ``\lib``
* Convert your ontology to the JSON format required for the completer
* Update the ontologies.json file, setting the key to the desired prefix and
ontology attribute to the filename & path of the converted ontology.
* The spec, prefix and docprefix attributes aren't part of the code path so can
be ignored or completed as you wish
* Note that if you re-use a predefined prefix you'll override the built in
ontology

For example:
```
"tr":{
  "title":"My First ontology",
  "spec":"URL of the spec",
  "prefix":"tr",
  "docprefix":"URL prefix for documentation",
  "ontology":"/users/dan/ontologies/tr.json"
}
```
