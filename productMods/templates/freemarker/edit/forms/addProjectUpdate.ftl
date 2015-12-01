<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#include "defaultFormScripts.ftl">

<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />
<#assign updateTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "updateText") />
<#assign reportingYearValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "reportingYearUri") />
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
        

    <p class="inline">
        Associated Publications:
        <input type="text" name="associatedPublication" id="associatedPublication" label="associatedPublication" size="30" role="input">
    </p>

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