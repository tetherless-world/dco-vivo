<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for faux property "creator". See the PropertyConfig.3 file for details. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-sequence.ftl" as s>
<@showCreatorship statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showCreatorship statement>
    <#if statement.creator??>
    	<#if statement.subclass?? && statement.subclass?contains("vcard")>
        	${statement.creatorName}
    	<#else>
        	<a href="${profileUrl(statement.uri("creator"))}" title="${i18n().creator_name}">${statement.creatorName}</a>
    	</#if>
    <#else>
        <#-- This shouldn't happen, but we must provide for it -->
        <a href="${profileUrl(statement.uri("creatorship"))}" title="${i18n().missing_creator}">${i18n().missing_creator}</a>
    </#if>
</#macro>
