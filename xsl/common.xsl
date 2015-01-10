<?xml version='1.0' encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
  
<xsl:param name="link.mailto.url">mailto:mark@diveintomark.org</xsl:param>
<xsl:param name="mailto.text">mark@diveintomark.org</xsl:param>
<xsl:param name="xref.with.number.and.title" select="0"/>
<xsl:param name="part.autolabel" select="0"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="appendix.autolabel" select="0"/>
<xsl:param name="generate.meta.abstract" select="0"/>
<xsl:param name="toc.list.type">ul</xsl:param>
<xsl:param name="ulink.target"/>
<xsl:param name="funcsynopsis.style">ansi</xsl:param>

<xsl:template match="screen/computeroutput">
  <xsl:choose>
    <xsl:when test="@role='props'">
      <span class="props"><xsl:apply-templates/></span>
    </xsl:when>
    <xsl:otherwise>
      <span class="computeroutput"><xsl:apply-templates/></span>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- w3m, which I use to create text-only versions from HTML, includes extra spacing above and below text in list items and callouts.  The workaround is not to add a <p> tag inside list items or callouts. -->
<xsl:template match="listitem/para|callout/para">
  <xsl:apply-templates/>
</xsl:template>

<!-- The default admon.graphic.width template DOESN'T MATCH THE WIDTH OF THE SUPPLIED GRAPHICS! -->
<!-- (Sorry to shout, but this bug has existed since at least 2000 when I started using DocBook) -->
<xsl:template name="admon.graphic.width">
  <xsl:param name="node" select="."/>
  <xsl:text>24</xsl:text>
</xsl:template>

<!-- fix totally borked admonition template -->
<xsl:template name="graphical.admonition">
  <xsl:variable name="admon.type">
    <xsl:choose>
      <xsl:when test="local-name(.)='note'">Note</xsl:when>
      <xsl:when test="local-name(.)='warning'">Warning</xsl:when>
      <xsl:when test="local-name(.)='caution'">Caution</xsl:when>
      <xsl:when test="local-name(.)='tip'">Tip</xsl:when>
      <xsl:when test="local-name(.)='important'">Important</xsl:when>
      <xsl:otherwise>Note</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alt">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="$admon.type"/>
    </xsl:call-template>
  </xsl:variable>

  <div class="{name(.)}">
    <xsl:if test="$admon.style != ''">
      <xsl:attribute name="style">
        <xsl:value-of select="$admon.style"/>
      </xsl:attribute>
    </xsl:if>

    <table class="admon" summary="">
      <tr>
        <td class="admonicon">
          <a>
            <xsl:attribute name="href">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="//appendix[@id='tips']"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:apply-templates select="//appendix[@id='tips']" mode="object.title.markup.textonly"/>
            </xsl:attribute>
            <img alt="[{$alt}]">
              <xsl:attribute name="src">
                <xsl:call-template name="admon.graphic"/>
              </xsl:attribute>
              <xsl:attribute name="width">
                <xsl:call-template name="admon.graphic.width"/>
              </xsl:attribute>
              <xsl:attribute name="height">
                <xsl:call-template name="admon.graphic.width"/>
              </xsl:attribute>
              <xsl:attribute name="title"/>
            </img>
          </a>
        </td>
        <td class="admontext">
          <xsl:apply-templates/>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<!-- set width/height of callout image -->
<xsl:template name="callout-bug">
  <xsl:param name="conum" select='1'/>

  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $conum &lt;= $callout.graphics.number.limit">
      <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
           alt="{$conum}" width="12" height="12"/>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $conum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$conum = 1">&#10102;</xsl:when>
            <xsl:when test="$conum = 2">&#10103;</xsl:when>
            <xsl:when test="$conum = 3">&#10104;</xsl:when>
            <xsl:when test="$conum = 4">&#10105;</xsl:when>
            <xsl:when test="$conum = 5">&#10106;</xsl:when>
            <xsl:when test="$conum = 6">&#10107;</xsl:when>
            <xsl:when test="$conum = 7">&#10108;</xsl:when>
            <xsl:when test="$conum = 8">&#10109;</xsl:when>
            <xsl:when test="$conum = 9">&#10110;</xsl:when>
            <xsl:when test="$conum = 10">&#10111;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$conum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- hard-code formatting of xrefs because xref.with.number.and.title doesn't actually do anything (grr) -->
<xsl:template match="chapter|section|sect1|preface|appendix" mode="xref-to">
  <xsl:apply-templates select="." mode="object.xref.markup"/>
</xsl:template>

