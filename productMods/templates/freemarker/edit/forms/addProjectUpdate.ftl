<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />

<#--<#assign sparqlForPublicationAcFilter = editConfiguration.pageData.sparqlForPublicationAcFilter />-->

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

<#-- These two variables contain the list of publications and instruments to be displayed as the existing publications and instruments. -->
<#-- There are two variables in the object, uri and label. -->
<#assign publications = editConfiguration.pageData.publications/>
<#assign instruments = editConfiguration.pageData.instruments/>
<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />
<#assign updateTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "updateText") />
<#assign reportingYearValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "reportingYearUri") />
<#assign publicationUriValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "publicationUri") />
<#assign publicationLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "publicationLabel") />
<#assign publicationLabelDisplayValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "publicationLabelDisplay") />
<#assign instrumentUriValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "instrumentUri") />
<#assign instrumentLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "instrumentLabel") />
<#assign instrumentLabelDisplayValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "instrumentLabelDisplay") />
<#assign modificationNoteTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "modificationNoteText") />
<#assign modifiedByUriValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "modifiedByUri") />
<#assign modifiedOnValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "modifiedOn") />

<#if editMode == "edit">
        <#assign formTitle = "${i18n().edit_project_update}" + " \"" + editConfiguration.subjectName + "\"" />
        <#assign submitButtonText="${i18n().save_changes}">
        <#assign disabledVal="disabled">
        <#assign modificationType="Modified">
<#else>
        <#assign formTitle = "${i18n().create_project_update}" + " ${i18n().for} " + "\"" + editConfiguration.subjectName + "\"" />
        <#assign titleVerb="${i18n().create_capitalized}">
        <#assign submitButtonText="${i18n().create_entry}">
        <#assign disabledVal=""/>
        <#assign modificationType="Created">
</#if>

<#assign requiredHint = "<span class='requiredHint'> *</span>" />

<#--Display error messages if any-->
<#if submissionErrors?has_content>
    <#if publicationLabelDisplayValue?has_content >
        <#assign publicationLabelValue = publicationLabelDisplayValue />
    </#if>
    <#if instrumentLabelDisplayValue?has_content >
        <#assign instrumentLabelValue = instrumentLabelDisplayValue />
    </#if>
    <section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="${i18n().error_alert_icon}" />
        <#--Checking if any required fields are empty-->
        <p>
        <#if lvf.submissionErrorExists(editSubmission, "title")>
 	        Please enter project update title.
        </#if>
        </p>
        <p>
        <#if lvf.submissionErrorExists(editSubmission, "reportingYearUri")>
 	        Please select a reporting year.
        </#if>
        </p>
        <p>
        <#if lvf.submissionErrorExists(editSubmission, "updateText")>
 	        Please enter project update text.
        </#if>
        </p>
    </section>
</#if>

