<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for adding a dco:ProjectUpdate to a vivo:Project -->

<#import "lib-vivo-form.ftl" as lvf>

<#assign titleValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "title") />

<form class="editForm" id="addProjectUpdate" method="post" enctype="multipart/form-data" action="${submitUrl}">

    <input type="text" name="editKey" id="editKey" value="${editConfiguration.editKey}" role="input" />
    <input type="text" name="subjectUri" id="subjectUri" value="${editConfiguration.subjectUri}" />

    <p>Title:
        <input type="text" name="title" id="title" label="title" size="30" role="input" value="${titleValue}"/>
    </p>


    <p class="submit">
        <input type="submit" id="submit" value="create" role="submit" />
        <span class="or"> or </span>
        <a title="Cancel" href="${editConfiguration.urlToReturnTo}">Cancel</a>
    </p>

</form>