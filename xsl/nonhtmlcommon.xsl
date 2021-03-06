<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  
<xsl:import href="common.xsl"/>

<xsl:param name="admon.graphics" select="0"/>
<xsl:param name="callout.graphics" select="0"/>

<!--
<xsl:template match="screen/computeroutput">
  <xsl:choose>
    <xsl:when test="@role='traceback'">
      <font color='red'><xsl:apply-templates/></font>
    </xsl:when>
    <xsl:otherwise>
      <font color='teal'><xsl:apply-templates/></font>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<!-- HTMLDoc and Word rely on Hx tags to build the table of contents;
     chapter/appendix titles need to be H1 so they'll show up at the root level -->
<xsl:template name="big.component.title">
  <xsl:param name="node" select="."/>
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <h1 class="title">
    <a name="{$id}"/>
    <xsl:apply-templates select="$node" mode="object.title.markup"/>
  </h1>
</xsl:template>

<xsl:template match="title" mode="chapter.titlepage.recto.mode">
  <xsl:call-template name="big.component.title">
    <xsl:with-param name="node" select="ancestor::chapter[1]"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="title" mode="appendix.titlepage.recto.mode">
  <xsl:call-template name="big.component.title">
    <xsl:with-param name="node" select="ancestor::appendix[1]"/>
  </xsl:call-template>
</xsl:template>

<!-- tips/notes/etc. use CSS styles to indent.  Use blockquote instead so non-visual
     structure-based conversion tools (like HTMLDoc and w3m) indent properly.
-->
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

<xsl:template match="mediaobject"/>

<xsl:template match="appendix/tip"/>

<xsl:template match="tip[@id='tip.tips']|tip[@id='tip.videos']|tip[@id='tip.furtherreading']" mode="tip.summary.mode"/>

<xsl:template match="ulink">
  <xsl:choose>
    <xsl:when test="count(child::node())=0">
      <a>
        <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
        <xsl:value-of select="@url"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
      <xsl:if test="starts-with(@url, 'http://')">
        <xsl:text> &lt;</xsl:text>
        <a>
          <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
          <xsl:value-of select="@url"/>
        </a>
        <xsl:text>&gt;</xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist/listitem/para" mode="furtherreading.summary.mode">
  <xsl:apply-templates/>
  <span class="context">
    <xsl:text> [</xsl:text>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='tips']"/>
      <xsl:with-param name="node" select="./ancestor::section"/>
    </xsl:call-template>
    <xsl:text>]</xsl:text>
  </span>
</xsl:template>

<xsl:template match="tip/para|note/para|warning/para|caution/para|important/para" mode="tip.summary.mode">
  <p>
    <xsl:apply-templates/>
    <span class="context">
      <xsl:text> [</xsl:text>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//appendix[@id='tips']"/>
        <xsl:with-param name="node" select="./ancestor::section"/>
      </xsl:call-template>
      <xsl:text>]</xsl:text>
    </span>
  </p>
</xsl:template>

<xsl:template match="example" mode="example.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='examples']"/>
    </xsl:call-template>
    <span class="context">
      <xsl:text> [</xsl:text>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//appendix[@id='tips']"/>
        <xsl:with-param name="node" select="./ancestor::section"/>
      </xsl:call-template>
      <xsl:text>]</xsl:text>
    </span>
  </li>
</xsl:template>

<xsl:template match="procedure" mode="procedure.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='procedures']"/>
    </xsl:call-template>
    <span class="context">
      <xsl:text> [</xsl:text>
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//appendix[@id='tips']"/>
        <xsl:with-param name="node" select="./ancestor::section"/>
      </xsl:call-template>
      <xsl:text>]</xsl:text>
    </span>
  </li>
</xsl:template>

</xsl:stylesheet>