<h2 xmlns="http://www.w3.org/1999/html">${formTitle}</h2>
<form class="editForm customForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">
    <p>
        <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
        <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">
    </p>

    <p style="display: inline-block;">
        <label for="title">${i18n().project_update_title} ${requiredHint}:</label>
    </p>
    <div class="fa fa-info-circle HelperInfo" id="title-info">
        <div class="HelperInfoContent" id="title-info-content">${i18n().project_update_title_info}</div>
    </div>
    <p>
        <input type="text" name="title" id="title" label="title" size="50" role="input" value="${titleValue}">
    </p>


    <p style="display: inline-block;">
        <label for="reportingYear">${i18n().reporting_year} ${requiredHint}:</label>
    </p>
    <div class="fa fa-info-circle HelperInfo" id="reportingYear-info">
        <div class="HelperInfoContent" id="reportingYear-info-content">${i18n().reporting_year_info}</div>
    </div>
    <p>
        <#assign reportingYearOpts = editConfiguration.pageData.reportingYearUri />
        <select name="reportingYearUri" id="reportingYearUri" >
            <option value="" <#if reportingYearValue = "">selected</#if>>${i18n().select_one}</option>
        <#list reportingYearOpts?keys as key>
            <option value="${key}" <#if reportingYearValue = key>selected</#if>>${reportingYearOpts[key]}</option>
        </#list>
        </select>
    </p>


    <p style="display: inline-block;">
        <label for="updateText">${i18n().project_update_text} ${requiredHint}:</label>
    </p>
    <div class="fa fa-info-circle HelperInfo" id="updateText-info">
        <div class="HelperInfoContent" id="updateText-info-content">${i18n().project_update_text_info}</div>
    </div>
    <p>
        <textarea rows="10" cols="50" name="updateText" id="updateText" class="useTinyMce" role="textarea">${updateTextValue}</textarea>
    </p>


    <p style="display: inline-block;">
        <label for="publication">${i18n().associated_publication}:</label>
    </p>
    <div class="fa fa-info-circle HelperInfo" id="publication-info">
        <div class="HelperInfoContent" id="publication-info-content">${i18n().associated_publication_info}</div>
    </div>
    <div>
        <span style="font-size:9pt;">${i18n().associated_publication_note}</span>
    </div>
    <p>

        <input class="acSelector" size="60"  type="text" id="publication" name="publicationLabel" acGroupName="publication"  value="${publicationLabelValue}" />
        <input  class="display" acGroupName="publication" type="hidden" id="publicationDisplay" name="publicationLabelDisplay" value="${publicationLabelDisplayValue}" />
        <a href="#publicationTitleClear" class="clear" name="publicationTitleClear" id="publicationTitleClear"> ${i18n().clear_link}</a>
    </p>
    <div>
        <#-- This div gets replicated and assigned for each publication that is added. -->
        <div class="acSelection" acGroupName="publication" id="pubAcSelection">
            <p class="inline">
                <label>${i18n().selected_publication}:</label>
                <span class="acSelectionInfo"></span>
                <br />
                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
            </p>
            <input class="acUriReceiver" type="hidden" id="publicationUri" name="publicationUri" value=">SUBMITTED VALUE WAS BLANK<" />
        </div>
    </div>
    <script type="text/javascript">
        var existingProjectUpdatePubsData = [];
        var existingProjectUpdateInstrsData = [];
    </script>
    <#if (publications?size > 0)>
        <p style="display: inline-block;">
            <label for="publications" style="font-size:12pt;">${i18n().current_pu_publications}:</label>
        </p>
        <ul>
        <#-- This displays the existing list of publications. We can't use the built in version because it only allows us to list one of them. -->
        <#list publications as publication>
            <#if (!publication.uri?starts_with("file:"))>
                <li class="existingProjectUpdatePub projectUpdatePubsListContainer" style="font-size:10pt;">
                    <div class="row">
                        <div class="column projectUpdatePubLabel">
                            - <a href="${publication.uri}">${publication.label}</a><input class="acUriReceiver" type="hidden" id="publicationUri" name="publicationUri" value="${publicationUriValue}" />
                        </div>
                        <div class="column projectUpdatePubRemoval">
                             <a href="${urls.base}/edit/primitiveRdfEdit" class="premove" title="${i18n().remove_capitalized}">${i18n().remove_capitalized}</a>
                        </div>
                    </div>
                </li>
                <script type="text/javascript">
                    existingProjectUpdatePubsData.push({
                        "projectUpdatePubNodeUri": "${publication.uri}",
                        "projectUpdatePubLabel": "${publication.label}"      
                    });
                </script>
            </#if>
        </#list>
        </ul>
    </#if>

    <p style="display: inline-block;">
        <label for="instrument">${i18n().refers_to_instrument}:</label>
    </p>
    <div class="fa fa-info-circle HelperInfo" id="instrument-info">
        <div class="HelperInfoContent" id="instrument-info-content">${i18n().instrument_info}</div>
    </div>
    <div>
        <span style="font-size:9pt;">${i18n().instrument_note}</span>
    </div>
    <p>
        <input class="acSelector" size="60"  type="text" id="instrument" name="instrumentLabel" acGroupName="instrument"  value="${instrumentLabelValue}" />
        <input  class="display" acGroupName="instrument" type="hidden" id="instrumentDisplay" name="instrumentLabelDisplay" value="${instrumentLabelDisplayValue}" />
        <a href="#instrumentTitleClear" class="clear" name="instrumentTitleClear" id="instrumentTitleClear"> ${i18n().clear_link}</a>
    </p>

    <div>
        <#-- This div gets replicated and assigned for each instrument that is added. -->
        <div class="acSelection" acGroupName="instrument" id="insAcSelection">
            <p class="inline">
                <label>${i18n().selected_instrument}:</label>
                <span class="acSelectionInfo"></span>
                <br />
                <a href="" class="verifyMatch"  title="${i18n().verify_match_capitalized}">(${i18n().verify_match_capitalized}</a> ${i18n().or}
                <a href="#" class="changeSelection" id="changeSelection">${i18n().change_selection})</a>
            </p>
            <input class="acUriReceiver" type="hidden" id="instrumentUri" name="instrumentUri" value=">SUBMITTED VALUE WAS BLANK<" />
        </div>
    </div>
    <#if (instruments?size > 0)>
        <p style="display: inline-block;">
            <label for="instruments" style="font-size:12pt;">${i18n().current_pu_instruments}:</label>
        </p>
        <ul>
        <#-- This displays the existing list of instruments. We can't use the built in version because it only allows us to list one of them. -->
        <#list instruments as instrument>
            <#if (!instrument.uri?starts_with("file:"))>
                <li class="existingProjectUpdateInstr projectUpdateInstrsListContainer" style="font-size:10pt;">
                    <div class="row">
                        <div class="column projectUpdateInstrLabel">
                            - <a href="${instrument.uri}">${instrument.label}</a><input class="acUriReceiver" type="hidden" id="instrumentUri" name="instrumentUri" value="${instrumentUriValue}" />
                        </div>
                        <div class="column projectUpdateInstrRemoval">
                             <a href="${urls.base}/edit/primitiveRdfEdit" class="iremove" title="${i18n().remove_capitalized}">${i18n().remove_capitalized}</a>
                        </div>
                    </div>
                </li>
                <script type="text/javascript">
                    existingProjectUpdateInstrsData.push({
                        "projectUpdateInstrNodeUri": "${instrument.uri}",
                        "projectUpdateInstrLabel": "${instrument.label}"      
                    });
                </script>
            </#if>
        </#list>
        </ul>
    </#if>

    <#-- Uncomment out elements here to get them to display on the page. For debugging purposes -->
    <#--<p>-->
        <#--<label for="modifiedByUri">${i18n().created_by}:</label>-->
        <input type="hidden" name="modifiedByUri" id="modifiedByUri" label="modifiedByUri" size="30" role="input" value="${modifiedByUriValue}">
        <#--<a href="${user.profileUrl}" class="verifyMatch"  title="${i18n().verify_match_capitalized}">-->
            <#--(${i18n().verify_match_capitalized})-->
        <#--</a>-->
    <#--</p>-->

    <#--<p>-->
        <#--<label for="modifiedOn">${i18n().created_on}:</label>-->
        <input type="hidden" name="modifiedOn" id="modifiedOn" label="modifiedOn" size="30" role="input" value="${modifiedOnValue}">
    <#--</p>-->

    <#--<p>-->
        <#--<label for="modificationNoteText">${i18n().modification_label} ${requiredHint}:</label>-->
        <input type="hidden" name="modificationNoteText" id="modificationNoteText" label="modificationNoteText" size="50" role="input" value="${modificationNoteTextValue}">
    <#--</p>-->

    <p class="submit">
        <input type="submit" id="submit" value="${submitButtonText}" role="button" />
        <span class="or">${i18n().or}</span>
        <a title="${i18n().cancel_title}" href="${editConfiguration.urlToReturnTo}">${i18n().cancel_link}</a>
    </p>

