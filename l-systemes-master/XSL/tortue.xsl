<?xml version = "1.0"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
               xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
               xmlns:fun="foobar"
               version="2.0" 
               exclude-result-prefixes="fun xsd">

    <xsl:output indent = "yes"/>

    <!-- Paramètres d'entrée -->

    <xsl:param name = "name" select = "snow"/>
    <xsl:param name = "iterations" select = "2"/>

    <!-- Fonctions -->

    <xsl:function name="fun:explode" as="xsd:string*">
        <xsl:param name="str" as="xsd:string"/>
        <xsl:variable name="len" as="xsd:integer" select="string-length($str)"/>
        <xsl:sequence select=" for $index in 1 to $len 
                                 return substring($str, $index, 1)"/>
    </xsl:function>

    <xsl:template match = "/">

        <!-- L-Syteme -->
        <xsl:variable name = "lsystem" select = "//lsystem[nom=$name]"/>

        <!-- Axiome -->
        <xsl:variable name = "symbols" select = "string-join($lsystem/axiome/symbole, '')"/>

        <tortue name = "{$name}">
            <xsl:call-template name = "Iterate">
                <xsl:with-param name = "lsystem" select = "$lsystem"/>
                <xsl:with-param name = "symbols" select = "$symbols"/>
                <xsl:with-param name = "iteration" select = "1"/>
                <xsl:with-param name = "acc" select = "$symbols"/>
            </xsl:call-template>
        </tortue>
    
    </xsl:template>

    <xsl:template name = "Iterate">

        <xsl:param name = "lsystem"/>
        <xsl:param name = "symbols"/>
        <xsl:param name = "iteration"/>
        <xsl:param name = "acc"/>

        <xsl:choose>
            <xsl:when test="$iteration &lt; $iterations">

                <xsl:variable name = "new_symbols">
                    <xsl:for-each select = "fun:explode($symbols)">
                        <xsl:variable name = "symbol" select="."/>
                        <xsl:variable name = "rule" select="$lsystem/regles/regle[text()=$symbol]"/>
                        <xsl:value-of select = "if ($rule) then $rule/@image else $symbol"/>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:call-template name = "Iterate">
                    <xsl:with-param name = "lsystem" select="$lsystem"/>
                    <xsl:with-param name = "symbols" select="$new_symbols"/>
                    <xsl:with-param name = "iteration" select="$iteration + 1"/>
                    <xsl:with-param name = "acc" select = "concat($acc, $new_symbols)"/>
                </xsl:call-template>

            </xsl:when>

            <xsl:otherwise>
                <xsl:for-each select="fun:explode($acc)">
                    <xsl:variable name="symbol" select="."/>
                    <xsl:choose>
                        <xsl:when test="$symbol = '['">
                            <action command="STORE"/>
                        </xsl:when>

                        <xsl:when test="$symbol = ']'">
                            <action command="RESTORE"/>
                        </xsl:when>

                        <xsl:otherwise>
                            <xsl:variable name="rule" select="$lsystem/regles/regle[text()=$symbol]"/>
                            <action command="{$rule/@commande}" angle="{$rule/@angle}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
            </xsl:otherwise>

        </xsl:choose>
    </xsl:template> 

</xsl:transform>