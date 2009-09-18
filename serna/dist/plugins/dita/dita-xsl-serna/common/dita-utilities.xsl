<?xml version="1.0" encoding="utf-8"?>
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!-- Common utilities that can be used by DITA transforms -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                              xmlns:dtm="http://syntext.com/Extensions/DocumentTypeMetadata-1.0"
                              extension-element-prefixes="dtm">

 
<xsl:param name="DEFAULTLANG">en-us</xsl:param>

<!-- Function to convert a string to lower case -->
<dtm:doc dtm:status="testing" dtm:idref="convert.lower"/>
<xsl:template name="convert-to-lower" dtm:id="convert.lower">
  <xsl:param name="inputval"/>
  <xsl:value-of select="translate($inputval, '._-abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+=!@#$%^&amp;*()[]{};:\/&lt;&gt;,~?', '._-abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz+=!@#$%^&amp;*()[]{};:\/&lt;&gt;,~?')"/>
</xsl:template>

<!-- Function to determine the current language and return it in lower case -->
<dtm:doc dtm:status="testing" dtm:idref="language.determine-lower"/>
<xsl:template name="getLowerCaseLang" dtm:id="language.determine-lower">
  <xsl:variable name="ancestorlangUpper">
    <!-- the current xml:lang value (en-us if none found) -->
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@xml:lang">
        <xsl:value-of select="ancestor-or-self::*[@xml:lang][1]/@xml:lang"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$DEFAULTLANG"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="convert-to-lower">
    <!-- ensure lowercase for comparisons -->
    <xsl:with-param name="inputval" select="$ancestorlangUpper"/>
  </xsl:call-template>
</xsl:template>

<!-- Function to get translated text for a common string.
     * Each language is stored in a unique file. The association between 
       a language and its translations is stored in $stringFileList.

     * Default file associations are in strings.xml.

     * Once the file for a language is found, look for the translation 
       in that file.

     * If the correct file or translation are not found, use the default 
       language. If adding translations for a specialization, create a new 
       version of strings.xml, to indicate which languages are supported, 
       and the name of each language file. 

       When calling this template, pass in the new association file as 
       $stringFileList.

       To reset the default language, import this template, and then set 
       the DEFAULTLANG parameter in the importing topic. Or, just pass it 
       in on the command line.
-->
<dtm:doc dtm:status="testing" dtm:idref="get-string"/>
<xsl:template name="getString" dtm:id="get-string">
  <xsl:param name="stringName"/>
  <xsl:param name="stringFileList">strings.xml</xsl:param>
  <xsl:param name="stringFile">#none#</xsl:param>

  <xsl:variable name="ancestorlang">
    <!-- Get the current language -->
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$stringFile != '#none#'">
      <xsl:call-template name="getStringUsingOldInterface">
        <xsl:with-param name="stringName" select="$stringName"/>
        <xsl:with-param name="stringFile" select="$stringFile"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getStringUsingNewInterface">
        <xsl:with-param name="stringName" select="$stringName"/>
        <xsl:with-param name="stringFileList" select="$stringFileList"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="get-string.newinterface"/>
<xsl:template name="getStringUsingNewInterface" dtm:id="get-string.newinterface">
  <xsl:param name="stringName"/>
  <xsl:param name="stringFileList"/>

  <xsl:variable name="ancestorlang">
    <!-- Get the current language -->
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:variable>
  <!-- Determine which file holds translations for the current language -->
  <xsl:variable name="stringfile">
    <xsl:value-of select="document($stringFileList)/*/lang[
                          @xml:lang=$ancestorlang][1]/@filename"/>
  </xsl:variable>
  <!-- Get the translated string -->
  <xsl:variable name="str" 
                select="document($stringfile)/strings/str[@name=$stringName]"/>
  <xsl:choose>
    <!-- If the string was found, use it. --> 
    <xsl:when test="count($str) > 0">
      <xsl:value-of select="$str"/>
    </xsl:when>
    <!-- If the current language is not the default language, -->
    <!--try the default -->
    <xsl:when test="$ancestorlang != $DEFAULTLANG">
      <!-- Determine which file holds the defaults; -->
      <!-- then get the default translation. -->
      <xsl:variable name="backupstringfile">
        <xsl:value-of select="document($stringFileList)/*/lang[
                              @xml:lang=$DEFAULTLANG]/@filename"/>
      </xsl:variable>
      <xsl:variable name="str-default"
                    select="document($backupstringfile)/strings/str[
                            @name=$stringName]"/>
      <xsl:choose>
        <!-- If a default was found, use it, --> 
        <!-- but warn that fallback was needed.-->
        <xsl:when test="string-length($str-default)>0">
          <xsl:value-of select="$str-default"/>
          <xsl:call-template name="default-translation-used">
            <xsl:with-param name="stringName" select="$stringName"/>
            <xsl:with-param name="ancestorlang" select="$ancestorlang"/>
            <xsl:with-param name="DEFAULTLANG" select="$DEFAULTLANG"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Translation was not even found in the default language. -->
        <xsl:otherwise>
          <xsl:value-of select="$stringName"/>
          <xsl:call-template name="translation-not-found">
            <xsl:with-param name="stringName" select="$stringName"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- The current language is the default; no translation found at all. -->
    <xsl:otherwise>
      <xsl:value-of select="$stringName"/>
      <xsl:call-template name="translation-not-found">
        <xsl:with-param name="stringName" select="$stringName"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="get-string.oldinterface"/>
