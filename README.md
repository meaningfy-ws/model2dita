# model2dita
This repository contains a series of scripts to generate DITA documentation out of various technical files.

## What is DITA?

The Document Information Typing Architecture (DITA) is an XML data model for authoring and publishing. It is an [open standard](http://docs.oasis-open.org/dita/dita/v1.3/dita-v1.3-part3-all-inclusive.html) that is defined and maintained by the OASIS DITA Technical Committee.

Once the DITA source files are genereated with any of the scripts available in this repository, they need to be compiled/published into PDF, HTML, eBook and few other formats. To do that use any of the available DITA editors, few of which are listed below.

**Free:** 

* [XML Mind DITA editor](https://www.xmlmind.com/xmleditor/dita_editor.html)

**Paid:**

* Adobe Framemaker
* Oxygen

A comprehensive list of editors is found [here](https://www.dita-ot.org/) and [here](http://www.ditawriter.com/list-of-dita-optimized-editors/). 

## How does it work? 

1. _XML/XSD/RDF technical resource --> DITA technical documentation (source file)_
1. _DITA technical documentation (source file) --> publication format (PDF, HTML, DOC, eBook, etc.)_

The general idea is to produce DITA XML files from the technical files such as UML diagrams (XMI format), OWL ontologies, XSD schemas and other assets. Once the DITA source file is generated it can be published in any of the desired output formats. 

This repository is intended to provide the means to generate DITA files from other technical files serialised as XML, XSD or RDF. 

For XML/XSD technical files use the XSLT transformation stylesheets. Basic instructions on running an XSLT script are found here [here](https://www.loc.gov/ead/XSLTbasics.pdf).

# Available scripts 

## Application profile documentation based on a UML class diagram

**Script file:** 
`/UML/xmi2dita_00.xslt`

**Input format:**
`UML v2.1 (XMI v2.1)`  

**Output format:**
`Application Profile documentation of the UML model in DITA 1.3 technical documentation standard`

If you have a UML class diagram it can be transformed into a DITA document structured as a description of an Application Profile (AP), explained [here](http://www.ariadne.ac.uk/issue/25/app-profiles/) and described [here](http://www.dublincore.org/specifications/dublin-core/profile-guidelines/) and [here](http://www.dublincore.org/specifications/dublin-core/application-profile-guidelines/). 

