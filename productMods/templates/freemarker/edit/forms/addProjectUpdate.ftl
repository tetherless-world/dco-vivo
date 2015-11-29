<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />
<#assign updateTextValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "updateText") />
<#assign formTitle = "Create a project update" + " ${i18n().for} " + editConfiguration.subjectName/>

<h2>${formTitle}</h2>
<form class="editForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <input type="hidden" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input">
    <input type="hidden" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">

    <p>
        Project Update Title:
        <input type="text" name="title" id="title" label="title" size="30" role="input" value="${titleValue}">
    </p>

    <p>
        For Project (Should be non-editable):
        <input type="text" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}">
    </p>

    <p>
        For Reporting Year:
        <br>
        [a drop list]
    </p>

    <p>
        Update Text:
        <br>
        <input type="text" name="updateText" id="updateText" label="updateText" size="50" role="input" value="${updateTextValue}">
    </p>

    <p>
        Associated Publications
        <br>
        [search box]
    </p>

    <p>
        Created by
        <br>
        [Person]
    </p>

    <p>
        Created on
        <br>
        [Date]
    </p>

    <p>
        Creation Note
        <br>
        [Plain text box]
    </p>



    <p class="submit">
        <input type="submit" id="submit" value="create" role="submit" />
        <span class="or"> or </span>
        <a title="Cancel" href="${editConfiguration.urlToReturnTo}">Cancel</a>
    </p>

</form>