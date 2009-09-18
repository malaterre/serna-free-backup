<!-- 
TEI XSLT stylesheet family version 1.3
RCS: $Date: 2003/11/24 14:50:28 $, $Revision: 1.1 $, $Author: ilia $

XSL stylesheet to format TEI XML documents to HTML or XSL FO

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
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  version="1.0"  >

<xsl:template name="doFrames">

 <xsl:variable name="BaseFile">
   <xsl:value-of select="$masterFile"/>
   <xsl:call-template name="addCorpusID"/>
 </xsl:variable>

 <xsl:choose>
  <xsl:when test="$ID='frametoc___'">
     <xsl:call-template name="writeFrameToc"/>
  </xsl:when>
  <xsl:when test="$STDOUT='true'">
        <xsl:call-template name="writeFrameMain">
 	 <xsl:with-param name="base" select="$BaseFile"/>
	</xsl:call-template>        
  </xsl:when>
  <xsl:otherwise>
        
   <xsl:call-template name="outputChunk">
   <xsl:with-param name="ident">
     <xsl:value-of select="concat($BaseFile,'-menubar')"/>
   </xsl:with-param>
   <xsl:with-param name="content">
    <xsl:call-template name="writeFrameToc"/>
   </xsl:with-param>
   </xsl:call-template>

   <xsl:call-template name="outputChunk">
   <xsl:with-param name="ident">
     <xsl:value-of select="concat($BaseFile,'-frames')"/>
   </xsl:with-param>
   <xsl:with-param name="content">
         <xsl:call-template name="writeFrameMain">
 	 <xsl:with-param name="base" select="$BaseFile"/>
	</xsl:call-template>
   </xsl:with-param>
   </xsl:call-template>
  
   <xsl:apply-templates select="TEI.2" mode="split"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template name="writeFrameToc">
<html><xsl:call-template name="addLangAtt"/>
 <xsl:comment>THIS FILE IS GENERATED FROM AN XML MASTER. 
 DO NOT EDIT</xsl:comment>
 <head>
 <title><xsl:call-template name="generateTitle"/></title>
 <xsl:call-template name="includeCSS"/>
 <base target="framemain"/>
 </head>
 <body class="framemenu">
 <xsl:call-template name="logoFramePicture"/><br/><xsl:text>
</xsl:text>
 <xsl:call-template name="linkListContents">
      <xsl:with-param name="style" select="'frametoc'"/>
 </xsl:call-template>
 <xsl:call-template name="stdfooterFrame">
          <xsl:with-param name="date">
           <xsl:call-template name="generateDate"/>
          </xsl:with-param>
          <xsl:with-param name="author">
            <xsl:call-template name="generateAuthorList"/>
          </xsl:with-param>
          <xsl:with-param name="style" select="'framestdlink'"/>
  </xsl:call-template>
 </body>
</html>
</xsl:template>

<xsl:template name="writeFrameMain">
 <xsl:param name="base"/>
 <xsl:variable name="firstfile">
   <xsl:if test="$STDOUT='true'">
     <xsl:value-of select="$masterFile"/>
     <xsl:value-of select="$urlChunkPrefix"/>
   </xsl:if>
   <!-- we need to locate the first interesting object in the file, ie
    the first grandchild of <text > -->
    <xsl:for-each select="descendant::text/*[1]/*[1]">
      <xsl:choose>
        <xsl:when test="starts-with(name(),'div')">
            <xsl:apply-templates select="." mode="ident"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
           <xsl:when test="$STDOUT='true'">
	    <xsl:text>prelim___</xsl:text>
           </xsl:when>
           <xsl:otherwise>
             <xsl:value-of select="$base"/>
           </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  <xsl:value-of select="$standardSuffix"/>
 </xsl:variable>
 <xsl:variable name="frameAlternate">
  <xsl:choose>
   <xsl:when test="$STDOUT='true'">
     <xsl:value-of select="concat($base,$standardSuffix)"/>  
     <xsl:text>?makeFrames=false&amp;autoToc=true</xsl:text>
   </xsl:when>
   <xsl:when test="$frameAlternateURL">
     <xsl:value-of select="$frameAlternateURL"/>  
   </xsl:when>
   <xsl:otherwise>
     <xsl:value-of select="concat($base,$standardSuffix)"/>  
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

 <xsl:variable name="frametoc">
 <xsl:value-of select="$base"/>
 <xsl:choose>
   <xsl:when test="$STDOUT='true'">
     <xsl:text>.ID=frametoc___</xsl:text>
   </xsl:when>
   <xsl:otherwise>
     <xsl:text>-menubar.html</xsl:text>
   </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<html><xsl:call-template name="addLangAtt"/>
 <xsl:comment>THIS FILE IS GENERATED FROM AN XML MASTER. 
 DO NOT EDIT</xsl:comment>
 <head>
 <meta name="robots" content="noindex,follow"/>
 <title><xsl:call-template name="generateTitle"/></title>
 <xsl:call-template name="includeCSS"/>
 </head>
  <frameset cols="{$frameCols}"> 
    <frame src="{$frametoc}"  name="framemenu"/>
    <frame src="{$firstfile}" name="framemain"/> 
    <noframes> 
     <body bgcolor="#ffffff"> 
    <p><i>Sorry, this document requires a browser that can view frames.</i></p>
    <p><b>Look at <a href="{$frameAlternate}">
         <xsl:value-of select="$frameAlternate"/></a> instead.</b></p>
     </body> 
    </noframes>
