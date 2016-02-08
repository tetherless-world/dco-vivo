<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom form for managing web pages for individuals -->
<#if (editConfiguration.pageData.newsLinks?size > 1) >
  <#assign ulClass="class='dd'">
<#else>
  <#assign ulClass="">
</#if>

<#assign baseEditNewsLinkUrl=editConfiguration.pageData.baseEditNewsLinkUrl!"baseEditNewsLinkUrl is undefined">
<#assign deleteNewsLinkUrl=editConfiguration.pageData.deleteNewsLinkUrl!"deleteNewsLinkUrl is undefined">
<#assign showAddFormUrl=editConfiguration.pageData.showAddFormUrl!"showAddFormUrl is undefined">
<#assign predicateUri=editConfiguration.predicateUri!"undefined">

<#if (editConfiguration.pageData.subjectName??) >
<h2><em>${editConfiguration.pageData.subjectName}</em></h2>
</#if>

<h3>${i18n().manage_news_links}</h3>
       
<script type="text/javascript">
    var newsLinkData = [];
</script>

<#if !editConfiguration.pageData.newsLinks?has_content>
    <p>${i18n().has_no_newsLinks}</p>
</#if>

<ul id="webpageList" ${ulClass} role="list">
    <#list editConfiguration.pageData.newsLinks as newsLink>
        <li class="newsLink" role="listitem">
            <#if newsLink.label??>
                <#assign anchor=newsLink.label >
            <#else>
                <#assign anchor=newsLink.url >
            </#if>
            
            <span class="newsLinkName">
                <a href="${newsLink.url}" title="${i18n().newsLink_url}">${anchor}</a>
            </span>
            <span class="editingLinks">
                <a href="${baseEditNewsLinkUrl}&objectUri=${newsLink.vcard}&predicateUri=${predicateUri}&linkUri=${newsLink.link}" class="edit" title="${i18n().edit_newsLink_link}">${i18n().edit_capitalized}</a> | 
                <a href="${urls.base}${deleteNewsLinkUrl}" class="remove" title="${i18n().delete_newsLink_link}">${i18n().delete_button}</a> 
            </span>
        </li>    
        
        <script type="text/javascript">
            newsLinkData.push({
                "newsLinkUri": "${newsLink.link}"              
            });
        </script>      
    </#list>  
</ul>

<section id="addAndCancelLinks" role="section">
    <#-- There is no editConfig at this stage, so we don't need to go through postEditCleanup.jsp on cancel.
         These can just be ordinary links, rather than a v:input element, as in 
         addAuthorsToInformationResource.jsp. -->   
    <a href="${showAddFormUrl}" id="showAddForm" class="button green" title="${i18n().add_new_news_link}">${i18n().add_new_news_links}</a>
       
    <a href="${cancelUrl}" id="returnToIndividual" class="return" title="${i18n().return_to_profile}">${i18n().return_to_profile}</a>
    <img id="indicator" class="indicator hidden" src="${urls.base}/images/indicatorWhite.gif" alt="${i18n().processing_indicator}"/>
</section>


<script type="text/javascript">
var customFormData = {
    rankPredicate: '${editConfiguration.pageData.rankPredicate}',
    reorderUrl: '${urls.base}/edit/reorder'
};
var i18nStrings = {
    dragDropToReorderNewsLinks: '${i18n().drag_drop_to_reorder_newsLinks}',
    newsLinkReorderingFailed: '${i18n().newsLink_reordering_failed}',
    confirmNewsLinkDeletion: '${i18n().confirm_newsLink_deletion}',
    errorRemovingNewsLink: '${i18n().error_removing_newsLink}'
};
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />',
                  '<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/manageNewsForIndividual.css" />',
                  '<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/utils.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
              '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
              '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/manageNewsForIndividual.js"></script>')}

