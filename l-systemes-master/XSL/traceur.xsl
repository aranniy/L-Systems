<?xml version = "1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
               xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
               xmlns:math="http://www.w3.org/2005/xpath-functions/math"
               version="2.0">

    <xsl:output indent = "yes"/>

    <xsl:variable name="nbr_actions" select = "count(*/action)"/>

    <xsl:template match = "/tortue">

        <xsl:variable name = "x" select = "0"/>
        <xsl:variable name = "y" select = "0"/>
        <xsl:variable name = "angle" select = "0"/>
        <xsl:variable name = "save" select = "()"/>

        <traceur>
            <action command = "MOVETO" x = "{$x}" y = "{$x}"/>
            <xsl:call-template name = "Action">
                <xsl:with-param name = "iteration" select = "0"/>
                <xsl:with-param name = "x" select = "$x"/>
                <xsl:with-param name = "y" select = "$y"/>
                <xsl:with-param name = "angle" select = "$angle"/>
                <xsl:with-param name = "save" select = "$save"/>
            </xsl:call-template>
        </traceur>

    </xsl:template>

    <xsl:template name = "Action" match = "action">
        <xsl:param name = "iteration"/>
        <xsl:param name = "x"/>
        <xsl:param name = "y"/>
        <xsl:param name = "angle"/>
        <xsl:param name = "save"/>
        
        <xsl:if test = "$iteration &lt; $nbr_actions">

            <xsl:variable name = "action" select = "/tortue/action[$iteration + 1]"/>

            <xsl:choose>
                <xsl:when test = "$action/@command = 'TURN'">
                    <xsl:call-template name = "Action">
                        <xsl:with-param name = "iteration" select = "$iteration + 1"/>
                        <xsl:with-param name = "x" select = "$x"/>
                        <xsl:with-param name = "y" select = "$y"/>
                        <xsl:with-param name = "angle" select = "($angle + ($action/@angle)) mod 360"/>
                        <xsl:with-param name = "save" select = "$save"/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test = "$action/@command = 'LINE'">
                    <xsl:variable name = "new_x" select = "round($x + ($action/@angle) * math:cos($angle * math:pi() div 180))"/>
                    <xsl:variable name = "new_y" select = "round($y + ($action/@angle) * math:sin($angle * math:pi() div 180))"/>
                    <action command = "LINETO" x = "{$new_x}" y = "{$new_y}"/>

                    <xsl:call-template name = "Action">
                        <xsl:with-param name = "iteration" select = "$iteration + 1"/>
                        <xsl:with-param name = "x" select = "$new_x"/>
                        <xsl:with-param name = "y" select = "$new_y"/>
                        <xsl:with-param name = "angle" select = "$angle"/>
                        <xsl:with-param name = "save" select = "$save"/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test = "$action/@command = 'MOVE'">
                    <t i = "{$iteration}" x = "{$x}"  y = "{$y}"  a = "{$angle}" />
                    <xsl:variable name = "new_x" select = "round($x + ($action/@angle) * math:cos($angle * math:pi() div 180))"/>
                    <xsl:variable name = "new_y" select = "round($y + ($action/@angle) * math:sin($angle * math:pi() div 180))"/>

                    <action command = "MOVETO" x = "{$new_x}" y = "{$new_y}"/>

                    <xsl:call-template name = "Action">
                        <xsl:with-param name = "iteration" select = "$iteration + 1"/>
                        <xsl:with-param name = "x" select = "$new_x"/>
                        <xsl:with-param name = "y" select = "$new_y"/>
                        <xsl:with-param name = "angle" select = "$angle"/>
                        <xsl:with-param name = "save" select = "$save"/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test = "$action/@command = 'STORE'">
                    <xsl:variable name = "new_save">
                        <xsl:copy-of select="$save"/>
                        <state>
                            <x><xsl:value-of select="$x"/></x>
                            <y><xsl:value-of select="$y"/></y>
                            <angle><xsl:value-of select="$angle"/></angle>
                        </state>
                    </xsl:variable>
                    <xsl:call-template name = "Action">
                        <xsl:with-param name = "iteration" select = "$iteration + 1"/>
                        <xsl:with-param name = "x" select = "$x"/>
                        <xsl:with-param name = "y" select = "$y"/>
                        <xsl:with-param name = "angle" select = "$angle"/>
                        <xsl:with-param name = "save" select = "$new_save"/>
                    </xsl:call-template> 
                </xsl:when>

                <xsl:when test = "$action/@command = 'RESTORE'">
                    <xsl:variable name="last_save" select="$save/state[last()]"/>
                    <xsl:variable name="new_save">
                        <xsl:copy-of select="$save/state[position() &lt; last()]"/>
                    </xsl:variable>
                    <xsl:call-template name = "Action">
                        <xsl:with-param name = "iteration" select = "$iteration + 1"/>
                        <xsl:with-param name = "x" select = "$last_save/x"/>
                        <xsl:with-param name = "y" select = "$last_save/y"/>
                        <xsl:with-param name = "angle" select = "$last_save/angle"/>
                        <xsl:with-param name = "save" select = "$new_save"/>
                    </xsl:call-template> 
                </xsl:when>
            </xsl:choose>

        </xsl:if>

    </xsl:template>

</xsl:transform>