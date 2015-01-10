<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  
<xsl:import href="../docbook/xsl/html/docbook.xsl"/>
<xsl:import href="htmlcommon.xsl"/>

<xsl:param name="html.stylesheet"/>
<xsl:param name="admon.graphics" select="0"/>
<xsl:param name="callout.graphics" select="0"/>
<xsl:param name="menuchoice.separator"> &gt; </xsl:param>
<xsl:param name="menuchoice.menu.separator"> &gt; </xsl:param>

<xsl:output indent="yes" doctype-public="-//W3C//DTD HTML 4.01//EN" doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

<xsl:param name="generate.toc">
appendix  
article   
book      toc
chapter   
part      
preface   
qandadiv  
qandaset  
reference 
sect1     
sect2     
sect3     
sect4     
sect5     
section   
set       
</xsl:param>

<xsl:template match="mediaobject"/>

<xsl:template match="screenshot"/>

<xsl:template match="itemizedlist[@role='usedby']"/>

<xsl:template match="appendix/tip"/>

<xsl:template match="tip[@id='tip.tips']|tip[@id='tip.videos']|tip[@id='tip.furtherreading']" mode="tip.summary.mode"/>

<xsl:template match="itemizedlist[@role='furtherreading']"/>
<xsl:template match="itemizedlist[@role='download']"/>

<xsl:template name="section.subtitle"/>

<xsl:template name="nongraphical.admonition">
  <div class="{name(.)}">
    <blockquote>
      <b class="title">
        <a>
          <xsl:attribute name="name">
            <xsl:call-template name="object.id"/>
          </xsl:attribute>
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </a>
<!--
        <xsl:text>: </xsl:text>
-->
      </b>
      <br/>
      <xsl:apply-templates/>
    </blockquote>
  </div>
</xsl:template>

<!-- don't use real H1/H2/H3 elements for titles, just use bold -->
<xsl:template name="formal.object.heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="title">
    <xsl:apply-templates select="$object" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:param>

  <p class="title">
    <b>
      <xsl:copy-of select="$title"/>
    </b>
  </p>
</xsl:template>

<xsl:template match="bridgehead">
  <p class="bridgehead">
    <b>
      <xsl:apply-templates/>
    </b>
  </p>
</xsl:template>

<xsl:template name="component.title">
  <xsl:param name="node" select="."/>

  <hr/>

  <p>
    <xsl:attribute name="class">title</xsl:attribute>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select="$node"/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <b>
      <xsl:apply-templates select="$node" mode="object.title.markup">
        <xsl:with-param name="allow-anchors" select="1"/>
      </xsl:apply-templates>
    </b>
  </p>
</xsl:template>

<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="allow-anchors" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="class" select="'title'"/>

  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <hr/>

  <p>
    <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
    <xsl:if test="$allow-anchors != 0">
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="$section"/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>
    </xsl:if>
    <b>
      <xsl:copy-of select="$title"/>
    </b>
  </p>
</xsl:template>

<!-- drop extra line feeds in listitems, steps, and tips -->
<xsl:template match="itemizedlist/listitem/para">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="orderedlist/listitem/para">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="procedure/step/para">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="itemizedlist/listitem/para" mode="furtherreading.summary.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="tip/para|note/para|warning/para|caution/para|important/para" mode="tip.summary.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="title" mode="section.titlepage.recto.auto.mode">
  <div xsl:use-attribute-sets="section.titlepage.recto.style">
    <xsl:apply-templates select="." mode="section.titlepage.recto.mode"/>
    <xsl:call-template name="skiplink"/>
  </div>
</xsl:template>

<!-- add "skip to next" links below each section/refentry/appendix title -->
<xsl:template name="refentry.titlepage.before.recto">
  <xsl:call-template name="skiplink"/>
</xsl:template>

