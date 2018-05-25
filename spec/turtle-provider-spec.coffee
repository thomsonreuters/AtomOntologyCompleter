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

path = require 'path'

describe "Turtle autocompletions", ->
  [editor, provider] = []

  getCompletions = (options={}) ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])
    request =
      editor: editor
      bufferPosition: end
      scopeDescriptor: cursor.getScopeDescriptor()
      prefix: prefix
      activatedManually: options.activatedManually ? true
    provider.getSuggestions(request)

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('turtle-completer')
    waitsForPromise -> atom.packages.activatePackage('language-rdf')
    atom.config.set('turtle-completer.localOntologyConfigFile','')
    atom.config.set('turtle-completer.enableLocalOntologies',false)

    runs ->
      provider = atom.packages.getActivePackage('turtle-completer').
      mainModule.getProvider()

    #waitsFor -> atom.config.set('turtle-completer.enableLocalOntologies',false)
    waitsFor -> Object.keys(provider.mergedOntologies).length > 0
    waitsForPromise -> atom.workspace.open('test.ttl')
    runs -> editor = atom.workspace.getActiveTextEditor()

  it "returns no completions when text is empty", ->
    editor.setText('')
    expect(getCompletions().length).toBe 0
    editor.setText('d')
    editor.setCursorBufferPosition([0, 0])
    expect(getCompletions().length).toBe 0

  it "returns owl,odrl and oa as an option when text is o", ->
    editor.setText('o')
    completions = getCompletions()
    expect(completions.length).toBe 3
    expect(completions[0].text).toBe 'oa'
    expect(completions[1].text).toBe 'odrl'
    expect(completions[2].text).toBe 'owl'

  it "returns approporiate ontologies for owl when text is owl:Cl", ->
    editor.setText('owl:Cl')
    completions = getCompletions()
    expect(completions.length).toBe 3
    expect(completions[0].text).toBe 'Class'
    expect(completions[1].text).toBe 'cardinality'
    expect(completions[2].text).toBe 'complementOf'

    # the provider actually only matches on the first char and relies on the
    # underlying autocomplete+ to do the rest of the matching. So this test
    # might seem wrong but is right
  it "returns skos and shacl when sxyz is passed as prefix", ->
    editor.setText('sxyz')
    completions = getCompletions()
    expect(completions.length).toBe 2
    expect(completions[0].text).toBe 'sh'
    expect(completions[1].text).toBe 'skos'

  it "does not throw when an unrecognized ontology prefix is used", ->
    editor.setText('xyz')

    completions = []
    expect(-> completions = getCompletions()).not.toThrow()
    expect(completions.length).toBe 0

  it "does not throw or return suggestions when an odd prefix is used", ->
    editor.setText('dan:Be')

    completions = []
    expect(-> completions = getCompletions()).not.toThrow()
    expect(completions.length).toBe 0

  it "correctly overrides an ontology when the local option is enabled", ->
    editor.setText('foaf:A')
    completions = getCompletions()
    expect(completions.length).toBe 6
    expect(completions[0].text).toBe 'Agent'
    expect(completions[1].text).toBe 'aimChatID'
    expect(completions[2].text).toBe 'account'
    expect(completions[3].text).toBe 'accountServiceHomepage'
    expect(completions[4].text).toBe 'accountName'
    expect(completions[5].text).toBe 'age'

    packagePath = atom.packages.resolvePackagePath('turtle-completer')
    overrideFile = "#{packagePath}spec#{path.sep}ontology_override.json"
    console.log overrideFile
    atom.config.set('turtle-completer.localOntologyConfigFile',overrideFile)
    # Setting the override file shouldn't change anything
    completions = getCompletions()
    expect(completions.length).toBe 6
    expect(completions[0].text).toBe 'Agent'
    expect(completions[1].text).toBe 'aimChatID'
    expect(completions[2].text).toBe 'account'
    expect(completions[3].text).toBe 'accountServiceHomepage'
    expect(completions[4].text).toBe 'accountName'
    expect(completions[5].text).toBe 'age'

    atom.config.set('turtle-completer.enableLocalOntologies', true)
    # Now it should change
    completions = getCompletions()
    expect(completions.length).toBe 2
    expect(completions[0].text).toBe 'A2'
    expect(completions[1].text).toBe 'A3'

    atom.config.set('turtle-completer.enableLocalOntologies', false)
    # And this should go back
    completions = getCompletions()
    expect(completions.length).toBe 6
    expect(completions[0].text).toBe 'Agent'
    expect(completions[1].text).toBe 'aimChatID'
    expect(completions[2].text).toBe 'account'
    expect(completions[3].text).toBe 'accountServiceHomepage'
    expect(completions[4].text).toBe 'accountName'
    expect(completions[5].text).toBe 'age'
