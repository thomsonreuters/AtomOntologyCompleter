# Copyright 2018 Thomson Reuters
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

PACKAGE_ONTOLOGIES = require './ontologies.json'

module.exports =
  selector: '.source.turtle'
  disableForSelector: '.source.turtle .comment'
  inclusionPriority: 1
  suggestionPriority: 1
  filterSuggestions: true
  mergedOntologies: null
  localOntologies: null
  prefixCompletions: []

  localConfigChanged: ->
    localEnabled = atom.config.get('turtle-completer.enableLocalOntologies')
    value = atom.config.get('turtle-completer.localOntologyConfigFile')
    console.log "Config change #{localEnabled} for #{value}"
    try
      if localEnabled
        @localOntologies = require value
      else
        @localOntologies = null
    catch error
      console.log 'Unable to load ', value, error
    @loadOntologies()

  buildCompletionEntry: (prefix, ontology) ->
    text: prefix
    description: ontology.title
    descriptionMoreURL: ontology.spec

  loadOntologies: ->
    completions = []
    @mergedOntologies = []
    for key, ontology of PACKAGE_ONTOLOGIES
      @mergedOntologies[key] = ontology
    if @localOntologies?
      for key,ontology of @localOntologies
        completions.push(@buildCompletionEntry(key,ontology))
        @mergedOntologies[key] = ontology
    for key,ontology of @mergedOntologies
      if not @localOntologies? or key not of @localOntologies
        completions.push(@buildCompletionEntry(key,ontology))
    @prefixCompletions = completions

  loadOntology: (ontologyPrefix) ->
    if ontologyPrefix of @mergedOntologies
      try
        completions = require @mergedOntologies[ontologyPrefix].ontology
        @mergedOntologies[ontologyPrefix].completions = completions
      catch error
        console.log 'Unable to load ontology with prefix ', ontologyPrefix

  # there seems to be a bug with scopedescriptors not being correctly set
  # midline. For now, just look at the preceding text and make a decision
  # about which type of suggestion to offer based on whether there is a
  # turtle prefix
  getSuggestions: ({editor,bufferPosition,scopeDescriptor, prefix}) ->
    return [] if not prefix? or not prefix.length
    scopes = scopeDescriptor.getScopesArray()
      # return nothing if deep in a scope that isn't prefixed URIs
    return [] if scopes.length > 1 and
    not scopes.includes('entity.name.tag.prefixed-uri.turtle')
    lineToCursor = editor.getTextInRange([[bufferPosition.row, 0],
      bufferPosition])
    namespace = @determineNamespace(lineToCursor)
    if namespace? and namespace of @mergedOntologies
      if not @mergedOntologies[namespace].completions?
        @loadOntology(namespace)
      return @getMatches(@mergedOntologies[namespace].completions,prefix)
    else
      return @getMatches(@prefixCompletions,prefix)
    return []

  buildMatch: (match) ->
    text: match.text
    description: match.description
    descriptionMoreURL: match.descriptionMoreURL

  getMatches: (candidateArray, prefix) ->
    return [] if not candidateArray?
    matches = []
    for candidate in candidateArray when not prefix.trim() or
    firstCharsEqual(candidate.text,prefix)
      matches.push(@buildMatch(candidate))
    matches

  determineNamespace: (line) ->
    return null if not line?
    regex = /([\w]+):[^:\s]+$/
    match = regex.exec(line)
    return match?[1] or null

firstCharsEqual = (str1, str2) ->
  str1[0].toLowerCase() is str2[0].toLowerCase()
