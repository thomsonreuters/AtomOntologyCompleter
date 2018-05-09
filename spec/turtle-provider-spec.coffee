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

    runs ->
      provider = atom.packages.getActivePackage('turtle-completer').
      mainModule.getProvider()

    waitsFor -> Object.keys(provider.ontologies).length > 0
    waitsForPromise -> atom.workspace.open('test.ttl')
    runs -> editor = atom.workspace.getActiveTextEditor()

  it "returns no completions when text is empty", ->
    editor.setText('')
    expect(getCompletions().length).toBe 0
    editor.setText('d')
    editor.setCursorBufferPosition([0, 0])
    expect(getCompletions().length).toBe 0

  it "returns owl and oa as an option when text is o", ->
    editor.setText('o')
    completions = getCompletions()
    expect(completions.length).toBe 2
    expect(completions[0].text).toBe 'oa'
    expect(completions[1].text).toBe 'owl'

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