</form>

<style type="text/css">
    form#addProjectUpdate p {
        text-indent: 0;
    }
    .fa-info-circle {
        color:#5C85D6;
    }
    .HelperInfoContent {
        color:black;
    }
    .HelperInfo {
        position:relative;
    }
    .HelperInfo div {
        display: none;
    }
    .HelperInfoHover {
        position:relative;
    }
    .HelperInfoHover div {
        display:block;
        position:absolute;
        width: 20em;
        height: 6em;
        bottom: 1em;
        left: 1em;
        z-index:1000;
        background-color:#FFFFFF;
        padding: 5px;
        border-radius: 4px;
        border-top-color: #5C85D6;
        border-top-style: solid;
        border-top-width: 4px;
        border-right-color: #5C85D6;
        border-right-style: solid;
        border-right-width: 4px;
        border-bottom-color: #5C85D6;
        border-bottom-style: solid;
        border-bottom-width: 4px;
        border-left-color: #5C85D6;
        border-left-style: solid;
        border-left-width: 4px;
    }
</style>

<#assign sparqlQueryUrl = "${urls.base}/ajax/sparqlQuery" >

<script type="text/javascript">
    var customFormData  = {
        acUrl: '${urls.base}/autocomplete?tokenize=true',
        acTypes: {publication: 'http://purl.org/ontology/bibo/Document', instrument: 'http://purl.obolibrary.org/obo/ERO_0000004'},
        editMode: '${editMode}',
        defaultTypeName: 'publication',
        multipleTypeNames: {publication: 'publication', instrument: 'instrument'},
        baseHref: '${urls.base}/individual?uri=',
        blankSentinel: '${blankSentinel}',
        flagClearLabelForExisting: '${flagClearLabelForExisting}',
        <#if editConfiguration.objectUri??>
            subjectUri: '${editConfiguration.objectUri}',
            pubPredicateUri: 'http://info.deepcarbon.net/schema#associatedPublication',
            instrPredicateUri: 'http://info.deepcarbon.net/schema#updateRefersTo',
            instrInvPredicateUri: 'http://info.deepcarbon.net/schema#referencedByUpdate'
        </#if>
    };
    var i18nStrings = {
        selectAnExisting: '${i18n().select_an_existing}',
        orCreateNewOne: '${i18n().or_create_new_one}',
        selectedString: '${i18n().selected}',
        confirmTermDelete: '${i18n().confirm_term_deletion}',
        errorPubNotRemoved: '${i18n().error_term_not_deleted}',
        errorInstrNotRemoved: '${i18n().error_term_not_deleted}'
    };
