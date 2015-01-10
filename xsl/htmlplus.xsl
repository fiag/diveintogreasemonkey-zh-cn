<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version='1.0'>
  
<xsl:import href="html.xsl"/>
<xsl:param name="base.dir">build/htmlplus/</xsl:param>

<xsl:template match="procedure" mode="procedure.summary.mode">
  <li>
    <xsl:call-template name="summary.link">
      <xsl:with-param name="context" select="//appendix[@id='procedures']"/>
    </xsl:call-template>
    <xsl:apply-templates select="mediaobject" mode="procedure.summary.mode"/>
  </li>
</xsl:template>

</xsl:stylesheet>
