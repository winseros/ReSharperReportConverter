<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="projectName"/>
    <xsl:param name="currentDate"/>

    <xsl:variable name="documentTitle"><xsl:value-of select="$projectName"/> code inspection report</xsl:variable>

    <xsl:output omit-xml-declaration="yes" indent="yes" method="html" encoding="utf-8"/>
    <xsl:template match="/Report">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="en">
        <head>
            <xsl:text disable-output-escaping="yes">
                &lt;meta charset="UTF-8"&gt;
                &lt;meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"&gt;
                &lt;meta http-equiv="X-UA-Compatible" content="ie=edge"&gt;
            </xsl:text>
            <title><xsl:value-of select="$documentTitle"/> - <xsl:value-of select="$currentDate"/></title>
            <style>
                .font-root {
                    font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
                    font-weight: 400;
                    line-height: 1.5;
                }
                .document-root {
                    padding: 0 7%;
                }
                .header {
                    font-weight: 400;
                    margin: 0 0 15px;
                }
                .header__l1 {
                    font-size: 28px;
                    margin: 0 0 10px
                }
                .header__l2 {
                    font-size: 24px;
                }
                .header__l3 {
                    font-size: 20px;
                }
                .report-date {
                    color: #999;
                    margin: 0 0 30px;
                }
                .button-toggle {
                    position: relative;
                    background-color: transparent;
                    border: none;
                    height: 18px;
                    width: 18px;
                    padding: 0;
                    cursor: pointer;
                }
                .button-toggle::before,
                .button-toggle::after {
                    display: block;
                    content: '';
                    background-color: #000;
                    position: absolute;
                    top: 8px;
                    width: 100%;
                    height: 2px;
                    transform: rotate3d(0, 0, 0, 0);
                    transition: transform 0.11s linear;
                }
                .button-toggle--collapsed::before{
                    transform: rotate3d(0, 0, 1, 180deg);
                }
                .button-toggle--collapsed::after{
                    transform: rotate3d(0, 0, 1, 90deg);
                }
                .button-toggle--top2px {
                    top: 2px;
                }
                .hyperlink {
                    color: #000;
                    text-decoration: none;
                }
                .hyperlink:hover {
                    text-decoration: underline;
                }
                .report-section {
                    margin: 0 0 20px;
                }
                .section-group {
                    margin: 0 0 20px 27px;
                }
                .collapsable-container {
                    max-height: 15000px;
                    opacity: 1;
                    transition: max-height 0.15s linear 0s,
                    opacity 0.15s linear 0.15s;
                }
                .collapsable-container--collapsed {
                    visibility: hidden;
                    max-height: 0;
                    opacity: 0;
                    transition: max-height 0.15s linear 0.15s,
                    opacity 0.15s linear 0s,
                    visibility 0.15s linear 0s;
                    overflow: hidden;
                }
                .report-issue {
                    display: flex;
                    flex-direction: row;
                    flex-wrap: nowrap;
                    width: 100%;
                    margin: 0;
                    padding: 3px 0;
                }
                .report-issue:nth-child(odd) {
                    background-color: #eee;
                }
                .report-issue:last-child {
                    margin-bottom: 15px;
                }
                .report-issue__line {
                    flex-basis: 20%;
                }
                .report-issue__message {
                    flex-basis: 80%;
                    flex-grow: 1;
                }
                .report-issue__severity {
                    width: 25px;
                    border-radius: 1px;
                    border: 1px solid #999;
                    margin-right: 20px;
                }
                .report-issue__severity--INFO {
                    background-color: #c6e1fd;
                }
                .report-issue__severity--HINT {
                    background-color: #8df58b;
                }
                .report-issue__severity--SUGGESTION {
                    background-color: #ffe682;
                }
                .report-issue__severity--WARNING {
                    background-color: #ffc181;
                }
                .report-issue__severity--ERROR {
                    background-color: #f30404;
                }
            </style>
        </head>
        <body class="font-root document-root">
            <h1 class="header header__l1"><xsl:value-of select="$documentTitle"/></h1>
            <p class="report-date"><xsl:value-of select="$currentDate"/></p>
            <xsl:call-template name="section">
                <xsl:with-param name="projects" select="./Project"/>
                <xsl:with-param name="index">1</xsl:with-param>
            </xsl:call-template>
        </body>
        <xsl:text disable-output-escaping="yes">
        &lt;script&gt;
            (function(){
                var ToggleButton = function(element, root) {
                    this._element = element;
                    this._root = root;
                };
                ToggleButton._updateTargetTabIndex = function(target, expanded) {
                    if (expanded) {
                        target.removeAttribute('tabindex');
                    } else if (target.hasAttribute('data-tabindex')) {
                        const tabIndex = parseInt(target.getAttribute('data-tabindex'), 10);
                        !isNaN(tabIndex) &amp;&amp; (target.tabIndex = tabIndex);
                    }
                }
                ToggleButton.prototype.init = function() {
                    this._element.addEventListener('click', this._handleClick.bind(this));
                };
                ToggleButton.prototype._handleClick = function(e) {
                    var ariaControls = this._element.getAttribute('aria-controls');
                    var target = this._root.querySelector('#' + ariaControls);

                    const expandedStr = this._element.getAttribute('aria-expanded') || 'false';
                    const expanded = expandedStr == 'true';

                    this._onToggle(target, expanded, e);
                };
                ToggleButton.prototype._onToggle = function(target, expanded, e) {
                    this._element.setAttribute('aria-expanded', !expanded.toString());
                    target.setAttribute('aria-hidden', expanded.toString());

                    ToggleButton._updateTargetTabIndex(target, expanded);

                    var selfActive = this._element.getAttribute('data-active-self');
                    var targetActive = this._element.getAttribute('data-active-target');

                    if (selfActive || targetActive) {
                        this._element.classList.toggle(selfActive);
                        target.classList.toggle(targetActive);
                    }
                };

                var sections = document.querySelectorAll('.js-report-section');
                Array.prototype.forEach.call(sections, function(section) {
                    var button = section.querySelector('.js-section-toggle');
                    new ToggleButton(button, section).init();
                    var articles = section.querySelectorAll('.js-report-article');
                    Array.prototype.forEach.call(articles, function(article) {
                        var buttons = section.querySelectorAll('.js-article-toggle');
                        Array.prototype.forEach.call(buttons, function(button) {
                            new ToggleButton(button, article).init();
                        });
                    });
                });
            })();
        &lt;/script&gt;
        </xsl:text>
        </html>
    </xsl:template>

    <xsl:template name="section">
        <xsl:param name="projects"/>
        <xsl:param name="index"/>
        <section class="report-section js-report-section">
            <xsl:variable name="sectionId">section-<xsl:value-of select="$index"/></xsl:variable>
            <h2 class="header header__l2">
                <button class="button-toggle js-section-toggle"
                        type="button"
                        aria-label="Toggle section contents"
                        aria-controls="{$sectionId}"
                        aria-expanded="true"
                        data-active-self="button-toggle--collapsed"
                        data-active-target="collapsable-container--collapsed"></button>
                <span><xsl:text>   </xsl:text><xsl:value-of select="$projects[$index]/@Name"/></span>
            </h2>
            <div class="section-group collapsable-container" id="{$sectionId}">
                <xsl:call-template name="article">
                    <xsl:with-param name="files" select="$projects[$index]/File"/>
                    <xsl:with-param name="indexFiles">1</xsl:with-param>
                    <xsl:with-param name="indexProjects" select="$index"/>
                </xsl:call-template>
            </div>
        </section>
        <xsl:if test="not($index >= count($projects))">
            <xsl:call-template name="section">
                <xsl:with-param name="projects" select="$projects"/>
                <xsl:with-param name="index" select="$index + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="article">
        <xsl:param name="files"/>
        <xsl:param name="indexFiles"/>
        <xsl:param name="indexProjects"/>
        <article class="report-article js-report-article">
            <xsl:variable name="articleId">article-<xsl:value-of select="$indexProjects"/>-<xsl:value-of select="$indexFiles"/></xsl:variable>
            <h3 class="header header__l3">
                <button class="button-toggle button-toggle--top2px js-article-toggle"
                        type="button"
                        aria-label="Toggle file contents"
                        aria-controls="{$articleId}"
                        aria-expanded="true"
                        data-active-self="button-toggle--collapsed"
                        data-active-target="collapsable-container--collapsed"></button>
                <span><xsl:text>   </xsl:text><xsl:value-of select="$files[$indexFiles]/@Name"/></span>
            </h3>
            <div class="collapsable-container" id="{$articleId}">
                <xsl:for-each select="$files[$indexFiles]/Line">
                    <xsl:variable name="severity">report-issue__severity--<xsl:value-of select="./@Severity"/></xsl:variable>
                    <p class="report-issue">
                        <span class="report-issue__severity {$severity}" title="{./@Severity}"></span>
                        <xsl:choose>
                            <xsl:when test="./@Href">
                                <a href="{./@Href}" class="report-issue__line hyperlink" target="__blank" rel="noopener">Line: <xsl:value-of select="./@Number"/></a>
                            </xsl:when>
                            <xsl:otherwise>
                                <span class="report-issue__line">Line: <xsl:value-of select="./@Number"/></span>
                            </xsl:otherwise>
                        </xsl:choose>
                        <span class="report-issue__message"><xsl:value-of select="./@Message"/></span></p>
                </xsl:for-each>
            </div>
        </article>
        <xsl:if test="not($indexFiles >= count($files))">
            <xsl:call-template name="article">
                <xsl:with-param name="files" select="$files"/>
                <xsl:with-param name="indexFiles" select="$indexFiles + 1"/>
                <xsl:with-param name="indexProjects" select="$indexProjects"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>