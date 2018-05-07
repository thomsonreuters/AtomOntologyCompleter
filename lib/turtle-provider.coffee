# Copyright 2018 Thomson Reuters
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

ONTOLOGIES = require './ontologies.json'

module.exports =
  selector: '.source.turtle'
  disableForSelector: '.source.turtle .comment'
  inclusionPriority: 1
  suggestionPriority: 1
  filterSuggestions: true
  ontologies: ONTOLOGIES
  ontologyCompletions: []

  loadOntologies: ->
    completions = []
    for key,ontology of @ontologies
      ontologyEntry = {}
      ontologyEntry.description = ontology.title
      ontologyEntry.descriptionMoreURL = ontology.spec
      ontologyEntry.text = key
      completions.push(ontologyEntry)
    @ontologyCompletions = completions;

  loadOntology: (ontologyPrefix) ->
    if ontologyPrefix of @ontologies
      completions = require @ontologies[ontologyPrefix].ontology
      @ontologies[ontologyPrefix].completions = completions

  getSuggestions: ({editor,bufferPosition,scopeDescriptor, prefix}) ->
    return [] if not prefix? or not prefix.length
    currentScope = scopeDescriptor.getScopesArray()
    candidateArray = null
    if currentScope.length < 2  # we're not sure of scope yet, so choose from ontologies.
      candidateArray = @ontologyCompletions
    else if currentScope.includes("entity.name.tag.prefixed-uri.turtle")
      namespace = @determineNamespace(editor.lineTextForBufferRow(bufferPosition.row))
      if namespace? and namespace of @ontologies
        if not @ontologies[namespace].completions?
          @loadOntology(namespace)
        candidateArray = @ontologies[namespace].completions;
    return @getMatches(candidateArray,prefix)

  buildMatch: (match, prefix) ->
    text: match.text
    description: match.description
    descriptionMoreURL: match.descriptionMoreURL
  #  replacementPrefix: prefix  # doesn't seem necessary

  getMatches: (candidateArray, prefix) ->
    return [] if not candidateArray?
    matches = []
    for candidate in candidateArray when not prefix.trim() or firstCharsEqual(candidate.text,prefix)
      matches.push(@buildMatch(candidate,prefix))
    matches

  determineNamespace: (line, position) ->
    regex = /([\w]+):[^:]+$/
    match = regex.exec(line)
    return match[1]

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
