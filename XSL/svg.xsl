<?xml version="1.0"?>
<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output indent = "yes"/>

  <xsl:template match="traceur">

    <xsl:variable name="min_x" select="min(action/@x) * 5"/>
    <xsl:variable name="min_y" select="min(action/@y) * 5"/>
    <xsl:variable name="max_x" select="max(action/@x) * 5"/>
    <xsl:variable name="max_y" select="max(action/@y) * 5"/>
    <xsl:variable name="width" select="$max_x - $min_x"/>
    <xsl:variable name="height" select="$max_y - $min_y"/>

    <svg xmlns="http://www.w3.org/2000/svg" width="500" height="500" viewBox="{$min_x} {$min_y} {$width} {$height}" preserveAspectRatio="xMidYMid meet">
      <path fill="none" stroke="pink" stroke-width="3">
        <xsl:attribute name="d">
          <xsl:call-template name="tracage">
            <xsl:with-param name="actions" select="action"/>
          </xsl:call-template>
        </xsl:attribute>
      </path>
    </svg>
  </xsl:template>

  <xsl:template name="tracage">
    <xsl:param name="actions"/>
    <xsl:for-each select="$actions">
      <xsl:call-template name="trace-action">
        <xsl:with-param name="action" select="."/>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- on sépare ce code des autres templates pour faciliter l'ajout d'une nouvelle action dans le futur -->
  <xsl:template name="trace-action">
    <xsl:param name="action"/>
    <xsl:choose>
      <xsl:when test="$action/@command = 'MOVETO'">
        <xsl:value-of select="concat('M', $action/@x * 5, ',', $action/@y * 5, ' ')"/>
      </xsl:when>
      <xsl:when test="$action/@command = 'LINETO'">
        <xsl:value-of select="concat('L', $action/@x * 5, ',', $action/@y * 5, ' ')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:transform>