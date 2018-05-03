# Turtle Autocompleter package

This is an autocompleter for the Atom editor that knows common ontologies and will suggest predicates based on your typing.

Known ontologies are referenced from the file `ontologies.json` in `\lib`. Each ontology has a JSON file that contains the completion info. To generate a new file, run `convert.py` over a ttl version of the ontology to generate the json

