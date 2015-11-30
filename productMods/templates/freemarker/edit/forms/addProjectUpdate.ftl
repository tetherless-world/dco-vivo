<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#assign requiredHint = "<span class='requiredHint'> *</span>" />

<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />
<#assign updateTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "updateText") />
<#assign formTitle = "Create a project update" + " ${i18n().for} " + editConfiguration.subjectName/>

<h2>${formTitle}</h2>
<form class="editForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
    <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">

    <p class="inline">
        Project Update Title${requiredHint}:
        <input type="text" name="title" id="title" label="title" size="50" role="input" value="${titleValue}">
    </p>

    <p class="inline">
        Reporting Year: [a drop list]
    </p>

    <p class="inline">
        Update Text:<br>
        <textarea rows="10" cols="50" name="updateText" id="updateText" label="updateText" class="useTinyMce" role="input" value="">
        ${updateTextValue}
        </textarea>
    </p>

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

${headScripts.add('<script type="text/javascript" src="${urls.base}/js/jquery_plugins/qtip/jquery.qtip-1.0.0-rc3.min.js"></script>',
'<script type="text/javascript" src="${urls.base}/js/tiny_mce/tiny_mce.js"></script>')}