<xsl:template match="chapter|section|sect1|preface|appendix" mode="object.xref.template">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'xref'"/>
    <xsl:with-param name="name" select="'book'"/>
  </xsl:call-template>
</xsl:template>

<!-- add support for titles in links to procedures -->
<xsl:template match="link" name="link">
  <xsl:param name="a.target"/>

  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>

    <xsl:if test="$a.target">
      <xsl:attribute name="target"><xsl:value-of select="$a.target"/></xsl:attribute>
    </xsl:if>

    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="object" select="$target"/>
      </xsl:call-template>
    </xsl:attribute>

    <!-- FIXME: is there a better way to tell what elements have a title? -->
    <xsl:if test="local-name($target) = 'book'
                  or local-name($target) = 'set'
                  or local-name($target) = 'chapter'
                  or local-name($target) = 'preface'
                  or local-name($target) = 'appendix'
                  or local-name($target) = 'bibliography'
                  or local-name($target) = 'glossary'
                  or local-name($target) = 'index'
                  or local-name($target) = 'part'
                  or local-name($target) = 'refentry'
                  or local-name($target) = 'reference'
                  or local-name($target) = 'example'
                  or local-name($target) = 'procedure'
                  or local-name($target) = 'equation'
                  or local-name($target) = 'table'
                  or local-name($target) = 'figure'
                  or local-name($target) = 'simplesect'
                  or starts-with(local-name($target),'sect')
                  or starts-with(local-name($target),'refsect')">
      <xsl:attribute name="title">
        <xsl:apply-templates select="$target"
                             mode="object.title.markup.textonly"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="count(child::node()) &gt; 0">
        <!-- If it has content, use it -->
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <!-- else look for an endterm -->
        <xsl:choose>
          <xsl:when test="@endterm">
            <xsl:variable name="etargets" select="key('id',@endterm)"/>
            <xsl:variable name="etarget" select="$etargets[1]"/>
            <xsl:choose>
              <xsl:when test="count($etarget) = 0">
                <xsl:message>
                  <xsl:value-of select="count($etargets)"/>
                  <xsl:text>Endterm points to nonexistent ID: </xsl:text>
                  <xsl:value-of select="@endterm"/>
                </xsl:message>
                <xsl:text>???</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:apply-templates select="$etarget" mode="endterm"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>

          <xsl:otherwise>
            <xsl:message>
              <xsl:text>Link element has no content and no Endterm. </xsl:text>
              <xsl:text>Nothing to show in the link to </xsl:text>
              <xsl:value-of select="$target"/>
            </xsl:message>
            <xsl:text>???</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<!-- add "Tip: " to beginning of tip title (displayed with tip in non-HTML output, and in HTML when we link to a tip) -->
<xsl:template match="tip|note|warning|caution|important" mode="object.title.template">
  <xsl:call-template name="gentext"/>
  <xsl:text>: </xsl:text>
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="tip|note|warning|caution|important" mode="xref-to">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name" select="local-name(.)"/>
  </xsl:call-template>
</xsl:template>

<!-- provide abbreviated title page information -->
<xsl:template name="book.titlepage.recto">
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="(bookinfo/title|title)[1]"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/abstract"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/legalnotice"/>
</xsl:template>

<xsl:template name="reference.titlepage.separator"/>

<!-- make all gui* stuff stylized -->
<xsl:template match="interface">
  <xsl:call-template name="gentext.startquote"/>
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="gentext.endquote"/>
</xsl:template>

<xsl:template match="guilabel">
  <xsl:call-template name="gentext.startquote"/>
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="gentext.endquote"/>
</xsl:template>

<xsl:template match="guibutton">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guiicon">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guimenu">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guimenuitem">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="guisubmenu">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<!-- display properties monospaced -->
<xsl:template match="property">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="returnvalue">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!-- render mediaobject as text (usually a link to the external media file) -->
<xsl:template match="mediaobject">
  <xsl:apply-templates select="textobject"/>
</xsl:template>

<xsl:template match="textobject">
  <span class="textobject">
    <a class="dingbat" title="List of all available videos">
      <xsl:attribute name="href">
        <xsl:call-template name="href.target">
          <xsl:with-param name="object" select="//appendix[@id='procedures']"/>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:text>&#x272A;</xsl:text>
    </a>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- add support for title attribute of ulinks -->
<!-- note: this is probably tag abuse -->
<xsl:template match="ulink">
  <a>
    <xsl:if test="@id">
      <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
      <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
    </xsl:if>
    <xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:if test="$ulink.target != ''">
      <xsl:attribute name="target">
        <xsl:value-of select="$ulink.target"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@type">
      <xsl:attribute name="title"><xsl:value-of select="@type"/></xsl:attribute>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="count(child::node())=0">
	<xsl:value-of select="@url"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </a>
