<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

</header>

<#include "developer.ftl">







<div id="wrapper-content" role="main">     

   
    <#if flash?has_content>
        <#if flash?starts_with(i18n().menu_welcomestart) >
            <section  id="welcome-msg-container" role="container">
                <section  id="welcome-message" role="alert">${flash}</section>
            </section>
        <#else>
            <section id="flash-message" role="alert">
                ${flash}
            </section>
        </#if>
    </#if>
    
    <!--[if lte IE 8]>
    <noscript>
        <p class="ie-alert">This site uses HTML elements that are not recognized by Internet Explorer 8 and below in the absence of JavaScript. As a result, the site will not be rendered appropriately. To correct this, please either enable JavaScript, upgrade to Internet Explorer 9, or use another browser. Here are the <a href="http://www.enable-javascript.com"  title="java script instructions">instructions for enabling JavaScript in your web browser</a>.</p>
    </noscript>
    <![endif]-->
	
	<nav id="primary_nav_wrap">
	
	<div id="primary-menu" class="primary-menu block">
	<div id="primary-menu-inner" class="primary-menu-inner inner clearfix">
	<ul class="menu sf-menu sf-js-enabled"><li class="expanded first"><a   href="https://deepcarbon.net/dco/deep-carbon-science" title="DCO Science Directorates, Administration and Infrastructure">Deep Carbon Science</a><ul class="menu" ><li class="leaf first"><a href="https://deepcarbon.net/dco/deep-carbon-science" title="">Overview</a></li>
	<li class="expanded"><a href="https://deepcarbon.net/dco/deep-carbon-science" title="">Communities</a><ul class="menu" ><li class="leaf first"><a   href="https://deepcarbon.net/content/extreme-physics-and-chemistry" title="DCO Extreme Physics and Chemistry Community">Extreme Physics and Chemistry</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/content/reservoirs-and-fluxes" title="DCO Reservoirs and Fluxes Community">Reservoirs and Fluxes</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/content/deep-energy" title="DCO Deep Energy Community">Deep Energy</a></li>
	<li class="leaf last"><a   href="https://deepcarbon.net/content/deep-life" title="DCO Deep Life Community">Deep Life</a></li>
	</ul></li>
	<li class="expanded"><a href="https://deepcarbon.net/page/inside-earth-dco-synthesis-projects" title="">Initiatives</a><ul class="menu" ><li class="leaf first"><a   href="https://deepcarbon.net/page/instrumentation-initiatives" title="Instrumentation Initiatives">Instrumentation</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/page/dco-open-access-and-data-policies" title="">Open Access and Data Policies</a></li>
	<li class="leaf last"><a   href="https://deepcarbon.net/page/inside-earth-dco-synthesis-projects" title="">Synthesis</a></li>
	</ul></li>
	<li class="leaf last"><a href="https://deepcarbon.net/document/bibliography-contributions-dco" title="">Bibliography</a></li>
	</ul></li>
	<li class="expanded"><a   href="https://deepcarbon.net/content/news" title="DCO News and Announcements">News</a><ul class="menu" ><li class="expanded first"><a href="https://deepcarbon.net/content/news" title="">News</a><ul class="menu" ><li class="leaf first"><a href="http://deepcarbon.net/dco-carbon-science" title="">Research</a></li>
	<li class="leaf"><a href="http://deepcarbon.net/dco-highlights" title="">Program Highlights</a></li>
	<li class="leaf last"><a href="http://deepcarbon.net/dco-news-links" title="">DCO in the News</a></li>
	</ul></li>
	<li class="leaf"><a href="https://deepcarbon.net/page/press-resources" title="">Press Resources</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/content/events" title="Upcoming Events">Events</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/content/honors-and-awards" title="Honors and Awards">Honors and Awards</a></li>
	<li class="expanded last"><a   href="https://deepcarbon.net/page/newsletters" title="Newsletters">Newsletters</a><ul class="menu" ><li class="leaf first"><a   href="https://deepcarbon.net/page/sign-dco-newsletter" title="Signup to receive the DCO Newsletter">Registration</a></li>
	<li class="leaf last"><a   href="https://deepcarbon.net/content/newsletters-2013" title="Archive">Archive</a></li>
	</ul></li>
	</ul></li>
	<li class="expanded active-trail"><a   href="https://deepcarbon.net/" title="" class="active">Community Portal</a><ul class="menu" ><li class="leaf first"><a href="https://deepcarbon.net/announcements" title="">Jobs and Opportunities</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/page/dco-early-career-scientist-network" title="">Early Career Scientists</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/page/dco-resource-center" title="">Resource Center</a></li>
	<li class="leaf"><a href="https://deepcarbon.net/page/dco-presentations" title="">Presentations</a></li>
	<li class="leaf last"><a href="https://deepcarbon.net/page/benefits-joining-dco-science-network" title="">Join the Network</a></li>
	</ul></li>
	<li class="expanded"><a href="${urls.base}/"" title="Data Portal">Data Portal</a><ul class="menu" ><li class="leaf first"><a href="https://info.deepcarbon.net/vivo/" title="">DCO Data Portal</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/page/submit-community-data" title="Submit Community Data">Submit Community Data</a></li>
	<li class="leaf"><a href="${urls.base}/publications" title="Publications">Publications</a></li>
	<li class="leaf"><a href="${urls.base}/people" title="People">People</a></li>
	<li class="leaf"><a href="${urls.base}/projects" title="Projects">Project &amp; Field Studies</a></li>
	<li class="leaf"><a href="${urls.base}/field-studies" title="DCO Field Study Browser (map)">Field Sites (map)</a></li>
	<li class="leaf last"><a href="${urls.base}/datasets" title="Datasets">Datasets</a></li>
	</ul></li>
	<li class="expanded"><a   href="https://deepcarbon.net/about/about-dco" title="">About</a><ul class="menu" ><li class="leaf first"><a href="https://deepcarbon.net/about/about-dco" title="">About DCO</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/content/deep-carbon-observatory-executive-committee" title="">Leadership</a></li>
	<li class="leaf"><a   href="https://deepcarbon.net/about/contact-dco" title="Contact DCO">Contact</a></li>
	<li class="leaf last"><a href="https://deepcarbon.net/page/benefits-joining-dco-science-network" title="Join the Network">Join the Network</a></li>
	</ul></li>
	</ul></div><!-- /primary-menu-inner -->
	</div>
	</nav>
	
	
	
	<#include "search.ftl" >
	
