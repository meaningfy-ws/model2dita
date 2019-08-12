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
	<xsl:output method="xml" doctype-public="-//OASIS//DTD DITA Reference//EN" doctype-system="technicalContent/dtd/reference.dtd" encoding="UTF-8" byte-order-mark="no" indent="yes" cdata-section-elements="lines"/>
	<xsl:variable name="sourcedoc" select="/"/>
	<xsl:variable name="document-uri" select="document-uri(.)"/>
	<xsl:variable name="in_filename" select="(tokenize($document-uri,'/'))[last()]"/>
<!--
		<xsl:variable name="prefix" select="xmi:XMI/uml:Model/packagedElement/packagedElement[1]/@name"/>

-->
    <xsl:template match="/">
		<xsl:variable name="dateStr" select="string(current-time())"/>
		<xsl:variable name="cleanStr" select="replace($dateStr,'([\D])','x')"/>
		<xsl:variable name="unique" select="xmi:XMI/uml:Model/@name"/>
		<xsl:variable name="id4ref" select="concat($unique,$cleanStr)"/>
        <xsl:element name="reference">
			<xsl:attribute name="id">
				<xsl:value-of select="$id4ref"/>
			</xsl:attribute>
			<xsl:element name="title">
				<xsl:value-of select="$in_filename"/>
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
		<xsl:for-each select="$rootElt//xmi:XMI/xmi:Extension/elements/element[@xmi:type='uml:Class' or @xmi:type='uml:DataType']">
			<xsl:variable name="secName" select="@name"/>
			<xsl:element name="section">
				<title>
					<xsl:value-of select="$secName"/>
				</title>
				<xsl:if test="properties/@documentation">
					<!--<xsl:variable name="doc" select="fn:tokenize(properties/@documentation,'&#xA;')"/>
					<xsl:for-each select="$doc">

						<xsl:if test=".!=''">
							<p>
								<xsl:value-of select="."/>
							</p>
						</xsl:if>
					</xsl:for-each>-->
					<xsl:variable name="doc0" select="fn:replace(properties/@documentation,'&lt;a href','&lt;p&gt;&lt;xref scope=&#x0022;external&#x0022; href')"/>
					<xsl:variable name="doc1" select="fn:replace($doc0,'&lt;/a&gt;','&lt;/xref&gt;&lt;/p&gt;')"/>
					<xsl:variable name="doc2" select="fn:replace($doc1,'font color','foreign otherprops')"/>
					<xsl:variable name="doc3" select="fn:replace($doc2,'&lt;/font&gt;','&lt;/foreign&gt;')"/>
					<xsl:variable name="doc4" select="fn:replace($doc3,'nbsp','#x00A0')"/>
					<xsl:variable name="doc" select="fn:replace($doc4,'\$inet://','')"/>
					<xsl:value-of select="$doc" disable-output-escaping="yes"/>
				</xsl:if>
				<xsl:variable name="array" as="element()*">
					<xsl:for-each select="links/Generalization">
						<xsl:variable name="connectorId" select="@xmi:id"/>
						<xsl:variable name="connectorName" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
						<xsl:choose>
							<xsl:when test="$connectorName!=$secName">
								<Item><xsl:value-of select="fn:number(1)"/></Item>
							</xsl:when>
							<xsl:otherwise>
								<Item><xsl:value-of select="fn:number(0)"/></Item>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="valueArray" select="fn:sum($array)"/>
				<xsl:if test="$valueArray&gt;0">
					<p>Superclasses:</p>
					<xsl:element name="sl">
						<xsl:for-each select="links/Generalization">
							<xsl:variable name="connectorId" select="@xmi:id"/>
							<xsl:variable name="connectorName" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
							<xsl:if test="$connectorName!=$secName">
								<sli>
									<xsl:value-of select="$connectorName"/>
								</sli>
							</xsl:if>
						</xsl:for-each>
					</xsl:element>
				</xsl:if>

				<xsl:if test="attributes or links/Association[1] or links/Dependency[1]">
					<table frame="all" colsep="1" rowsep="1">
						<title>Properties</title>
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
									<xsl:variable name="doc" select="fn:tokenize(documentation/@value,'&#xA;')"/>
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
											<xsl:for-each select="$doc">
												<xsl:if test=".!=''">
													<p>
														<xsl:value-of select="."/>
													</p>
												</xsl:if>
											</xsl:for-each>
										</entry>
									</row>
								</xsl:for-each>
								<xsl:for-each select="links/Association">
									<xsl:variable name="connectorId" select="@xmi:id"/>
									<xsl:variable name="modelNameTarget" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
									<xsl:variable name="modelNameSource" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/source/model/@name"/>
									<xsl:if test="$modelNameTarget!=$secName or $modelNameSource=$modelNameTarget">
										<xsl:variable name="doc0" select="fn:replace(/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/documentation/@value,'&lt;a href','&lt;p&gt;&lt;xref scope=&#x0022;external&#x0022; href')"/>
										<xsl:variable name="doc1" select="fn:replace($doc0,'&lt;/a&gt;','&lt;/xref&gt;&lt;/p&gt;')"/>
										<xsl:variable name="doc2" select="fn:replace($doc1,'font color','foreign otherprops')"/>
										<xsl:variable name="doc3" select="fn:replace($doc2,'&lt;/font&gt;','&lt;/foreign&gt;')"/>
										<xsl:variable name="doc4" select="fn:replace($doc3,'nbsp','#x00A0')"/>
										<xsl:variable name="doc" select="fn:replace($doc4,'\$inet://','')"/>
