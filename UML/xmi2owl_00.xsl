<?xml version="1.0" encoding="UTF-8"?>

<!-- WARNING!! Pay attention what xmi/uml namespaces your source is using -->
<!--TODO: implement xmi/uml namespace handling mechanism-->

<!--xmlns:uml="http://www.omg.org/spec/UML/20131001"
	xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
	xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
	xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC"
-->

<!--
    xmlns:xmi="http://schema.omg.org/spec/XMI/2.1"
    xmlns:uml="http://schema.omg.org/spec/UML/2.1"
-->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    exclude-result-prefixes="xs math xd xsl uml xmi umldi dc"
    
    xmlns:uml="http://www.omg.org/spec/UML/20131001"
    xmlns:xmi="http://www.omg.org/spec/XMI/20131001"
    xmlns:umldi="http://www.omg.org/spec/UML/20131001/UMLDI"
    xmlns:dc="http://www.omg.org/spec/UML/20131001/UMLDC"
    
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    version="3.0">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 4, 2020</xd:p>
            <xd:p><xd:b>Author:Eugeniu Costetchi</xd:b> lps</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    
    <!-- Global variables   -->
    <xsl:output method="xml" encoding="UTF-8" byte-order-mark="no"
        indent="yes" cdata-section-elements="lines"/>
    
    <xsl:variable name="sourcedoc" select="/"/>
    <xsl:variable name="document-uri" select="document-uri(.)"/>
    <xsl:variable name="base-uri" select="'http://publications.europa.eu/ontology/eProcurement'"/>

    <xd:doc>
        <xd:desc>
            <xd:p>
                The document entry template
            </xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="dateStr" select="string(current-time())"/>
        <xsl:variable name="cleanStr" select="replace($dateStr, '([\D])', 'x')"/>
        <xsl:variable name="unique" select="xmi:XMI/uml:Model/@name"/>
        <xsl:variable name="id4ref" select="concat($unique, $cleanStr)"/>
        

        <!--<xsl:apply-templates select="XMI"/>-->

        <rdf:RDF>
            <xsl:call-template name="namespace-setter"/>
            
            <xsl:call-template name="elementLoop"/>
        </rdf:RDF>
    </xsl:template>

    <xd:doc>
        <xd:desc>Provides some namespaces</xd:desc>
    </xd:doc>
    <xsl:template name="namespace-setter">
        <xsl:namespace name="o" select="concat($base-uri,'#')"></xsl:namespace>
        <xsl:attribute name="xml:base" expand-text="true">{$base-uri}</xsl:attribute>                
    </xsl:template>
        
        
    <xd:doc>
        <xd:desc> Generic Ontology header </xd:desc>
    </xd:doc>
    <xsl:template name="ontology-header">
        <owl:Ontology rdf:about="">
            <owl:imports rdf:resource="http://purl.org/dc/terms/"/>
            <rdfs:comment xml:lang="en">This is the eProcurement ontology definition.</rdfs:comment>
            <dct:license rdf:resource="http://creativecommons.org/licenses/by-sa/3.0/"/>
            <rdfs:label xml:lang="en">eProcurement ontology</rdfs:label>
            <owl:versionInfo>eProcurement Ontology version 0.0.2 (auto generated)</owl:versionInfo>
            <dct:contributor rdf:resource="http://costezki.ro/eugeniu"/>
            <owl:imports rdf:resource="http://www.w3.org/2004/02/skos/core"/>
            <rdfs:seeAlso rdf:resource="https://op.europa.eu/en/web/eu-vocabularies/e-procurement"/>
            <dct:creator rdf:resource="http://publications.europa.eu/resource/authority/corporate-body/PUBL"/>
            <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date">2020-02-05</dct:modified>
        </owl:Ontology>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p> This template selects the known elements </xd:p>
        </xd:desc>
        <!--<xd:param name="rootElt"/>-->
    </xd:doc>

    <xsl:template name="elementLoop">
        <!--<xsl:param name="rootElt"/>-->
        <xsl:for-each
            select="//xmi:Extension/elements/element[@xmi:type = 'uml:Class']">            
            <xsl:variable name="className" select="@name"/>
            <xsl:variable name="idref" select="@xmi:idref"/>                    
            
            <xsl:call-template name="classDefinition">
                <xsl:with-param name="className" select="$className"/>
                <xsl:with-param name="idref" select="$idref"/>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p> This template creates a class definition </xd:p>
        </xd:desc>
        <xd:param name="className"/>
        <xd:param name="idref"/>
    </xd:doc>
    
    <xsl:template name="classDefinition">
        <xsl:param name="className"/>
        <xsl:param name="idref"/>

        
        <xsl:variable name="packageName" select="//packagedElement[@xmi:id = $idref]/../@name"/>
        
        <xsl:variable name="classURI" select="concat($packageName, ':', $className)"/>
        
         
        
        
        <owl:Class rdf:about="{$classURI}">
            
        </owl:Class>    
    </xsl:template>
    
</xsl:stylesheet>
