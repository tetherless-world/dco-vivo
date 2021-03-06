<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

</div> <!-- #wrapper-content -->

<footer role="contentinfo">
    <#--
    <p class="copyright">
        <#if copyright??>
            <small>&copy;${copyright.year?c}
            <#if copyright.url??>
                <a href="${copyright.url}" title="${i18n().menu_copyright}">${copyright.text}</a>
            <#else>
                ${copyright.text}
            </#if>
             | <a class="terms" href="/vivo/privacy-policy" title="${i18n().menu_privacy}">${i18n().menu_privacy}</a></small>
             | <a class="terms" href="${urls.termsOfUse}" title="${i18n().menu_termuse}">${i18n().menu_termuse}</a></small> | 
        </#if>
        ${i18n().menu_powered} <a class="powered-by-vivo" href="http://vivoweb.org" target="_blank" title="${i18n().menu_powered} VIVO"><strong>VIVO</strong></a>
        <#if user.hasRevisionInfoAccess>
             | ${i18n().menu_version} <a href="${version.moreInfoUrl}" title="${i18n().menu_version}">${version.label}</a>
        </#if>
    </p>
    
    <nav role="navigation">
        <ul id="footer-nav" role="list">
            <li role="listitem"><a href="${urls.about}" title="${i18n().menu_about}">${i18n().menu_about}</a></li>
            <#if urls.contact??>
                <li role="listitem"><a href="${urls.contact}" title="${i18n().menu_contactus}">${i18n().menu_contactus}</a></li>
            </#if> 
            <li role="listitem"><a href="http://www.vivoweb.org/support" target="blank" title="${i18n().menu_support}">${i18n().menu_support}</a></li>
        </ul>
    </nav>
    -->
    <table class="footertable" style="background-color: black;">
	<tr>
	    <td style="width:15%;padding:1em;">
<ul style="list-style-type:circle;">
<li class="boiler"><a class="dco_anchor" href="/vivo/" title="">Home</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net/about/about-dco" title="">About</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net" title="">Community Portal</a></li>
<li class="boiler"><a class="dco_anchor" href="/vivo/" title="">Data Portal</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net/content/news" title="">News</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net/about/contact-dco" title="">Contact</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net/page/welcome" title="">Help</a></li>
<li class="boiler"><a class="dco_anchor" target="_blank" href="https://deepcarbon.net/page/send-us-your-feedback" title="">Send Us Feedback</a></li>
</ul>		
	    </td>
	    <td style="width:60%;padding:2em;">
		<p class="dco_footer"><img src="https://deepcarbon.net/sites/default/files/images/dco-icon-footer_0.png" style="float: left;"></p>
		<p class="boiler"><strong>The Deep Carbon Observatory</strong> (DCO) is a global community of multi-disciplinary scientists unlocking the inner secrets of Earth through investigations into life, energy, and the fundamentally unique chemistry of carbon.</p>
		<p class="boiler">&nbsp;</p>
		<h6 class="dco_footer boiler">DCO Website Privacy Policy</h6>
		<h6 class="dco_footer boiler">See <a target="_blank" class="dco_anchor" href="https://deepcarbon.net/page/dco-privacy-policy" target="_blank">https://deepcarbon.net/page/dco-privacy-policy</a>.</h6>
		<h6 class="dco_footer boiler">Additional policies may be introduced from time to time.</h6>
		<p class="boiler">&nbsp;</p>
		<h6 class="boiler">VIVO version 1.6.2 - DCO-VIVO version 1.7</h6>
	    </td>
	    <td style="width:25%;padding:1em;">
		<p class="boiler">Site by</p>
		<ul style="list-style-type:circle;">
		<li class="boiler"><a target="_blank" class="dco_anchor" href="http://tw.rpi.edu">Rensselaer Polytechnic Institute</a></li>
		<li class="boiler"><a target="_blank" class="dco_anchor" href="http://www.gso.uri.edu">University of Rhode Island<br>Graduate School of Oceanography</a></li>
		<li class="boiler"><a target="_blank" class="dco_anchor" href="https://www.gl.ciw.edu">Carnegie Institution of Washington</a></li>
		</ul>
	    </td>
	</tr>
    </table>
</footer>

<#include "scripts.ftl">
