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
	<div class="primary-menu block" id="primary-menu">
		<div class="primary-menu-inner inner clearfix" id="primary-menu-inner">
			<ul class="menu sf-menu sf-js-enabled"><li class="expanded first"><a title="DCO Science Directorates, Administration and Infrastructure" href="https://deepcarbon.net/dco/deep-carbon-science">Deep Carbon Science</a>
				<ul class="menu">
					<li class="leaf first"><a title="DCO Extreme Physics and Chemistry Community" href="https://deepcarbon.net//content/extreme-physics-and-chemistry">Extreme Physics and Chemistry</a></li>
					<li class="leaf"><a title="DCO Reservoirs and Fluxes Community" href="https://deepcarbon.net/content/reservoirs-and-fluxes">Reservoirs and Fluxes</a></li>
					<li class="leaf"><a title="DCO Deep Energy Community" href="https://deepcarbon.net/content/deep-energy">Deep Energy</a></li>
					<li class="leaf"><a title="DCO Deep Life Community" href="https://deepcarbon.net/content/deep-life">Deep Life</a></li>
					<li class="leaf"><a title="Instrumentation Initiatives" href="https://deepcarbon.net/dco/instrumentation-initiatives">Instrumentation Initiatives</a></li>
					<li class="leaf last"><a title="" href="https://deepcarbon.net/page/dco-open-access-and-data-policies">Open Access and Data Policies</a></li>
				</ul></li>
	<li class="expanded"><a title="DCO News and Announcements" href="https://deepcarbon.net//content/news">News</a>
	<ul class="menu">
	<li class="leaf first"><a title="" href="https://deepcarbon.net/page/press-resources">Press Resources</a></li>
	<li class="leaf"><a title="Upcoming Events" href="https://deepcarbon.net/content/events">Events</a></li>
	<li class="leaf"><a title="Honors and Awards" href="https://deepcarbon.net/content/honors-and-awards">Honors and Awards</a></li>
	<li class="expanded"><a title="Newsletters" href="https://deepcarbon.net/page/newsletters">Newsletters</a>
	<ul class="menu">
	<li class="leaf first"><a title="Signup to receive the DCO Newsletter" href="https://deepcarbon.net/user_mailman_register">DCO Newsletter Registration</a></li>
	<li class="leaf last"><a title="Newsletter Archive" href="https://deepcarbon.net/content/newsletters-2013">Newsletter Archive</a></li>
	</ul></li>
	<li class="leaf last"><a title="Media Contacts" href="https://deepcarbon.net/page/media-contacts">Media Contacts</a></li>
	</ul></li>
	<li class="expanded active-trail"><a title="" href="https://deepcarbon.net/page/welcome">Community Portal</a><ul class="menu">
	<li class="leaf first"><a title="" href="https://deepcarbon.net/page/submit-community-content">Submit Community Content</a></li>
	<li class="leaf"><a title="" href="https://deepcarbon.net/announcements">Announcements and Jobs</a></li>
	
	<li class="leaf"><a title="" href="https://deepcarbon.net//groups">Groups</a></li>
	<li class="leaf"><a title="" href="https://deepcarbon.net/page/engagement-resource-center">Engagement Resource Center</a></li>
	<li class="leaf last"><a title="" href="https://deepcarbon.net/page/benefits-joining-dco-science-network">Join the Network</a></li>
	</ul></li>
	<li class="collapsed"><a title="" href="${urls.base}/">Data Portal</a>
	<ul class="menu">
		<li class="leaf first"><a title="DCO People Browser" href="${urls.base}/people">People Browser</a></li>
		<li class="leaf first"><a title="" href="${urls.base}/publications">Publications Browser</a></li>
		
		
		<li class="leaf"><a title="Grant Browser" href="https://deepcarbon.net/dco_grant_browser">Grant Browser</a></li>
		<li class="leaf"><a title="Project Browser" href="${urls.base}/projects">Project Browser</a></li>
		
		<li class="leaf"><a title="DCO Field Study Browser (map)" href="${urls.base}/field-studies">Field Study Browser (map)</a></li>
		<li class="leaf"><a title="Dataset Browser" href="${urls.base}/datasets">Dataset Browser</a></li>
		<li class="leaf"><a title="Datatype Browser" href="${urls.base}/datatypes">Datatype Browser</a></li>
		
	</ul></li>
	<li class="expanded last"><a title="" href="https://deepcarbon.net/about/about-dco">About</a><ul><li class="leaf first last"><a title="Contact DCO" href="https://deepcarbon.net/about/contact-dco">Contact DCO</a></li>
	</ul>
	
	</li>
	
	</ul>
	
	</div><!-- /primary-menu-inner -->
	
	</div>
	
	</nav>
	<#include "search.ftl" >
	