</xsl:template>

<!-- add support for summary appendices -->
<!-- this is really XML abuse, but I don't care because it's cool -->

<xsl:template name="summary.link">
  <xsl:param name="context" select="."/>
  <xsl:param name="node" select="."/>
  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="context" select="$context"/>
        <xsl:with-param name="object" select="$node"/>
      </xsl:call-template>
    </xsl:attribute>
    <xsl:apply-templates select="$node" mode="object.title.markup"/>
  </a>
</xsl:template>

<!-- further reading summary -->
<xsl:template match="appendix[@id='furtherreading']/para">
  <ol class="contextual">
    <xsl:apply-templates select="//itemizedlist[@role='furtherreading']" mode="furtherreading.summary.mode"/>
  </ol>
</xsl:template>

<xsl:template match="itemizedlist" mode="furtherreading.summary.mode">
  <xsl:apply-templates select="listitem" mode="furtherreading.summary.mode"/>
</xsl:template>

<xsl:template match="itemizedlist/listitem" mode="furtherreading.summary.mode">
  <li>
    <xsl:apply-templates select="para" mode="furtherreading.summary.mode"/>
  </li>
</xsl:template>

<xsl:template match="itemizedlist/listitem/para" mode="furtherreading.summary.mode">
  <xsl:apply-templates/>
  <xsl:text> </xsl:text>
  <span class="context">
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='tips']"/>
      <xsl:with-param name="node" select="ancestor::section|ancestor::appendix|ancestor::refentry"/>
    </xsl:call-template>
  </span>
</xsl:template>

<!-- tips summary -->
<xsl:template match="appendix[@id='tips']/para">
  <ol class="contextual">
    <xsl:apply-templates select="//tip|note|warning|caution|important" mode="tip.summary.mode"/>
  </ol>
</xsl:template>

<xsl:template match="tip|note|warning|caution|important" mode="tip.summary.mode">
  <li>
    <xsl:apply-templates mode="tip.summary.mode"/>
  </li>
<!--
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//tips"/>
      </xsl:call-template>
-->
</xsl:template>

<xsl:template match="tip/para|note/para|warning/para|caution/para|important/para" mode="tip.summary.mode">
  <p>
    <xsl:apply-templates/>
    <xsl:text> </xsl:text>
    <span class="context">
      <xsl:call-template name="summary.link">
        <xsl:with-param name="context" select="//appendix[@id='tips']"/>
        <xsl:with-param name="node" select="ancestor::section|ancestor::appendix|ancestor::refentry"/>
      </xsl:call-template>
    </span>
  </p>
</xsl:template>

  <!-- example summary -->
<xsl:template match="appendix[@id='examples']/para">
  <ol>
    <xsl:apply-templates select="//example" mode="example.summary.mode"/>
  </ol>
</xsl:template>

<xsl:template match="example" mode="example.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='examples']"/>
    </xsl:call-template>
  </li>
</xsl:template>

<!-- procedure summary -->
<xsl:template match="appendix[@id='procedures']/para">
  <ol>
    <xsl:apply-templates select="//procedure" mode="procedure.summary.mode"/>
  </ol>
</xsl:template>

<xsl:template match="procedure" mode="procedure.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='procedures']"/>
    </xsl:call-template>
  </li>
</xsl:template>

<xsl:template match="mediaobject" mode="procedure.summary.mode">
  <xsl:apply-templates select="textobject" mode="procedure.summary.mode"/>
</xsl:template>

<xsl:template match="textobject" mode="procedure.summary.mode">
  <xsl:text> (</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- add support for revision history in its own appendix -->
<xsl:template match="appendix[@id='revhistory']/para">
  <xsl:apply-templates select="//revhistory" mode="titlepage.mode"/>
</xsl:template>

<!-- put screeninfo into alt attribute of screenshot img for accessibility reasons -->
<xsl:template match="screenshot/graphic">
  <xsl:call-template name="anchor"/>
  <xsl:call-template name="process.image">
    <xsl:with-param name="alt">
      <xsl:value-of select="parent::screenshot/screeninfo"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="void" mode="ansi-nontabular">
  <code>)</code>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="void" mode="ansi-tabular">
  <td>
    <code>)</code>
    <xsl:text>;</xsl:text>
  </td>
  <td>&#160;</td>
</xsl:template>

</xsl:stylesheet>
