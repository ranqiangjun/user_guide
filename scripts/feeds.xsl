<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:exsl="http://exslt.org/common" xmlns:cf="http://docbook.sourceforge.net/xmlns/chunkfast/1.0" xmlns:ng="http://docbook.org/docbook-ng" xmlns:db="http://docbook.org/ns/docbook" xmlns="http://www.w3.org/1999/xhtml" version="1.0" exclude-result-prefixes="exsl cf ng db">

<!-- This file contains overrides for the user_guide module, for use
     in making XHML output with the xmlto command that is suitable for
     import with Feeds using the asciidoc_display_feeds module. See script
     mkfeeds.sh for usage. -->

<!-- Use outline numbering for sections. -->
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="section.autolabel.max.depth">1</xsl:param>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="preface.autolabel">i</xsl:param>

<!-- Put chapters on their own pages, not with first section on that page. -->
<xsl:param name="chunk.first.sections" select="1"/>

<!-- Use item IDs as file names, for portability as content shifts. -->
<xsl:variable name="use.id.as.filename">
  <xsl:value-of select="'1'" />
</xsl:variable>

<!-- Set the maximum depth for tables of contents to 2. -->
<xsl:variable name="toc.max.depth">
  <xsl:value-of select="'2'" />
</xsl:variable>

<!-- Use UL lists for tables of contents, not DL lists. -->
<xsl:variable name="toc.list.type">
  <xsl:value-of select="'ul'" />
</xsl:variable>

<!-- Omit a troublesome span in the TOC line. -->
<xsl:template name="toc.line">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="depth" select="1"/>
  <xsl:param name="depth.from.context" select="8"/>

  <!-- * if $autotoc.label.in.hyperlink is zero, then output the label -->
  <!-- * before the hyperlinked title (as the DSSSL stylesheet does) -->
  <xsl:if test="$autotoc.label.in.hyperlink = 0">
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    <xsl:copy-of select="$label"/>
    <xsl:if test="$label != ''">
      <xsl:value-of select="$autotoc.label.separator"/>
    </xsl:if>
  </xsl:if>

  <a>
    <xsl:attribute name="href">
      <xsl:call-template name="href.target">
        <xsl:with-param name="context" select="$toc-context"/>
        <xsl:with-param name="toc-context" select="$toc-context"/>
      </xsl:call-template>
    </xsl:attribute>

  <!-- * if $autotoc.label.in.hyperlink is non-zero, then output the label -->
  <!-- * as part of the hyperlinked title -->
  <xsl:if test="not($autotoc.label.in.hyperlink = 0)">
    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>
    <xsl:copy-of select="$label"/>
    <xsl:if test="$label != ''">
      <xsl:value-of select="$autotoc.label.separator"/>
    </xsl:if>
  </xsl:if>

    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
  </a>
</xsl:template>

<!-- Override the output, to omit HTML headers and put titles in divs. -->
<!-- Also, as compared to bare.xsl, omit footer navigation -->
<xsl:template name="chunk-element-content">
  <xsl:param name="prev"/>
  <xsl:param name="next"/>
  <xsl:param name="nav.context"/>
  <xsl:param name="content">
    <xsl:apply-imports/>
  </xsl:param>
  <xsl:variable name="home" select="/*[1]"/>
  <xsl:variable name="this" select="."/>
  <div id="asciidoc-display-book-title">
    <xsl:apply-templates select="$home" mode="object.title.markup.textonly"/>
  </div>
  <div id="asciidoc-display-section-title">
    <xsl:apply-templates select="$this" mode="object.title.markup.textonly"/>
  </div>
  <div class="asciidoc-display-main-content">
    <xsl:copy-of select="$content"/>
  </div>
</xsl:template>

<!-- Override the output class for programlistings to give an extra class
     if it is PHP -->
<xsl:template match="programlisting" mode="common.html.attributes">
  <xsl:variable name="programtype" select="./@language" />
  <xsl:choose>
    <xsl:when test="$programtype = 'php'">
      <xsl:attribute name="class">programlisting programlisting-php</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="class">programlisting</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Override the output for section headers, so they only show for
     sub-headings, to avoid duplicating the Drupal page title. -->
<xsl:template name="section.heading">
  <xsl:param name="section" select="."/>
  <xsl:param name="level" select="1"/>
  <xsl:param name="allow-anchors" select="1"/>
  <xsl:param name="title"/>
  <xsl:param name="class" select="'title'"/>

  <!-- HTML H level is one higher than section level -->
  <xsl:variable name="hlevel">
    <xsl:choose>
      <!-- highest valid HTML H level is H6; so anything nested deeper
           than 5 levels down just becomes H6 -->
      <xsl:when test="$level &gt; 5">6</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$level + 1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="$level&gt;1">
    <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
      <xsl:if test="$css.decoration != '0'">
        <xsl:if test="$hlevel&lt;3">
          <xsl:attribute name="style">clear: both</xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$allow-anchors != 0">
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="$section"/>
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
      </xsl:if>
      <xsl:copy-of select="$title"/>
    </xsl:element>
  </xsl:if>
</xsl:template>

<!-- Title page with cover image, omitting book title since that appears
     already in the output. -->
<xsl:template name="book.titlepage.recto">
  <xsl:choose>
    <xsl:when test="bookinfo/subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/subtitle"/>
    </xsl:when>
    <xsl:when test="info/subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/subtitle"/>
    </xsl:when>
    <xsl:when test="subtitle">
      <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="subtitle"/>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="bookinfo/mediaobject">
    <xsl:apply-templates select="bookinfo/mediaobject" />
  </xsl:if>

  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/corpauthor"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/authorgroup"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/author"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/author"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/othercredit"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/releaseinfo"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/copyright"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/legalnotice"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/pubdate"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/revision"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/revhistory"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="bookinfo/abstract"/>
  <xsl:apply-templates mode="book.titlepage.recto.auto.mode" select="info/abstract"/>
</xsl:template>

</xsl:stylesheet>
