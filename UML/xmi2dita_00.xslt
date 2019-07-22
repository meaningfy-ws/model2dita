<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:fn="http://www.w3.org/2005/xpath-functions" 
	xmlns:math="http://www.w3.org/2005/xpath-functions/math" 
	xmlns:array="http://www.w3.org/2005/xpath-functions/array" 
	xmlns:map="http://www.w3.org/2005/xpath-functions/map" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	xmlns:err="http://www.w3.org/2005/xqt-errors" 
	xmlns:uml="http://schema.omg.org/spec/UML/2.1" 
	xmlns:xmi="http://schema.omg.org/spec/XMI/2.1" 
	exclude-result-prefixes="#all">
	<xsl:output method="xml" doctype-public="-//OASIS//DTD DITA Reference//EN" doctype-system="technicalContent/dtd/reference.dtd" encoding="UTF-8" byte-order-mark="no" indent="yes"/>
	<xsl:variable name="sourcedoc" select="/"/>
	<xsl:variable name="document-uri" select="document-uri(.)"/>
	<xsl:variable name="in_filename" select="(tokenize($document-uri,'/'))[last()]"/>
<!--
    <xsl:strip-space elements="*" />
				<xsl:apply-templates/>

 match="/xmi:XMI/xmi:Extension/elements/element[@xmi:type='uml:Class']"
-->
    <xsl:template match="/">
		<xsl:variable name="dateStr" select="string(current-time())"/>
		<xsl:variable name="cleanStr" select="replace($dateStr,'([\D])','x')"/>
		<xsl:variable name="unique" select="xmi:XMI/uml:Model/@name"/>
		<xsl:variable name="id4ref" select="concat($unique,$cleanStr)"/>
		<xsl:variable name="docName" select="xmi:XMI/uml:Model/packagedElement/packagedElement[2]/@name"/>
        <xsl:element name="reference">
			<xsl:attribute name="id">
				<xsl:value-of select="$id4ref"/>
			</xsl:attribute>
			<xsl:element name="title">
				<xsl:value-of select="$docName"/>
			</xsl:element>
			<xsl:element name="refbody">
			<xsl:call-template name="TopLoop">
				<xsl:with-param name="rootElt" select="$sourcedoc" />
			</xsl:call-template>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="TopLoop">
		<xsl:param name="rootElt"/>
		<xsl:for-each select="$rootElt//xmi:XMI/xmi:Extension/elements/element[@xmi:type='uml:Class']">
			<xsl:element name="section">
				<title>
					<xsl:value-of select="@name"/>
				</title>
				<xsl:if test="properties/@documentation">
					<p>
						<xsl:value-of select="properties/@documentation"/>
					</p>
				</xsl:if>
				<xsl:if test="links/Generalization[1]">
					<p><i>Superclasses:</i></p>
					<sl>
						<xsl:for-each select="links/Generalization">
							<xsl:variable name="connectorId" select="@xmi:id"/>
							<sli>
								<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/source/model/@name"/>
							</sli>
						</xsl:for-each>
					</sl>
				</xsl:if>
				<xsl:if test="attributes">
					<table frame="all" colsep="1" rowsep="1">
						<title>Attributes</title>
						<tgroup cols="4" colsep="1" rowsep="1" outputclass="FormatA">
							<colspec colnum="1" colname="1" colwidth="22*"/>
							<colspec colnum="2" colname="2" colwidth="12*"/>
							<colspec colnum="3" colname="3" colwidth="10*"/>
							<colspec colnum="4" colname="4" colwidth="56*"/>
							<thead>
								<row rowsep="1">
									<entry colname="1">Name</entry>
									<entry colname="2">Type</entry>
									<entry colname="3">Cardinality</entry>
									<entry colname="4">Definition</entry>
								</row>
							</thead>
							<tbody>
								<xsl:for-each select="attributes/attribute">
									<row rowsep="1">
										<entry colname="1">
											<xsl:value-of select="@name"/>
										</entry>
										<entry colname="2">
											<xsl:value-of select="properties/@type"/>
										</entry>
										<entry colname="3">
											<xsl:value-of select="concat(bounds/@lower,'..',bounds/@upper)"/>
										</entry>
										<entry colname="4">
											<xsl:value-of select="documentation/@value"/>
										</entry>
									</row>
								</xsl:for-each>
							</tbody>
						</tgroup>
					</table>
				</xsl:if>
				<xsl:if test="links/Association[1] or links/Dependency[1]">
					<table frame="all" colsep="1" rowsep="1">
						<title>Connectors</title>
						<tgroup cols="4" colsep="1" rowsep="1" outputclass="FormatA">
							<colspec colnum="1" colname="1" colwidth="22*"/>
							<colspec colnum="2" colname="2" colwidth="12*"/>
							<colspec colnum="3" colname="3" colwidth="10*"/>
							<colspec colnum="4" colname="4" colwidth="56*"/>
							<thead>
								<row rowsep="1">
									<entry colname="1">Name</entry>
									<entry colname="2">Type</entry>
									<entry colname="3">Cardinality</entry>
									<entry colname="4">Notes</entry>
								</row>
							</thead>
							<tbody>
								<xsl:for-each select="links/Association">
									<row rowsep="1">
										<xsl:variable name="connectorId" select="@xmi:id"/>
										<entry colname="1">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
										</entry>
										<entry colname="2">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/properties/@ea_type"/>
										</entry>
										<entry colname="3">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/type/@multiplicity"/>
										</entry>
										<entry colname="4">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/documentation/text()"/>
										</entry>
									</row>
								</xsl:for-each>
								<xsl:for-each select="links/Dependency">
									<row rowsep="1">
										<xsl:variable name="connectorId" select="@xmi:id"/>
										<entry colname="1">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
										</entry>
										<entry colname="2">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/properties/@ea_type"/>
										</entry>
										<entry colname="3">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/type/@multiplicity"/>
										</entry>
										<entry colname="4">
											<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/documentation/text()"/>
										</entry>
									</row>
								</xsl:for-each>
							</tbody>
						</tgroup>
					</table>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
