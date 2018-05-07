/* Copyright 2018 Thomson Reuters
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
const ontologies = require("./ontologies.json");
const ontologyCompletions = [];

module.exports =
class TurtleProvider {
  constructor() {
    this.selector = '.source.turtle'
    this.disableForSelector = '.source.turtle .comment'
    this.inclusionPriority = 1
    this.suggestionPriority = 1
    //this.excludeLowerPriority = true
    this.filterSuggestions = false
  //  this.showIcon = ['Symbol', 'Subsequence'].includes(atom.config.get('autocomplete-plus.defaultProvider'))
  }

  loadOntologies(){
    Object.keys(ontologies).forEach(function(key, index){
      var completions = require(ontologies[key].ontology)
      ontologies[key].completions = completions
      var ontologyEntry = {}
      ontologyEntry.description = ontologies[key].title;
      ontologyEntry.descriptionMoreURL = ontologies[key].spec;
      ontologyEntry.text = key;
      ontologyCompletions.push(ontologyEntry);
    },ontologies);
  }


  getSuggestions({editor,bufferPosition,scopeDescriptor, prefix}) {
    if (!(prefix != null ? prefix.length : undefined)) { return []}
    var currentScope = scopeDescriptor.getScopesArray();
    var candidateArray = null;
    if(currentScope.length < 2){ // we're not sure of scope yet, so choose from ontologies.
      candidateArray = ontologyCompletions;
    } else if (currentScope.includes("entity.name.tag.prefixed-uri.turtle")) {
      var namespace = this.determineNamespace(editor.lineTextForBufferRow(bufferPosition.row));
      if(namespace && namespace in ontologies)
        candidateArray = ontologies[namespace].completions;
    }
    return this.getMatches(candidateArray,prefix);

  }

  getMatches(candidateArray, prefix){
    if(candidateArray == null) {return []}
    var matches = [];
    candidateArray.forEach(function(element){
      if(firstCharsEqual(element.text,prefix))
        matches.push(element);
    });
    return matches;
  }
  determineNamespace(line, position){
    var regex = /([\w]+):[^:]+$/;
    var match = regex.exec(line);
    return match[1];
  }

/*  onDidInsertSuggestion({editor}) {
    return atom.commands.dispatch(atom.views.getView(editor), 'snippets:expand')
  }*/
}

const firstCharsEqual = (str1, str2) => str1[0].toLowerCase() === str2[0].toLowerCase()
