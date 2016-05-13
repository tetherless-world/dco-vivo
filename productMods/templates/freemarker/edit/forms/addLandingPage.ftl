<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain edit configuration information. Are we creating a foaf:Document or editing an existing one-->
<#assign editMode = editConfiguration.pageData.editMode />

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
    <#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#--The blank sentinel indicates what value should be put in a URI when no autocomplete result has been selected.
If the blank value is non-null or non-empty, n3 editing for an existing object will remove the original relationship
if nothing is selected for that object -->
<#assign blankSentinel = "" />
<#if editConfigurationConstants?has_content && editConfigurationConstants?keys?seq_contains("BLANK_SENTINEL")>
    <#assign blankSentinel = editConfigurationConstants["BLANK_SENTINEL"] />
</#if>

<#--In order to fill out the subject-->
<#assign acFilterForIndividuals =  "['" + editConfiguration.subjectUri + "']" />

<#-- This flag is for clearing the label field on submission for an existing object being selected from autocomplete.
Set this flag on the input acUriReceiver where you would like this behavior to occur. -->
<#assign flagClearLabelForExisting = "flagClearLabelForExisting" />

<#--we only allow the creation and deletion of the landingPage URL since changing it means changing the URI of the foaf:Document-->
<#if editMode == "edit">
To edit an dataset page you must add a new one and delete the old one
<br /><br />
<a title="${i18n().cancel_title}" href="${editConfiguration.urlToReturnTo}">Return to Dataset</a>
<#else>
        <#assign titleVerb="${i18n().create_capitalized}">
        <#assign submitButtonText="${i18n().create_entry}">
        <#assign disabledVal=""/>

<#--Display error messages if any-->
<#if submissionErrors?has_content>
    <section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="${i18n().error_alert_icon}" />
        <#--Checking if any required fields are empty-->
        <p>
        <#if lvf.submissionErrorExists(editSubmission, "uri")>
 	        Please enter an dataset landing page URL.
        </#if>
        </p>
    </section>
</#if>

<h2 xmlns="http://www.w3.org/1999/html">Dataset Landing Page</h2>
<form class="editForm customForm" id="addLandingPage" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <p>
        <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
        <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">
    </p>

    <p>
        <input type="text" name="uri" id="uri" label="uri" size="50" role="input">
    </p>

    <p class="submit">
        <input type="submit" id="submit" value="${submitButtonText}"/><span class="or"> ${i18n().or} </span>
        <a title="${i18n().cancel_title}" href="${editConfiguration.urlToReturnTo}">${i18n().cancel_link}</a>
    </p>

</form>

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

<#--any javascript or style sheets that we use to display content in the form-->
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${stylesheets.add('<link rel="stylesheet" type="text/css" href="https://idp.deepcarbon.net/idp/dco.css" />')}
${stylesheets.add('<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"/>')}


${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteForMultipleSelection.js"></script>',
            <#--'<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocomplete.js"></script>',-->
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/defaultDataPropertyUtils.js"></script>')}

</#if>
