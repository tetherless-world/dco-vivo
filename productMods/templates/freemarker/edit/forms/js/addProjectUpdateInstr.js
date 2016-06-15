/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var addProjectUpdateInstrForm = {

    /* *** Initial page setup *** */
   
    onLoad: function() {
        
        if (this.disableFormInUnsupportedBrowsers()) {
            return;
        }        
        this.mixIn();
        this.initObjects();    
        this.initPage();
    },

    disableFormInUnsupportedBrowsers: function() {       
        var disableWrapper = $('#ie67DisableWrapper');
        
        // Check for unsupported browsers only if the element exists on the page
        if (disableWrapper.length) {
            if (vitro.browserUtils.isIELessThan8()) {
                disableWrapper.show();
                $('.noIE67').hide();
                return true;
            }
        }            
        return false;      
    },

    mixIn: function() {
        // Mix in the custom form utility methods
        $.extend(this, vitro.customFormUtils);
        // Get the custom form data from the page
        $.extend(this, customFormData);
        // Get the i18n variables from the page
        $.extend(this, i18nStrings);
    },
    // On page load, create references for easy access to form elements.
    initObjects: function() {
        
        this.form = $('#addProjectUpdate');
        this.showFormButtonWrapper = $('#showAddForm');
        this.submit = this.form.find(':submit');
        this.cancel = this.form.find('.cancel'); 
        //remove links
        this.removeProjectUpdateInstrLinks = $('a.iremove');
        this.errors = $('#errors');
        this.createOwn1 = $('#createOwnOne');
        this.createOwn2 = $('#createOwnTwo');
        this.orSpan = $('span.or')
        this.loadingIndicator = $("#indicator");
        this.showHideSearchResults = $("#showHideResults");
    },
    
    initPage: function() {
    	this.initProjectUpdateInstrData();
        this.bindEventListeners();
              
    },
    bindEventListeners: function() {
    	 this.removeProjectUpdateInstrLinks.click(function() {
             addProjectUpdateInstrForm.removeExistingProjectUpdateInstr(this);
             return false;
         });
    },
    // On page load, associate data with each existing term  element. Then we don't
    // have to keep retrieving data from or modifying the DOM as we manipulate the
    // authorships.
    initProjectUpdateInstrData: function() {
        $('.existingProjectUpdateInstr').each(function(iindex) {
            $(this).data(existingProjectUpdateInstrsData[iindex]);    
            $(this).data('iposition', iindex+1);
        });
    },
    clearSearchResults:function() {
    	$('#selectedProjectUpdateInstr').empty();
    	//Hide the indicator icon if still there
    	$("#indicator").addClass("hidden");
    },
    clearErrors:function() {
    	addProjectUpdateInstrForm.errors.empty();
    },
    removeExistingProjectUpdateInstr: function(link) {
        var removeLast = false,
            message = addProjectUpdateInstrForm.confirmTermDelete;
            
        if (!confirm(message)) {
            return false;
        }
        
        if ($(link)[0] === $('.iremove:last')[0]) {
            removeLast = true;
        } 
        //Using primitive rdf edit which expects an n3 string for deletion
        $.ajax({
            url: $(link).attr('href'),
            type: 'POST', 
            data: {
        		additions: '', 
                retractions: addProjectUpdateInstrForm.generateDeletionN3($(link).parents('.existingProjectUpdateInstr').data('projectUpdateInstrNodeUri'))
            },
            dataType: 'json',
            context: link, // context for callback
            complete: function(request, status) {
                var existingProjectUpdateInstr,
                    projectUpdateInstrNodeUri;
            
                if (status === 'success') {
                    
                    existingProjectUpdateInstr = $(this).parents('.existingProjectUpdateInstr');
                    existingProjectUpdateInstr.fadeOut(400, function() {
                        var numProjectUpdateInstrs;
                        // For undo link: add to a deletedAuthorships array
                        // Remove from the DOM                       
                        $(this).remove();
                        // Actions that depend on the author having been removed from the DOM:
                        numProjectUpdateInstrs = $('.existingProjectUpdateInstr').length; // retrieve the length after removing authorship from the DOM        
                    });

                } else {
                    alert(addProjectUpdateInstrForm.errorInstrNotRemoved);
                }
            }
        });        
    },
    generateDeletionN3: function(projectUpdateInstrNodeUri) {
    	var n3String = "<" + addProjectUpdateInstrForm.subjectUri + "> <" + addProjectUpdateInstrForm.instrPredicateUri + "> <" + projectUpdateInstrNodeUri + "> ."
    	             + "<" + projectUpdateInstrNodeUri + "> <" + addProjectUpdateInstrForm.instrInvPredicateUri + "> <" + addProjectUpdateInstrForm.subjectUri + "> .";
    	return n3String;
    }
};

$(document).ready(function() {   
    addProjectUpdateInstrForm.onLoad();
}); 

