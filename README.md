# Turtle Autocompleter package

This is an autocompleter for the [Atom](http://atom.io) editor, compatible with AutoComplete+ that knows common ontologies and will suggest predicates based on your typing.

Current ontologies are:
* [Activity Vocabulary](http://dublincore.org/documents/dcmi-terms/)
* [Metadata for Tabular Data](https://www.w3.org/TR/tabular-metadata/)
* [Data Catalog Vocabulary](https://www.w3.org/TR/vocab-dcat/)
* [Data Quality Vocabulary](http://www.w3.org/TR/vocab-dqv)
* [Dublin Core & Terms](http://dublincore.org/documents/dcmi-terms/)
* [FOAF](http://xmlns.com/foaf/spec/)
* [W3C Provenance](https://www.w3.org/TR/2013/REC-prov-o-20130430/)
* [RDFS](https://www.w3.org/TR/rdf-schema/)
* [SHACL](https://www.w3.org/TR/shacl/)
* [SKOS](https://www.w3.org/2009/08/skos-reference/skos.html)

If you'd like others added either raise an issue on the atom package or do a pull request with the conversion. Contributions are greatly appreciated.  Note that the ontology is matched based on common prefixes.

Known ontologies are referenced from the file `ontologies.json` in `\lib`. Each ontology has a JSON file that contains the completion info.

To generate a new file, run `convert.py` over a ttl version of the ontology to generate the JSON.