<xsl:template name="getStringUsingOldInterface" dtm:id="get-string.oldinterface">
  <xsl:param name="stringName"/>
  <xsl:param name="stringFile"/>
  <xsl:variable name="ancestorlang">
    <!-- Get the current language -->
    <xsl:call-template name="getLowerCaseLang"/>
  </xsl:variable>
  <!-- Get the translated string -->
  <xsl:variable name="str" select="$stringFile/strings/str[@name=$stringName]
                                   [lang($ancestorlang)]"/>  
  <xsl:choose>
    <!-- If the string was found, use it. --> 
    <xsl:when test="count($str)>0">
      <xsl:value-of select="$str"/>
    </xsl:when>

    <!-- If the current language is not the default language, --> 
    <!-- try the default -->
    <xsl:when test="$ancestorlang!=$DEFAULTLANG">
      <!-- Determine which file holds the defaults; -->
      <!--then get the default translation. -->
      <xsl:variable name="str-default"
                    select="$stringFile/strings/str[@name=$stringName]
                            [lang($DEFAULTLANG)]"/>
      <xsl:choose>
        <!-- If a default was found, use it, but warn that -->
        <!-- fallback was needed.-->
        <xsl:when test="string-length($str-default)>0">
          <xsl:value-of select="$str-default"/>
          <xsl:call-template name="default-translation-used">
            <xsl:with-param name="stringName" select="$stringName"/>
            <xsl:with-param name="ancestorlang" select="$ancestorlang"/>
            <xsl:with-param name="DEFAULTLANG" select="$DEFAULTLANG"/>
          </xsl:call-template>
        </xsl:when>
        <!-- Translation was not even found in the default language. -->
        <xsl:otherwise>
          <xsl:value-of select="$stringName"/>
          <xsl:call-template name="translation-not-found">
            <xsl:with-param name="stringName" select="$stringName"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- The current language is the default; no translation found at all. -->
    <xsl:otherwise>
      <xsl:value-of select="$stringName"/>
      <xsl:call-template name="translation-not-found">
        <xsl:with-param name="stringName" select="$stringName"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="translation.default"/>
<xsl:template name="default-translation-used" dtm:id="translation.default">
  <xsl:param name="stringName"/>
  <xsl:param name="ancestorlang"/>
  <xsl:param name="DEFAULTLANG"/>
  <xsl:call-template name="output-message">
    <xsl:with-param name="msgnum">001</xsl:with-param>
    <xsl:with-param name="msgsev">W</xsl:with-param>
    <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/>;%2=<xsl:value-of select="$ancestorlang"/>;%3=<xsl:value-of select="$DEFAULTLANG"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<dtm:doc dtm:status="testing" dtm:idref="translation.not-found"/>
<xsl:template name="translation-not-found" dtm:id="translation.not-found">
  <xsl:param name="stringName"/>
  <xsl:call-template name="output-message">
    <xsl:with-param name="msgnum">052</xsl:with-param>
    <xsl:with-param name="msgsev">W</xsl:with-param>
    <xsl:with-param name="msgparams">%1=<xsl:value-of select="$stringName"/></xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
