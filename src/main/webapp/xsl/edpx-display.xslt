<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>EDPX display</title>
			</head>
			<body>
					<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="propGroup">
		<table border="1">
		<caption><b><xsl:value-of select="@name"/></b> 
			<xsl:if test="@version"> v<xsl:value-of select="@version"/></xsl:if>, 
			<xsl:if test="@prefix">prefix = <xsl:value-of select="@prefix"/>, </xsl:if>
			<xsl:if test="@extends">extends <xsl:value-of select="@extends"/></xsl:if></caption>
		<xsl:if test="prop">
			<thead>
				<tr bgcolor="#DDDDDD">
					<th>short property name</th>
					<th>value</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates/>
			</tbody>
		</xsl:if>

		</table>
		<br></br>
	</xsl:template>
	
	<xsl:template match="prop">
		<xsl:variable name="docRef" select="@docRef"/>
		<tr>
			<td><a href="{$docRef}"><xsl:value-of select="@name"/></a></td>
			<td><xsl:value-of select="."/></td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
