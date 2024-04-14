# neopiler


A Toolkit?
A Compiler?
The "tool", the "target" (shall borrow from ANTLR terminology?)

### Folders:

* `src`: core
* `toolkit` accumulates tools: hierarchical
* `tests/`* each increment's tests (TDD)
* `examples/`* each increment's IO

### Terms: (glossary)
* *Toolkit*: plugins, and tools, outside the core one. Used only if referred to.
* rflo
* ndbranch: a possibility
* roper: Roper (Templator/Roperator)
* hchain: HChain
* icode: ICode (IR, IC, Code)

* driver: Driver: drives the flow (Flow/movement driver): "lower"-er
* a barrier (various types of sync, bottleneck, temporality filter)
* a split (for separating )
* a join (combining separate concerns)

* subsyntax: See toolkits
* blocks (subsyntax zones)
* "host language": is neopiler (aka neopile, neo, neop) itself

### Some language keywords:
(Not final)
   * `code`, `data`

### Toolkits
User can define new (sub-) syntaxes.

Toolkits for a hierarchy.
They will add it as a hierarchy folder in ./toolkit. They may need to provide ANTLR file, etc. It will be added to the main toolkit-repository (keep int he same repo). But they may add their own custom ones too.

Example: (see `examples/sample1/sample1.neo` )
```
use syntax css.cstring
```

They can use these for syntax highlighting, Language Server, etc.
The usecase is DSL, literals, ic, but much more.
Even potentially adding (or selecting) core languages in their repo.

These sublanguages are used in blocks (aka zones).
Each has a detector / detector pattern in the host language (.neo).

### Inspirarions
Other than, of course, C++.
* VHDL
* Lean4