</frameset>
</html>
</xsl:template>


<xsl:template name="linkList">
<xsl:param name="side"/>
<xsl:param name="simple"/>

   <table class="{$side}links">
   <tr>
     <xsl:if test="$side='right'">
       <td valign="top">         <xsl:choose>
         <xsl:when test="$simple='true'">
           <xsl:call-template name="simpleBody"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:apply-templates/>
         </xsl:otherwise>
       </xsl:choose>
       </td>
     </xsl:if>
     <td width="{$linksWidth}" class="framemenu" valign="top">
     <xsl:call-template name="linkListContents">
        <xsl:with-param name="style" select="'frametoc'"/>
     </xsl:call-template>
     </td>
     <xsl:if test="$side='left'">
       <td valign="top">
         <xsl:choose>
         <xsl:when test="$simple='true'">
           <xsl:call-template name="simpleBody"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:apply-templates/>
         </xsl:otherwise>
       </xsl:choose>
       </td>
     </xsl:if>
   </tr>
   </table>
</xsl:template>

<xsl:template name="linkListContents">
  <xsl:param name="style" select="'toc'"/>
  <xsl:variable name="BaseFile">
   <xsl:value-of select="$masterFile"/>
   <xsl:call-template name="addCorpusID"/>
  </xsl:variable>

<xsl:variable name="thisname">
      <xsl:value-of select="name()"/>
</xsl:variable>

<a target="_top" class="frametoc" href="{$homeURL}">
  <xsl:value-of select="$homeLabel"/>
</a>
<xsl:call-template name="walkTree">
  <xsl:with-param name="path" select="substring-after($REQUEST,'/')"/>
</xsl:call-template>

<xsl:choose>
 <xsl:when test="$thisname='TEI.2' or $thisname=''">
<xsl:for-each select=".//text">
   <xsl:for-each select="front">
    <xsl:if test="div|div0|div1"><hr/></xsl:if>
    <xsl:for-each select="div|div0|div1">
      <xsl:if test="head">
       <xsl:variable name="pointer">
          <xsl:apply-templates mode="xrefheader" select="."/>
       </xsl:variable>
       <p class="{$style}"><a class="{$style}" href="{$pointer}">
       <xsl:call-template name="header"/></a></p>
       <xsl:text>
</xsl:text>
</xsl:if>
    </xsl:for-each>
   </xsl:for-each>
   <xsl:for-each select="body">
    <xsl:if test="div|div0|div1"><hr/></xsl:if>
    <xsl:for-each select="div|div0|div1">
      <xsl:if test="head">
       <xsl:variable name="pointer">
          <xsl:apply-templates mode="xrefheader" select="."/>
       </xsl:variable>
       <p class="{$style}"><a class="{$style}" href="{$pointer}">
         <xsl:call-template name="header"/></a>
       </p><xsl:text>
</xsl:text>
        
      </xsl:if>
    </xsl:for-each>
   </xsl:for-each>
   <xsl:for-each select="back">
    <xsl:for-each select="div|div0|div1">
    <xsl:if test="div|div0|div1"><hr/></xsl:if>
      <xsl:if test="head">
       <xsl:variable name="pointer">
          <xsl:apply-templates mode="xrefheader" select="."/>
       </xsl:variable>
       <p class="{$style}"><a class="{$style}" href="{$pointer}">
       <xsl:call-template name="header"/></a></p>
       <xsl:text>
</xsl:text>
</xsl:if>
    </xsl:for-each>
   </xsl:for-each>
  </xsl:for-each>
 </xsl:when>
 <xsl:otherwise>
    <xsl:text>
</xsl:text><hr/>
 <xsl:for-each select="ancestor::div|ancestor::div2|ancestor::div3|ancestor::div4|ancestor::div5">
   <p class="{$style}"><a class="{$style}">
        <xsl:attribute name="href">
         <xsl:apply-templates mode="xrefheader" select="."/>
        </xsl:attribute>
       <xsl:call-template name="header"/>
     </a></p><xsl:text>
