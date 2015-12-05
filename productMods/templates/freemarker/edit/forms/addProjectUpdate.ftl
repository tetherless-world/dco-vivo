<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />

<#assign sparqlForAcFilter = editConfiguration.pageData.sparqlForAcFilter />

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
<#assign publicationUri = lvf.getFormFieldValue(editSubmission, editConfiguration, "publicationUri") />
<#assign formTitle = "${i18n().create_project_update}" + " ${i18n().for} " + editConfiguration.subjectName/>

<h2 xmlns="http://www.w3.org/1999/html">${formTitle}</h2>
<form class="editForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
    <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">

    <label for="title">${i18n().project_update_title} ${requiredHint}:</label>
    <input type="text" name="title" id="title" label="title" size="50" role="input" value="${titleValue}">

    <label for="reportingYearUri">${i18n().reporting_year}:</label>
    <#assign reportingYearOpts = editConfiguration.pageData.reportingYearUri />
    <select name="reportingYearUri" id="reportingYearUri" >
        <option value="" <#if reportingYearValue = "">selected</#if>>${i18n().select_one}</option>
    <#list reportingYearOpts?keys as key>
        <option value="${key}" <#if reportingYearValue = key>selected</#if>>${reportingYearOpts[key]}</option>
    </#list>
    </select>

    <label for="updateText">${i18n().project_update_text}:</label>
    <textarea rows="10" cols="50" name="updateText" id="updateText" label="updateText" class="useTinyMce" role="input" value="">
        ${updateTextValue}
    </textarea>

    <label for="publicationUri">${i18n().associated_publication}</label>
    <#assign publicationOpts = editConfiguration.pageData.publicationUri />
    <select name="publicationUri" id="publicationUri" >
        <option value="" <#if publicationUri = "">selected</#if>>${i18n().select_one}</option>
    <#list publicationOpts?keys as key>
        <option value="${key}" <#if publicationUri = key>selected</#if>>${publicationOpts[key]}</option>
    </#list>
    </select>

    <#--
    <input class="acSelector" size="60"  type="text" id="publicationUri" name="publicationUri" acGroupName="publicationUri"  value="${publicationUri}" />
    <div class="acSelection" acGroupName="publicationUri" id="publicationUri">
        <p class="inline">
            <label>${i18n().selected_publication}:</label>
            <span class="acSelectionInfo"></span>
            <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
            <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
        </p>
        <input class="acUriReceiver" type="hidden" id="publicationUri" name="publicationUri" value=""  ${flagClearLabelForExisting}="true" />
    </div>
    -->

    <p class="inline">
        Created by
        <input type="text" name="createdBy" id="createdBy" label="createdBy" size="30" role="input">
    </p>

    <p class="inline">
        Created on:
        <input type="text" name="createdOn" id="createdOn" label="createdOn" size="30" role="input">
    </p>

    <p class="inline">
        Creation Note:
        <input type="text" name="creationNote" id="creationNote" label="creationNote" size="50" role="input">
    </p>

    <p class="submit">
        <input type="submit" id="submit" value="create" role="submit" />
        <span class="or"> or </span>
        <a title="Cancel" href="${editConfiguration.urlToReturnTo}">Cancel</a>
    </p>

</form>


<#assign defaultHeight="200" />
<#assign defaultWidth="75%" />
<#assign defaultButton="bold,italic,underline,separator,link,bullist,numlist,separator,sub,sup,charmap,separator,undo,redo,separator,code"/>
<#assign defaultToolbarLocation = "top" />
<#if !height?has_content>
    <#assign height=defaultHeight/>
</#if>

<#if !width?has_content>
    <#assign width=defaultWidth />
</#if>

<#if !buttons?has_content>
    <#assign buttons = defaultButton />
</#if>

<#if !toolbarLocation?has_content>
    <#assign toolbarLocation = defaultToolbarLocation />
</#if>
<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

<script type="text/javascript">
    var customFormData  = {
        sparqlForAcFilter: '${sparqlForAcFilter}',
        sparqlQueryUrl: '${sparqlQueryUrl}',
        acUrl: '${urls.base}/autocomplete?tokenize=true',
        acTypes: {publication: 'http://purl.org/ontology/bibo/Document', collection: 'http://purl.org/ontology/bibo/Periodical', book: 'http://purl.org/ontology/bibo/Book', conference: 'http://purl.org/NET/c4dm/event.owl#Event', event: 'http://purl.org/NET/c4dm/event.owl#Event', editor: 'http://xmlns.com/foaf/0.1/Person', publisher: 'http://xmlns.com/foaf/0.1/Organization'},
        editMode: '${editMode}',
        defaultTypeName: 'publication', // used in repair mode to generate button text
        multipleTypeNames: {collection: 'publication', book: 'book', conference: 'conference', event: 'event', editor: 'editor', publisher: 'publisher'},
        acFilterForIndividuals: ${acFilterForIndividuals},
        baseHref: '${urls.base}/individual?uri=',
        blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}',
        tinyMCEData : {
            theme : "advanced",
            mode : "textareas",
            theme_advanced_buttons1 : "${buttons}",
            theme_advanced_buttons2 : "",
            theme_advanced_buttons3 : "",
            theme_advanced_toolbar_location : "${toolbarLocation}",
            theme_advanced_toolbar_align : "left",
            theme_advanced_statusbar_location : "bottom",
            theme_advanced_path : false,
            theme_advanced_resizing : true,
            height : "${height}",
            width  : "${width}",
            valid_elements : "a[href|name|title],br,p,i,em,cite,strong/b,u,sub,sup,ul,ol,li",
            fix_list_elements : true,
            fix_nesting : true,
            cleanup_on_startup : true,
            gecko_spellcheck : true,
            forced_root_block: false
            // plugins: "paste",
            // theme_advanced_buttons1_add : "pastetext,pasteword,selectall",
            // paste_create_paragraphs: false,
            // paste_create_linebreaks: false,
            // paste_use_dialog : true,
            // paste_auto_cleanup_on_paste: true,
            // paste_convert_headers_to_strong : true,
            // save_callback : "customSave",
            // content_css : "example_advanced.css",
            // extended_valid_elements : "a[href|target|name]"
            // plugins : "table",
            // theme_advanced_buttons3_add_before : "tablecontrols,separator",
            // invalid_elements : "li",
            // theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Table Row=tableRow1", // Theme specific setting CSS classes
        }
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}'
    };
</script>


${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocomplete.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/tiny_mce/jquery-tinymce.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/edit/initTinyMce.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/defaultDataPropertyUtils.js"></script>')}