<xsl:template match="title" mode="appendix.titlepage.recto.auto.mode">
  <div xsl:use-attribute-sets="appendix.titlepage.recto.style">
    <xsl:apply-templates select="." mode="appendix.titlepage.recto.mode"/>
    <xsl:call-template name="skiplink"/>
  </div>
</xsl:template>

<xsl:template name="skiplink">
  <xsl:variable name="next-v1"
    select="(following::sect1[$chunk.section.depth &gt; 0][1]
            |following::sect2[$chunk.section.depth &gt; 1][1]
            |following::sect3[$chunk.section.depth &gt; 2][1]
            |following::sect4[$chunk.section.depth &gt; 3][1]
            |following::sect5[$chunk.section.depth &gt; 4][1]
            |following::section[$chunk.section.depth &gt; count(ancestor::section)][1])[1]"/>
  
  <xsl:variable name="next-v2"
    select="(descendant::sect1[$chunk.section.depth &gt; 0][1]
            |descendant::sect2[$chunk.section.depth &gt; 1][1]
            |descendant::sect3[$chunk.section.depth &gt; 2][1]
            |descendant::sect4[$chunk.section.depth &gt; 3][1]
            |descendant::sect5[$chunk.section.depth &gt; 4][1]
            |descendant::section[$chunk.section.depth 
            &gt; count(ancestor::section)][1])[1]"/>
  
  <xsl:variable name="next"
    select="(following::book[1]
            |following::preface[1]
            |following::chapter[1]
            |following::appendix[1]
            |following::part[1]
            |following::reference[1]
            |following::refentry[1]
            |following::colophon[1]
            |following::bibliography[parent::article or parent::book or parent::part][1]
            |following::glossary[parent::article or parent::book or parent::part][1]
            |following::index[$generate.index != 0]
            [parent::article or parent::book][1]
            |following::article[1]
            |following::setindex[$generate.index != 0][1]
            |descendant::book[1]
            |descendant::preface[1]
            |descendant::chapter[1]
            |descendant::appendix[1]
            |descendant::article[1]
            |descendant::bibliography[parent::article or parent::book][1]
            |descendant::glossary[parent::article or parent::book or parent::part][1]
            |descendant::index[$generate.index != 0]
            [parent::article or parent::book][1]
            |descendant::colophon[1]
            |descendant::setindex[$generate.index != 0][1]
            |descendant::part[1]
            |descendant::reference[1]
            |descendant::refentry[1]
            |$next-v1
            |$next-v2)[1]"/>
  
  <p>
    <a>
      <xsl:choose>
        <xsl:when test="$next">
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="."/>
              <xsl:with-param name="object" select="$next"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Skip to </xsl:text>
          <xsl:call-template name="gentext.startquote"/>
          <xsl:apply-templates select="$next" mode="object.title.markup"/>
          <xsl:call-template name="gentext.endquote"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="context" select="."/>
              <xsl:with-param name="object" select="//chapter[1]/section[1]"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Back to </xsl:text>
          <xsl:call-template name="gentext.startquote"/>
          <xsl:apply-templates select="//chapter[1]/section[1]" mode="object.title.markup"/>
          <xsl:call-template name="gentext.endquote"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
  </p>
</xsl:template>

<!-- display revision history with stylized caption -->
<xsl:template match="revhistory" mode="titlepage.mode">
  <div class="{name(.)}">
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="revhistory/revision" mode="titlepage.mode">
  <xsl:param name="numcols" select="'2'"/>
  <xsl:variable name="revnumber" select=".//revnumber"/>
  <xsl:variable name="revdate"   select=".//date"/>
  <xsl:variable name="revauthor" select=".//authorinitials"/>
  <xsl:variable name="revremark" select=".//revremark|.//revdescription"/>
  <a>
    <xsl:attribute name="name"><xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/></xsl:attribute>
  </a>
  <p class="revdate">
    <b>
      <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
    </b>
  </p>
  <xsl:if test="$revremark">
    <xsl:apply-templates select="$revremark[1]" mode="titlepage.mode"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
