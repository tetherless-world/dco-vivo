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
        Reporting Year (a drop list or a hinted text box)
        <input type="text" name="reportingYear" id="reportingYear" label="reportingYear" size="30" role="input">
    </p>

    <p class="inline">
        Update Text:<br>
        <textarea rows="10" cols="50" name="updateText" id="updateText" label="updateText" class="useTinyMce" role="input" value="">
        ${updateTextValue}
        </textarea>
        <br>
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





<script type="text/javascript">
    var customFormData = {
        tinyMCEData : {
            theme : "advanced",
            mode : "textareas",
            theme_advanced_buttons1 : "bold,italic,underline,separator,link,bullist,numlist,separator,sub,sup,charmap,separator,undo,redo,separator,code",
            theme_advanced_buttons2 : "",
            theme_advanced_buttons3 : "",
            theme_advanced_toolbar_location : "top",
            theme_advanced_toolbar_align : "left",
            theme_advanced_statusbar_location : "bottom",
            theme_advanced_path : false,
            theme_advanced_resizing : true,
            height : "200",
            width  : "75%",
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
</script>

<script type="text/javascript" src="/vivo/js/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript" src="/vivo/js/tiny_mce/jquery-tinymce.js"></script>
<script type="text/javascript" src="/vivo/js/edit/initTinyMce.js"></script>