<!--
										<xsl:variable name="doc" select="fn:tokenize(/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/documentation/@value,'&#xA;')"/>
-->
										<row rowsep="1">
											<entry colname="1">
												<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/@name"/>
											</entry>
											<entry colname="2">
												<xsl:value-of select="$modelNameTarget"/>
											</entry>
											<entry colname="3">
												<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/type/@multiplicity"/>
											</entry>
											<entry colname="4">
												<!--
												<xsl:for-each select="$doc">
													<xsl:if test=".!=''">
														<p>
															<xsl:value-of select="." disable-output-escaping="yes"/>
														</p>
													</xsl:if>
												</xsl:for-each>
												-->
												<xsl:value-of select="$doc" disable-output-escaping="yes"/>
											</entry>
										</row>
									</xsl:if>
								</xsl:for-each>
								<xsl:for-each select="links/Dependency">
									<xsl:variable name="connectorId" select="@xmi:id"/>
									<xsl:variable name="modelNameTarget" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/model/@name"/>
									<xsl:variable name="modelNameSource" select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/source/model/@name"/>
									<xsl:if test="$modelNameTarget!=$secName or $modelNameSource=$modelNameTarget">
										<xsl:variable name="doc0" select="fn:replace(/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/documentation/@value,'&lt;a href','&lt;p&gt;&lt;xref scope=&#x0022;external&#x0022; href')"/>
										<xsl:variable name="doc1" select="fn:replace($doc0,'&lt;/a&gt;','&lt;/xref&gt;&lt;/p&gt;')"/>
										<xsl:variable name="doc2" select="fn:replace($doc1,'font color','foreign otherprops')"/>
										<xsl:variable name="doc3" select="fn:replace($doc2,'&lt;/font&gt;','&lt;/foreign&gt;')"/>
										<xsl:variable name="doc4" select="fn:replace($doc3,'nbsp','#x00A0')"/>
										<xsl:variable name="doc" select="fn:replace($doc4,'\$inet://','')"/>
<!--
										<xsl:variable name="doc" select="fn:tokenize(/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/documentation/@value,'&#xA;')"/>
-->
										<row rowsep="1">
											<entry colname="1">
												<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/@name"/>
											</entry>
											<entry colname="2">
												<xsl:value-of select="$modelNameTarget"/>
											</entry>
											<entry colname="3">
												<xsl:value-of select="/xmi:XMI/xmi:Extension/connectors/connector[@xmi:idref=$connectorId]/target/type/@multiplicity"/>
											</entry>
											<entry colname="4">
												<!--
												<xsl:for-each select="$doc">
													<xsl:if test=".!=''">
														<p>
															<xsl:value-of select="." disable-output-escaping="yes"/>
														</p>
													</xsl:if>
												</xsl:for-each>
												-->
												<xsl:value-of select="$doc" disable-output-escaping="yes"/>
											</entry>
										</row>
									</xsl:if>
								</xsl:for-each>
							</tbody>
						</tgroup>
					</table>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
