<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for faux property "contributor". See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-sequence.ftl" as s>
<@showContributorship statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showContributorship statement>
    <#if statement.contributor??>
    	<#if statement.subclass?? && statement.subclass?contains("vcard")>
        	${statement.contributorName}
    	<#else>
        	<a href="${profileUrl(statement.uri("contributor"))}" title="${i18n().contributor_name}">${statement.contributorName}</a>
    	</#if>
    <#else>
        <#-- This shouldn't happen, but we must provide for it -->
        <a href="${profileUrl(statement.uri("contributorship"))}" title="${i18n().missing_contributor}">${i18n().missing_contributor}</a>
    </#if>
</#macro>