</script>

<#include "tinyMCEScripts.ftl">
<script type="text/javascript">
    $(document).ready(function(){
        defaultDataPropertyUtils.onLoad();
    });
</script>

<script type="text/javascript">
    function hideAll() {
        for (var i = span.length; i--;) {
            span[i].className = 'fa fa-info-circle HelperInfo';
        }
    }
    var span = document.querySelectorAll('.HelperInfo');
    $(document).ready(function(){
        var span = document.querySelectorAll('.HelperInfo');
        for (var i = span.length; i--;) {
            (function () {
                var t;
                span[i].onmouseover = function () {
                    hideAll();
                    clearTimeout(t);
                    this.className = 'fa fa-info-circle HelperInfoHover';
                };
                span[i].onmouseout = function () {
                    var self = this;
                    t = setTimeout(function () {
                        self.className = 'fa fa-info-circle HelperInfo';
                    }, 50);
                };
            })();
        }
    });
</script>

<#assign creatorUrl = "${user.profileUrl}" >
<#assign defaultNamespace = "${user.defaultNamespace}" >
<script type="text/javascript">
    // this is the display URL of the person editing this project update.
    var creatorUrlEncoded = '${creatorUrl}';

    // in test this url is encoded so decode it
    var creatorUrlDecoded = decodeURIComponent(creatorUrlEncoded);

    // this is what we used before, but doesn't work in production
    // in test the profile url is /vivo/display?uri=http://info.deepcarbon.net/individual/<end-of-uri>
    // in production the profile url is /vivo/display/<end-of-uri>
    var creatorUri = creatorUrlDecoded.substring(21);

    // grab the last slash in the url, we want what's after that
    var n = creatorUrlDecoded.lastIndexOf("/");
    var bas = n == -1 ? "" : creatorUrlDecoded.substring(n+1);

    // we're getting this from configuration
    var dns = '${defaultNamespace}';

    // if either the end of the uri is empty or the namespace is empty then we just don't put anything there
    var userUri = n == -1 ? "" : dns + bas;

    // the uri of the person editing this page is the namespace part of the project uri plus the ending of the display url
    document.getElementById("modifiedByUri").value = userUri;
</script>

<#assign creatorName = "${user.firstName} ${user.lastName}" >
<script type="text/javascript">
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
    document.getElementById("modifiedOn").defaultValue = datestring;

    var creatorName = '${creatorName}';
    var modificationNoteText = "${modificationType} on " + datestring + " by " + creatorName;
    document.getElementById("modificationNoteText").value = modificationNoteText;
</script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/addProjectUpdatePub.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/addProjectUpdateInstr.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${stylesheets.add('<link rel="stylesheet" type="text/css" href="https://idp.deepcarbon.net/idp/dco.css" />')}
${stylesheets.add('<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css"/>')}


${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addProjectUpdatePub.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/addProjectUpdateInstr.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocompleteForMultipleSelection.js"></script>',
            '<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/defaultDataPropertyUtils.js"></script>')}
