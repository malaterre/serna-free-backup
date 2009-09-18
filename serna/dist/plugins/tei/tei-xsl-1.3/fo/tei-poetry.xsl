<!-- to deal with

THROUGH argument
THROUGH bibl   
THROUGH epigraph
THROUGH group   
THROUGH name    
THROUGH salute
THROUGH signed  
THROUGH trailer
-->
<!-- 
TEI XSLT stylesheet family version 1.3
RCS: $Date: 2003/11/24 14:49:48 $, $Revision: 1.1 $, $Author: ilia $

XSL FO stylesheet to format TEI XML documents 

 Copyright 1999-2002 Sebastian Rahtz/Oxford University  <sebastian.rahtz@oucs.ox.ac.uk>

 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and any associated documentation files (the
 ``Software''), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be included
 in all copies or substantial portions of the Software.
 
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  >
<!-- special purpose
 domain-specific elements, whose interpretation
 is open to all sorts of questions -->


<xsl:template match="div[@type='frontispiece']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='epistle']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='illustration']">
 <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='canto']">
  <xsl:variable name="divlevel" select="count(ancestor::div)"/>
  <xsl:call-template name="NumberedHeading">
    <xsl:with-param name="level"><xsl:value-of select="$divlevel"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="div[@type='dedication']">
  <xsl:variable name="divlevel" select="count(ancestor::div)"/>
  <xsl:call-template name="NumberedHeading">
    <xsl:with-param name="level"><xsl:value-of select="$divlevel"/></xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="byline">
 <fo:block text-align="center">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="epigraph">
 <fo:block 	
	text-align="center"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	start-indent="{$exampleMargin}">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="closer">
 <fo:block 	
	space-before.optimum="4pt"
	space-after.optimum="4pt">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="salute">
 <fo:block  text-align="left">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="signed">
 <fo:block  text-align="left">
   <xsl:apply-templates/>
 </fo:block>
</xsl:template>

<xsl:template match="epigraph/lg">
    <fo:block 
	text-align="center"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	>
      <xsl:apply-templates/>
    </fo:block>
</xsl:template>


<xsl:template match="l">
 <fo:block 	
	space-before.optimum="0pt"
	space-after.optimum="0pt">
   <xsl:choose>
   <xsl:when test="starts-with(@rend,'indent(')">
    <xsl:attribute name="text-indent">
      <xsl:value-of select="concat(substring-before(substring-after(@rend,'('),')'),'em')"/>
    </xsl:attribute>
  </xsl:when>
  <xsl:when test="starts-with(@rend,'indent')">
    <xsl:attribute name="text-indent">1em</xsl:attribute>
  </xsl:when>
  </xsl:choose>
  <xsl:apply-templates/>
 </fo:block> 
</xsl:template>

<xsl:template match="lg">
    <fo:block 
	text-align="start"
	space-before.optimum="4pt"
	space-after.optimum="4pt"
	>
      <xsl:apply-templates/>
    </fo:block>
</xsl:template>

</xsl:stylesheet>
