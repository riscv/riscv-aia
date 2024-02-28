# RISC-V Documentation Resources
This repository (repo) contains the resources needed to build docs with the RISC-V themes, fonts, and logos.

Specification repos created after January 2022 are generally created from the 
[docs-spec-template](https://github.com/riscv/docs-spec-template) repository and will 
have all the requisites parts included in a basic document.

Older repos can be updated with 3 basic steps:

1. Update the directory structure to reference the docs-resources, (this) repository.
2. Update the main AsciiDoc source file to include new variables needed for build.
3. Update the `Makefile` to build using the new resources.

## Updating the directory structure
The three main directories in this repo contain various components of the RISC-V documentation
template. The `docs-resources/images/` directory has artwork like the RISC-V logo. The `docs-resources/fonts/` 
directory contains the necessary fonts.  And, the `docs-resources/themes/` directory contains the YAML file 
for configuring the document.

In order to be able to link a repo with this project, you must use 
[Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules).  While there are many ways to do this, 
we will take the simplest approach and use the submodule defaults, 
placing a `docs-resources/` directory in the repo head.  This can be accomplished by executing
the following command in the top project directory (assuming http access):

```
git submodule add https://github.com/riscv/docs-resources.git
```

This command will create a `docs-resources/` directory when completed.  Additionally, the `git status` 
command should show new files of `docs-resources` and either a new or modified file of `.gitmodules` 
depending upon whether Git Submodules are already in use in the project.

**Note:** The use of Submodules creates a “link” in Git between projects that are tied to 
specific commit id.  This provides “safety” for the including projects by making sure that 
they don’t inadvertently get broken.  However, it creates an additional maintenance responsibility 
to intermittently rebase the link and verify that nothing has been broken.  Project maintainers need to 
understand this and plan accordingly.

## Updating the main AsciiDoc source file
From the `Makefile`, find the main AsciiDoc file that is used to build the project.  
It usually has the same base name as the .pdf which is generated.

Open this file and ensure that the following variables are added to top the document:

```
// These variables need customization for the specification
:description: Short, text description of spec…
:revdate:  Month day, Year
:revnumber: X.Y.Z
:revremark: This document is in Development state.  Change should be expected.

// These variables should not require customization
:company: RISC-V
:url-riscv: http://riscv.org
:doctype: book
:preface-title: Preamble
:colophon:
:appendix-caption: Appendix
:title-logo-image: image:docs-resources/images/risc-v_logo.svg[pdfwidth=3.25in,align=center]
// Settings:
:experimental:
:reproducible:
:WaveDromEditorApp: wavedrom-cli
:icons: font
:lang: en
:listing-caption: Listing
:sectnums:
:sectnumlevels: 5
:toclevels: 5
:toc: left
:source-highlighter: pygments
ifdef::backend-pdf[]
:source-highlighter: coderay
endif::[]
:data-uri:
:hide-uri-scheme:
:stem: latexmath
:footnote:
:xrefstyle: short 
```

The variables in the first section above should be visited and updated as appropriate.
Additionally, any variables which already exist in the document should be evaluated 
for the better value, which most likely is the template value specified above for anything 
in the document.

## Updating the `Makefile`
Typical build invocations for basic AsciiDoc builds look like this:

```
%.pdf: %.adoc
	asciidoctor-pdf $<
```

To build using the RISC-V template, this statement needs to look like this:
```
%.pdf: %.adoc
asciidoctor-pdf \
  -a toc \
  -a compress \
  -a pdf-style=docs-resources/themes/riscv-pdf.yml \
  -a pdf-fontsdir=docs-resources/fonts \
  -o $@ $<
```

**Note:** if you want to include a bibliography, you can include a 
“-r asciidoctor-bibtex” statement.  Likewise, to use various diagramming 
capabilities, you can include “-r asciidoctor-diagram”.

## Additional items to consider for the document

### License and copyright statements
While making updates to documents, ensure that a License statement is included near the front
of the document, preferably in the Preamble.  The Asciidoc text for this should look something like this:

```
[NOTE]
.Copyright and licensure:
====
This work is licensed under a
link:http://creativecommons.org/licenses/by/4.0/[Creative Commons Attribution 4.0 International License].

This work is Copyright 2022 by RISC-V International.
==== 
```

### Document state markings
Document state should be reflected in the `:revmark:` variable and be contained in 
an in-document admonition statement near the front of the document (Preface or Preamble).  

The recommended values for `:revmark:` and the front matter admonition based on the document 
state are as follows:

* For **Discussion Document** state, use:
  * `:revmark: This document is in Discussion state.  Change should be expected.`
  * Formal admonition text:
    ```
    [WARNING]
    .This document is in the link:http://riscv.org/spec-state[Discussion state]
    ====
    Assume everything can change. This document is not complete yet and was created only 
    for the purpose of conversation outside of the document.
    ====
    ```
* For **Development** state, use:
  * `:revmark: This document is in Development state.  Change should be expected.`
  * Formal admonition text:
    ```
    [WARNING]
    .This document is in the link:http://riscv.org/spec-state[Development state]
    ====
    Assume everything can change. This draft specification will change before being accepted 
    as standard, so implementations made to this draft specification will likely not conform 
    to the future standard.
    ====
    ```
* For **Stable** state, use:
  * `:revmark: This document is in Stable state.  Assume it may change.`
  * Formal admonition text:
    ```
    [WARNING]
    .This document is in the link:http://riscv.org/spec-state[Stable state]
    ====
    Assume anything could still change, but limited change should be expected.
    ====
    ```
* For **Frozen** state, use:
  * `:revmark: This document is in Frozen state.  Change is extremely unlikely.`
  * Formal admonition text:
    ```
    [WARNING]
    .This document is in the link:http://riscv.org/spec-state[Frozen state]
    ====
    Change is extremely unlikely. A high threshold will be used, and a change 
    will only occur because of some truly critical issue being identified during 
    the public review cycle. Any other desired or needed changes can be the subject 
    of a follow-on new extension.
    ====
    ```
* For **Ratified** state, use:
  * `:revmark: This document is in Ratified state.  No changes are allowed.`
  * Formal admonition text:
    ```
    [WARNING]
    .This document is in the link:http://riscv.org/spec-state[Ratified state]
    ====
    No changes are allowed. Any desired or needed changes can be the subject 
    of a follow-on new extension. Ratified extensions are never revised.
    ====
    ```
  
 # Additional information
 For additional information, see the [docs-dev-guide/example.pdf](https://github.com/riscv/docs-dev-guide/blob/main/example.pdf) or reach out to 
 help@riscv.org.