</xsl:text><hr/>
 </xsl:for-each>
<!-- preceding divisions -->
   <xsl:for-each select="preceding-sibling::*[name()=$thisname]">
      <p class="{$style}"><a class="{$style}">
        <xsl:attribute name="href">
         <xsl:apply-templates mode="xrefheader" select="."/>
        </xsl:attribute>
       <xsl:call-template name="header"/>
     </a></p><xsl:text>
</xsl:text>
   </xsl:for-each>

<!-- current division -->
      <p class="{$style}"><a class="{$style}-this">
        <xsl:attribute name="href">
         <xsl:apply-templates mode="xrefheader" select="."/>
        </xsl:attribute>
       <xsl:call-template name="header"/>
     </a></p><xsl:text>
</xsl:text>
<!-- ... and any children it has -->
   <xsl:for-each select="div|div2|div3|div4|div5">
      <p class="{$style}-sub"><a class="{$style}-sub">
        <xsl:attribute name="href">
         <xsl:apply-templates mode="xrefheader" select="."/>
        </xsl:attribute>
        <xsl:call-template name="header"/>
       </a></p><xsl:text>
</xsl:text>
   </xsl:for-each>

<!-- following divisions -->
   <xsl:for-each select="following-sibling::*[name()=$thisname]">
      <p class="{$style}"><a class="{$style}">
        <xsl:attribute name="href">
         <xsl:apply-templates mode="xrefheader" select="."/>
        </xsl:attribute>
        <xsl:call-template name="header"/>
      </a></p><xsl:text>
</xsl:text>
   </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="stdfooterFrame">
  <xsl:param name="date"/>
  <xsl:param name="author"/>
  <xsl:param name="style" select="'plain'"/>
<hr/>
  <xsl:variable name="BaseFile">
   <xsl:value-of select="$masterFile"/>
   <xsl:call-template name="addCorpusID"/>
  </xsl:variable>
<xsl:if test="$linkPanel='true'">
 <div class="footer">
 <a  class="{$style}" target="_top">
  <xsl:attribute name="href">
    <xsl:value-of select="concat($BaseFile,$standardSuffix)"/>
    <xsl:text>?makeFrames=false</xsl:text>
  </xsl:attribute>
<xsl:value-of select="$noframeWords"/></a>
<xsl:text> | </xsl:text> 
<a class="{$style}" target="_top">
  <xsl:attribute name="href">
    <xsl:value-of select="concat($BaseFile,$standardSuffix)"/>
    <xsl:text>?style=printable</xsl:text>
  </xsl:attribute>
  <xsl:call-template name="singleFileLabel"/>
 </a> 
 </div>
<hr/>
<div class="footer">
<xsl:if test="$searchURL">
 <a  class="{$style}" target="_top"
href="{$searchURL}"><xsl:call-template name="searchWords"/></a> 
</xsl:if>
<xsl:if test="$feedbackURL">
  <br/><xsl:text>
</xsl:text>
  <br/><xsl:text>
</xsl:text>
<a class="{$style}" target="_top" 
href="{$feedbackURL}"><xsl:call-template name="feedbackWords"/></a> 
</xsl:if>
 </div>

</xsl:if>
<xsl:call-template name="preAddress"/>
<address>
 <xsl:comment>
<xsl:text>
  Generated using an XSLT version </xsl:text>
<xsl:value-of select="system-property('xsl:version')"/> stylesheet
based on <xsl:value-of select="$teixslHome"/>teihtml.xsl
processed using: <xsl:value-of select="system-property('xsl:vendor')"/> 
<!-- <xsl:call-template name="whatsTheDate"/> -->
</xsl:comment>
</address>
</xsl:template>

<xsl:template name="walkTree">
  <xsl:param name="path"/>
  <xsl:param name="whole" select="''"/>
  <xsl:param name="spacer" select="' &gt;'"/>
  <xsl:choose>
    <xsl:when test="contains($path,'/')">
      <xsl:variable name="current">
        <xsl:value-of select="substring-before($path,'/')"/>            
      </xsl:variable>
     <a class="frametoc" target="_top">
      <xsl:attribute name="href">
        <xsl:value-of select="$whole"/>/<xsl:value-of select="$current"/>
        <xsl:text>/</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$spacer"/>
      <xsl:value-of select="$current"/>
    </a>
    <xsl:call-template name="walkTree">
       <xsl:with-param name="path" select="substring-after($path,'/')"/>
       <xsl:with-param name="spacer" select="$spacer"/>
       <xsl:with-param name="whole">
         <xsl:value-of select="$whole"/>/<xsl:value-of select="$current"/>
       </xsl:with-param>
    </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
