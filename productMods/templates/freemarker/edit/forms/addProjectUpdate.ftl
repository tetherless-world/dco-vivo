<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />

<#assign sparqlForPublicationAcFilter = editConfiguration.pageData.sparqlForPublicationAcFilter />

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

<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />
<#assign updateTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "updateText") />
<#assign reportingYearValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "reportingYearUri") />
<#assign publicationUriValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "publicationUri") />
<#assign formTitle = "${i18n().create_project_update}" + " ${i18n().for} " + "\"" + editConfiguration.subjectName + "\"" />
<#--<#assign submittedOnValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "submittedOn") />-->

<h2 xmlns="http://www.w3.org/1999/html">${formTitle}</h2>
<form class="editForm customForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <p>
        <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
        <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">
    </p>

    <p>
        <label for="title">${i18n().project_update_title} ${requiredHint}:</label>
        <input type="text" name="title" id="title" label="title" size="50" role="input" value="${titleValue}">
    </p>

    <p>
        <label for="reportingYear">${i18n().reporting_year}:</label>
        <#assign reportingYearOpts = editConfiguration.pageData.reportingYearUri />
        <select name="reportingYearUri" id="reportingYearUri" >
            <option value="" <#if reportingYearValue = "">selected</#if>>${i18n().select_one}</option>
        <#list reportingYearOpts?keys as key>
            <option value="${key}" <#if reportingYearValue = key>selected</#if>>${reportingYearOpts[key]}</option>
        </#list>
        </select>
    </p>

    <p>
        <label for="updateText">${i18n().project_update_text}:</label>
        <textarea rows="10" cols="50" name="updateText" id="updateText" class="useTinyMce" role="textarea">${updateTextValue}</textarea>
    </p>

    <p>
        <label for="publication">${i18n().associated_publication}:</label>
        <input class="acSelector" size="60"  type="text" id="publicationTitle" name="publicationTitle" acGroupName="publication"  value="" />
        <a href="#publicationTitleClear" class="clear" name="publicationTitleClear" id="publicationTitleClear"> ${i18n().clear_link}</a>
    </p>
    <div class="acSelection" acGroupName="publication" id="pubAcSelection">
        <p class="inline">
            <label>${i18n().selected_publication}:</label>
            <span class="acSelectionInfo"></span>
            <br />
            <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
            <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
        </p>
        <input class="acUriReceiver" type="hidden" id="publicationUri" name="publicationUri" value="${publicationUriValue}"  ${flagClearLabelForExisting}="true" />
    </div>

    <#--<p>-->
    <#--the project update object have no such predicate for "creator" yet!!!-->
        <#--<label for="creator">${i18n().created_by}:</label>-->
        <#--<input type="text" name="createdBy" id="createdBy" label="createdBy" size="30" role="input">-->
    <#--</p>-->

    <p>
        <label for="submittedOn">${i18n().created_on}:</label>
        <input type="text" name="submittedOn" id="submittedOn" label="submittedOn" size="30" role="input">
    </p>

    <p>
        <label for="creationNote">${i18n().creation_note}:</label>
        <textarea rows="10" cols="50" name="creationNote" id="creationNote" class="useTinyMce" role="textarea"></textarea>
    </p>

    <p class="submit">
        <input type="submit" id="submit" value="${i18n().create_entry}" role="button" />
        <span class="or">${i18n().or}</span>
        <a title="${i18n().cancel_title}" href="${editConfiguration.urlToReturnTo}">${i18n().cancel_link}</a>
    </p>

</form>

<style type="text/css">
    form#addProjectUpdate p {
        text-indent: 0;
    }
</style>

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

<script type="text/javascript">
    var customFormData  = {
        sparqlForAcFilter: '${sparqlForPublicationAcFilter}',
        sparqlQueryUrl: '${sparqlQueryUrl}',
        acUrl: '${urls.base}/autocomplete?tokenize=true',
        acTypes: {publication: 'http://purl.org/ontology/bibo/Document', collection: 'http://purl.org/ontology/bibo/Periodical', book: 'http://purl.org/ontology/bibo/Book', conference: 'http://purl.org/NET/c4dm/event.owl#Event', event: 'http://purl.org/NET/c4dm/event.owl#Event', editor: 'http://xmlns.com/foaf/0.1/Person', publisher: 'http://xmlns.com/foaf/0.1/Organization'},
        editMode: '${editMode}',
        acSelectOnly: 'true',
        defaultTypeName: 'publication', // used in repair mode to generate button text
        multipleTypeNames: {collection: 'publication', book: 'book', conference: 'conference', event: 'event', editor: 'editor', publisher: 'publisher'},
        acFilterForIndividuals: ${acFilterForIndividuals},
        baseHref: '${urls.base}/individual?uri=',
        blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}'
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}'
    };
</script>

<#include "tinyMCEScripts.ftl">
<script type="text/javascript">
    $(document).ready(function(){
        defaultDataPropertyUtils.onLoad();
    });
</script>

<script>
    var date = new Date();
    // GET YYYY, MM AND DD FROM THE DATE OBJECT
    var yyyy = date.getFullYear().toString();
    var mm = (date.getMonth()+1).toString();
    var dd  = date.getDate().toString();
    // CONVERT mm AND dd INTO chars
    var mmChars = mm.split('');
    var ddChars = dd.split('');
    // CONCAT THE STRINGS IN YYYY-MM-DD FORMAT
    var datestring = yyyy + '-' + (mmChars[1]?mm:"0"+mmChars[0]) + '-' + (ddChars[1]?dd:"0"+ddChars[0]);
    document.getElementById("submittedOn").defaultValue = datestring;
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteForMultipleSelection.js"></script>',
            <#--'<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocomplete.js"></script>',-->
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/defaultDataPropertyUtils.js"></script>')}