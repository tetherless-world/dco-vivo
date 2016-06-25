/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var addCreatorForm = {

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
    // NB These must be assigned after the elements have been loaded onto the page.
    initObjects: function() {
        
        this.form = $('#addCreatorForm');
        this.showFormButtonWrapper = $('#showAddForm');
        this.showFormButton = $('#showAddFormButton');
        this.removeCreatorshipLinks = $('a.remove');
        //this.undoLinks = $('a.undo');
        this.submit = this.form.find(':submit');
        this.cancel = this.form.find('.cancel'); 
        this.acSelector = this.form.find('.acSelector');
        this.labelField = $('#label');
        this.firstNameField = $('#firstName');
        this.middleNameField = $('#middleName');
        this.lastNameField = $('#lastName');
        this.lastNameLabel = $('label[for=lastName]');
        this.personUriField = $('#personUri');
        this.firstNameWrapper = this.firstNameField.parent();
        this.middleNameWrapper = this.middleNameField.parent();
        this.lastNameWrapper = this.lastNameField.parent();
        this.selectedCreator = $('#selectedCreator');
        this.selectedCreatorName = $('#selectedCreatorName');
        this.acHelpTextClass = 'acSelectorWithHelpText';
        this.verifyMatch = this.form.find('.verifyMatch');  
        this.personRadio = $('input.person-radio');  
        this.orgRadio = $('input.org-radio');
        this.personSection = $('section#personFields');  
        this.orgSection = $('section#organizationFields');  
        this.orgName = $('input#orgName');
        this.orgNameWrapper = this.orgName.parent();
        this.orgUriField = $('input#orgUri');
        this.selectedOrg = $('div#selectedOrg');
        this.selectedOrgName = $('span#selectedOrgName');
        this.orgLink = $('a#orgLink');
        this.personLink = $('a#personLink');
        this.returnLink = $('a#returnLink');
        
        this.orgSection.hide();
    },
    
    // Initial page setup. Called only at page load.
    initPage: function() {

        this.initCreatorshipData();
            
        // Show elements hidden by CSS for the non-JavaScript-enabled version.
        // NB The non-JavaScript version of this form is currently not functional.
        this.removeCreatorshipLinks.show();
        
        //this.undoLinks.hide();
        
        this.bindEventListeners();
        
        this.initAutocomplete();
        
        this.initElementData();

        this.initCreatorDD();
        
        if (this.findValidationErrors()) {
            this.initFormAfterInvalidSubmission();
        } else {
            this.initCreatorListOnlyView();
        }
    },
    
    
    /* *** Set up the various page views *** */
   
   // This initialization is done only on page load, not when returning to creator list only view 
   // after hitting 'cancel.'
   initCreatorListOnlyView: function() {
       
        if ($('.creatorship').length) {  // make sure we have at least one creator
            // Reorder creators on page load so that previously unranked creators get a rank. Otherwise,
            // when we add a new creator, it will get put ahead of any previously unranked creators, instead
            // of at the end of the list. (It is also helpful to normalize the data before we get started.)            
            this.reorderCreators();
        }        
        this.showCreatorListOnlyView();       
   },
    
    // This view shows the list of existing creators and hides the form.
    // There is a button to show the form. We do this on page load, and after
    // hitting 'cancel' from full view.
    showCreatorListOnlyView: function() {
        this.hideForm();
        this.showFormButtonWrapper.show();
    },

    // View of form after returning from an invalid submission. On this form,
    // validation errors entail that we were entering a new person, so we show
    // all the fields straightaway.
    initFormAfterInvalidSubmission: function() {
        this.initForm();
        this.showFieldsForNewPerson();
    },

    // Initial view of add creator form. We get here by clicking the show form button,
    // or by cancelling out of an autocomplete selection.
    initFormView: function() {
        
        this.initForm();
        
        // There's a conflict bewteen the last name fields .blur event and the cancel
        // button's click. So display the middle and first names along with the last name tlw72
        //this.hideFieldsForNewPerson();

        // This shouldn't be needed, because calling this.hideFormFields(this.lastNameWrapper)
        // from showSelectedCreator should do it. However, it doesn't work from there,
        // or in the cancel action, or if referring to this.lastNameField. None of those work,
        // however.
        $('#lastName').val(''); 
        // Set the initial autocomplete help text in the acSelector field.
        this.addAcHelpText(this.acSelector);
        
        return false; 
        
    },
    
    // Form initialization common to both a 'clean' form view and when
    // returning from an invalid submission.
    initForm: function() {
        
        // Hide the button that shows the form
        this.showFormButtonWrapper.hide(); 

        this.hideSelectedPerson();
        this.hideSelectedOrg();

        this.cancel.unbind('click');
        this.cancel.bind('click', function() {
            addCreatorForm.showCreatorListOnlyView();
            addCreatorForm.setCreatorType("person");
            return false;
        });
        
        // Reset the last name field. It had been hidden if we selected an creator from
        // the autocomplete field.
        this.lastNameWrapper.show(); 
        this.showFieldsForNewPerson();        

        // Show the form
        this.form.show();                 
        //this.lastNameField.focus();
    },   
    
    hideSelectedPerson: function() {
        this.selectedCreator.hide();
        this.selectedCreatorName.html('');
        this.personUriField.val('');
    },

    hideSelectedOrg: function() {
        this.selectedOrg.hide();
        this.selectedOrgName.html('');
        this.orgUriField.val('');
    },

    showFieldsForNewPerson: function() {    
        this.firstNameWrapper.show();
        this.middleNameWrapper.show();
    },

    hideFieldsForNewPerson: function() {   
        this.hideFields(this.firstNameWrapper); 
        this.hideFields(this.middleNameWrapper); 
    },
        
    /* *** Ajax initializations *** */

    /* Autocomplete */
    initAutocomplete: function() {

        // Make cache a property of this so we can access it after removing 
        // an creator.
        this.acCache = {};  
        this.setAcFilter();
        var $acField;
        var urlString;
        var creatorType;
        
        if  ( this.personRadio.attr("checked") ) {
            $acField = this.lastNameField;
            urlString = addCreatorForm.acUrl + addCreatorForm.personUrl + addCreatorForm.tokenize;
            creatorType = "person";
        }
        else {
            $acField = this.orgName;
            urlString = addCreatorForm.acUrl + addCreatorForm.orgUrl + addCreatorForm.tokenize;
            creatorType = "org";
        }  
        $acField.autocomplete({
            minLength: 2,
            source: function(request, response) {
                if (request.term in addCreatorForm.acCache) {
                    // console.log('found term in cache');
                    response(addCreatorForm.acCache[request.term]);
                    return;
                }
                // console.log('not getting term from cache');
                
                // If the url query params are too long, we could do a post
                // here instead of a get. Add the exclude uris to the data
                // rather than to the url.
                $.ajax({
                    url: urlString,
                    dataType: 'json',
                    data: {
                        term: request.term
                    }, 
                    complete: function(xhr, status) {
                        // Not sure why, but we need an explicit json parse here. jQuery
                        // should parse the response text and return a json object.
                        var results = jQuery.parseJSON(xhr.responseText),
                            filteredResults = addCreatorForm.filterAcResults(results);
                        addCreatorForm.acCache[request.term] = filteredResults;  
                        response(filteredResults);
                    }

                });
            },
            // Select event not triggered in IE6/7 when selecting with enter key rather
            // than mouse. Thus form is disabled in these browsers.
            // jQuery UI bug: when scrolling through the ac suggestions with up/down arrow
            // keys, the input element gets filled with the highlighted text, even though no
            // select event has been triggered. To trigger a select, the user must hit enter
            // or click on the selection with the mouse. This appears to confuse some users.
            select: function(event, ui) {
                addCreatorForm.showSelectedCreator(ui,creatorType); 
            }
        });

    },

    initElementData: function() {   
        this.verifyMatch.data('baseHref', this.verifyMatch.attr('href'));
    },

    setAcFilter: function() {
        this.acFilter = [];
        
        $('.creatorship').each(function() {
            var uri = $(this).data('CreatorUri');
            addCreatorForm.acFilter.push(uri);
         });
    },
    
    removeCreatorFromAcFilter: function(creator) {
        var index = $.inArray(creator, this.acFilter);
        if (index > -1) { // this should always be true
            this.acFilter.splice(index, 1);
        }   
    },
    
    filterAcResults: function(results) {
        var filteredResults = [];
        if (!this.acFilter.length) {
            return results;
        }
        $.each(results, function() {
            if ($.inArray(this.uri, addCreatorForm.acFilter) == -1) {
                // console.log("adding " + this.label + " to filtered results");
                filteredResults.push(this);
            }
            else {
                // console.log("filtering out " + this.label);
            }
        });
        return filteredResults;
    },
    
    // After removing an creatorship, selectively clear matching autocomplete
    // cache entries, else the associated creator will not be included in 
    // subsequent autocomplete suggestions.
    clearAcCacheEntries: function(name) {
        name = name.toLowerCase();
        $.each(this.acCache, function(key, value) {
            if (name.indexOf(key) == 0) {
                delete addCreatorForm.acCache[key];
            }
        });
    },
    
    // Action taken after selecting an creator from the autocomplete list
    showSelectedCreator: function(ui,creatorType) {

        if ( creatorType == "person" ) {
            this.personUriField.val(ui.item.uri);
            this.selectedCreator.show();

            // Transfer the name from the autocomplete to the selected creator
            // name display, and hide the last name field.
            this.selectedCreatorName.html(ui.item.label);
            // NB For some reason this doesn't delete the value from the last name
            // field when the form is redisplayed. Thus it's done explicitly in initFormView.
            this.hideFields(this.lastNameWrapper);
            // These get displayed if the selection was made through an enter keystroke,
            // since the keydown event on the last name field is also triggered (and
            // executes first). So re-hide them here.
            this.hideFieldsForNewPerson(); 
            this.personLink.attr('href', this.verifyMatch.data('baseHref') + ui.item.uri);
        }
        else {
            // do the same as above but for the organization fields
            this.orgUriField.val(ui.item.uri); 
            this.selectedOrg.show();

            this.selectedOrgName.html(ui.item.label);

            this.hideFields(this.orgNameWrapper); 

            this.orgLink.attr('href', this.verifyMatch.data('baseHref') + ui.item.uri);
        }

        // Cancel restores initial form view
        this.cancel.unbind('click');
        this.cancel.bind('click', function() {
            addCreatorForm.initFormView();
            addCreatorForm.setCreatorType(creatorType);
            return false;
        });
    },
        
    /* Drag-and-drop */
    initCreatorDD: function() {
        
        var creatorshipList = $('#creatorships'),
            creatorships = creatorshipList.children('li');
        
        if (creatorships.length < 2) {
            return;
        }
        
        $('.creatorNameWrapper').each(function() {
            $(this).attr('title', addCreatorForm.creatorNameWrapperTitle);
        });
        
        creatorshipList.sortable({
            cursor: 'move',
            update: function(event, ui) {
                addCreatorForm.reorderCreators(event, ui);
            }
        });     
    },
    
    // Reorder creators. Called on page load and after creator drag-and-drop and remove.
    // Event and ui parameters are defined only in the case of drag-and-drop.
    reorderCreators: function(event, ui) {
        var creatorships = $('li.creatorship').map(function(index, el) {
            return $(this).data('creatorshipUri');
        }).get();

        $.ajax({
            url: addCreatorForm.reorderUrl,
            data: {
                predicate: addCreatorForm.rankPredicate,
                individuals: creatorships
            },
            traditional: true, // serialize the array of individuals for the server
            dataType: 'json',
            type: 'POST',
            success: function(data, status, request) {
                var pos;
                $('.creatorship').each(function(index){
                    pos = index + 1;
                    // Set the new position for this element. The only function of this value 
                    // is so we can reset an element to its original position in case reordering fails.
                    addCreatorForm.setPosition(this, pos);                
                });
                // Set the form rank field value.
                $('#rank').val(pos + 1);        
            },
            error: function(request, status, error) {
                // ui is undefined on page load and after an creatorship removal.
                if (ui) {
                    // Put the moved item back to its original position.
                    // Seems we need to do this by hand. Can't see any way to do it with jQuery UI. ??
                    var pos = addCreatorForm.getPosition(ui.item),                       
                        nextpos = pos + 1, 
                        creatorships = $('#creatorships'), 
                        next = addCreatorForm.findCreatorship('position', nextpos);
                    
                    if (next.length) {
                        ui.item.insertBefore(next);
                    }
                    else {
                        ui.item.appendTo(creatorships);
                    }
                    
                    alert(addCreatorForm.reorderCreatorsAlert);                                 
                }      
            }
        });           
    },
    
    // On page load, associate data with each creatorship element. Then we don't
    // have to keep retrieving data from or modifying the DOM as we manipulate the
    // creatorships.
    initCreatorshipData: function() {
        $('.creatorship').each(function(index) {
            $(this).data(creatorshipData[index]);    
            
            // RY We might still need position to put back an element after reordering
            // failure. Rank might already have been reset? Check.
            // We also may need position to implement undo links: we want the removed creatorship
            // to show up in the list, but it has no rank.
            $(this).data('position', index+1);      
        });
    },

    getPosition: function(creatorship) {
        return $(creatorship).data('position');
    },
    
    setPosition: function(creatorship, pos) {
        $(creatorship).data('position', pos);
    },
    
    findCreatorship: function(key, value) {
        var matchingCreatorship = $(); // if we don't find one, return an empty jQuery set
        
        $('.creatorship').each(function() {
            var creatorship = $(this);
            if ( creatorship.data(key) === value ) {
                matchingCreatorship = creatorship; 
                return false; // stop the loop
            }
        });
         
        return matchingCreatorship;       
    },
    
               
    /* *** Event listeners *** */ 
   
    bindEventListeners: function() {
        
        this.showFormButton.click(function() {
            addCreatorForm.initFormView();
            return false;
        });
        
        this.orgRadio.click(function() {
            addCreatorForm.setCreatorType("org");
        });

        this.personRadio.click(function() {
            addCreatorForm.setCreatorType("person");
        });

        this.form.submit(function() {
            // NB Important JavaScript scope issue: if we call it this way, this = addCreatorForm 
            // in prepareSubmit. If we do this.form.submit(this.prepareSubmit); then
            // this != addCreatorForm in prepareSubmit.
            $selectedObj = addCreatorForm.form.find('input.acSelector');
            addCreatorForm.deleteAcHelpText($selectedObj);
			addCreatorForm.prepareSubmit(); 
        });     

        this.lastNameField.blur(function() {
            // Cases where this event should be ignored:
            // 1. personUri field has a value: the autocomplete select event has already fired.
            // 2. The last name field is empty (especially since the field has focus when the form is displayed).
            // 3. Autocomplete suggestions are showing.
            if ( addCreatorForm.personUriField.val() || !$(this).val() || $('ul.ui-autocomplete li.ui-menu-item').length ) {
                return;
            }
            addCreatorForm.onLastNameChange();
        });

        this.personLink.click(function() {
            window.open($(this).attr('href'), 'verifyMatchWindow', 'width=640,height=640,scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no,location=no');
            return false;
        });   

        this.orgLink.click(function() {
            window.open($(this).attr('href'), 'verifyMatchWindow', 'width=640,height=640,scrollbars=yes,resizable=yes,status=yes,toolbar=no,menubar=no,location=no');
            return false;
        });   

    	this.acSelector.focus(function() {
        	addCreatorForm.deleteAcHelpText(this);
    	});   

    	this.acSelector.blur(function() {
        	addCreatorForm.addAcHelpText(this);
    	}); 
                
    	this.orgName.focus(function() {
        	addCreatorForm.deleteAcHelpText(this);
    	});   

    	this.orgName.blur(function() {
        	addCreatorForm.addAcHelpText(this);
    	}); 
                
        // When hitting enter in last name field, show first and middle name fields.
        // NB This event fires when selecting an autocomplete suggestion with the enter
        // key. Since it fires first, we undo its effects in the ac select event listener.
        this.lastNameField.keydown(function(event) {
            if (event.which === 13) {
                addCreatorForm.onLastNameChange();
                return false; // don't submit form
            }
        });
        
        this.removeCreatorshipLinks.click(function() {
            addCreatorForm.removeCreatorship(this);
            return false;
        });
        
    },

    prepareSubmit: function() {
        var firstName,
            middleName,
            lastName,
            name;
        
        // If selecting an existing person, don't submit name fields
        if (this.personUriField.val() != '' || this.orgUriField.val() != '' || this.orgName.val() != '' ) {
            this.firstNameField.attr('disabled', 'disabled');
            this.middleNameField.attr('disabled', 'disabled');
            this.lastNameField.attr('disabled', 'disabled');
        } 
        else {
            firstName = this.firstNameField.val();
            middleName = this.middleNameField.val();
            lastName = this.lastNameField.val();
            
            name = lastName;
            if (firstName) {
                name += ', ' + firstName;
            }
            if (middleName) {
                name += ' ' + middleName;
            }
            
            this.labelField.val(name);
        }
		// If user selected org via autocomplete, clear the org name field
		if ( this.orgUriField.val() != '' ) {
			this.orgName.val("");
		}

    },    
    
    onLastNameChange: function() {
        this.showFieldsForNewPerson();
        this.firstNameField.focus();
        // this.fixNames();
    },
    
    // User may have typed first name as well as last name into last name field.
    // If so, when showing first and middle name fields, move anything after a comma
    // or space into the first name field.
    // RY Space is problematic because they may be entering "<firstname> <lastname>", but
    // comma is a clear case. 
//    fixNames: function() {
//        var lastNameInput = this.lastNameField.val(),
//            names = lastNameInput.split(/[, ]+/), 
//            lastName = names[0];
// 
//        this.lastNameField.val(lastName);
//        
//        if (names.length > 1) {
//            //firstName = names[1].replace(/^[, ]+/, '');
//            this.firstNameField.val(names[1]);
//        } 
//    },
     
    removeCreatorship: function(link) {
        // RY Upgrade this to a modal window

        creatorName = $(link).prev().children().text();

        var removeLast = false,
            message = addCreatorForm.removeCreatorshipMessage + '\n\n' + creatorName + ' ?\n\n';
        if (!confirm(message)) {
            return false;
        }

        if ( addCreatorForm.showFormButtonWrapper.is(':visible') ) {
            addCreatorForm.returnLink.hide();
            $('img#indicatorOne').removeClass('hidden');
            addCreatorForm.showFormButton.addClass('disabledSubmit');
            addCreatorForm.showFormButton.attr('disabled','disabled');
        }
        else {
            addCreatorForm.cancel.hide();
            $('img#indicatorTwo').removeClass('hidden');            
            addCreatorForm.submit.addClass('disabledSubmit');
            addCreatorForm.submit.attr('disabled','disabled');
        }
              
        if ($(link)[0] === $('.remove:last')[0]) {
            removeLast = true;
        } 
        
        $.ajax({
            url: $(link).attr('href'),
            type: 'POST', 
            data: {
                deletion: $(link).parents('.creatorship').data('creatorshipUri')
            },
            dataType: 'json',
            context: link, // context for callback
            complete: function(request, status) {
                var creatorship,
                    creatorUri;
            
                if (status === 'success') {
                    
                    creatorship = $(this).parents('.creatorship');
                
                    // Clear autocomplete cache entries matching this creator's name, else
                    // autocomplete will be retrieved from the cache, which excludes the removed creator.
                    addCreatorForm.clearAcCacheEntries(creatorship.data('creatorName'));
                    
                    // Remove this creator from the acFilter so it is included in autocomplete
                    // results again.
                    addCreatorForm.removeCreatorFromAcFilter(creatorship.data('creatorUri'));
                    
                    creatorship.fadeOut(400, function() {
                        var numCreators;
 
                        // For undo link: add to a deletedCreatorships array
                        
                        // Remove from the DOM                       
                        $(this).remove();
                        
                        // Actions that depend on the creator having been removed from the DOM:
                        numCreators = $('.creatorship').length; // retrieve the length after removing creatorship from the DOM
                        
                        // If removed item not last, reorder to remove any gaps
                        if (numCreators > 0 && ! removeLast) {
                            addCreatorForm.reorderCreators();
                        }
                            
                        // If fewer than two creators remaining, disable drag-drop
                        if (numCreators < 2) {
                            addCreatorForm.disableCreatorDD();
                        }                           

                        if ( $('img#indicatorOne').is(':visible') ) {
                            $('img#indicatorOne').fadeOut(100, function() {
                                $(this).addClass('hidden');
                            });

                            addCreatorForm.returnLink.fadeIn(100, function() {
                                $(this).show();
                            });
                            addCreatorForm.showFormButton.removeClass('disabledSubmit');
                            addCreatorForm.showFormButton.attr('disabled','');
                        }
                        else {
                            $('img#indicatorTwo').fadeOut(100, function() {
                                 $(this).addClass('hidden');
                             });

                             addCreatorForm.cancel.fadeIn(100, function() {
                                 $(this).show();
                             });
                             addCreatorForm.submit.removeClass('disabledSubmit');
                             addCreatorForm.submit.attr('disabled','');
                        }
                    });

                } else {
                    alert(addCreatorForm.removeCreatorshipAlert);
                    
                }
            }
        });        
    },
    
    // Disable DD and associated cues if only one creator remains
    disableCreatorDD: function() {
        var creatorships = $('#creatorships'),
            creatorNameWrapper = $('.creatorNameWrapper');
            
        creatorships.sortable({ disable: true } );
        
        // Use class dd rather than jQuery UI's class ui-sortable, so that we can remove
        // the class if there's fewer than one creator. We don't want to remove the ui-sortable
        // class, in case we want to re-enable DD without a page reload (e.g., if implementing
        // adding an creator via Ajax request). 
        creatorships.removeClass('dd');
              
        creatorNameWrapper.removeAttr('title');
    },

    // RY To be implemented later.
    toggleRemoveLink: function() {
        // when clicking remove: remove the creator, and change link text to 'undo'
        // when clicking undo: add the creator back, and change link text to 'remove'
    },

	// Set the initial help text in the lastName field and change the class name.
	addAcHelpText: function(selectedObj) {
        var typeText;
        if ( $(selectedObj).attr('id') == "lastName" ) {
            typeText = addCreatorForm.creatorTypeText;
        }
        else {
            typeText = addCreatorForm.organizationTypeText;
        }
        
        if (!$(selectedObj).val()) {
			$(selectedObj).val(addCreatorForm.helpTextSelect + " " + typeText + " " + addCreatorForm.helpTextAdd)
						   .addClass(this.acHelpTextClass);
		}
	},
	
	deleteAcHelpText: function(selectedObj) {
	    if ($(selectedObj).hasClass(this.acHelpTextClass)) {
	            $(selectedObj).val('')
	                          .removeClass(this.acHelpTextClass);
	    }
	},

    // Depending on whether the creator is a person or an organization,
    // we need to set the correct class names for fields like the acSelector, acSelection, etc.
    // as well as clear and disable fields, call other functions ...
	setCreatorType: function(creatorType) {
	    if ( creatorType == "org" ) {
	        this.personSection.hide();
	        this.orgSection.show();
			this.orgNameWrapper.show();
	        // person fields
            this.personRadio.attr('checked', false);  // needed for reset when cancel button is clicked
	        this.acSelector.removeClass("acSelector");
	        this.acSelector.removeClass(this.acHelpTextClass);
	        this.selectedCreator.removeClass("acSelection");
	        this.selectedCreatorName.removeClass("acSelectionInfo");
	        this.personLink.removeClass("verifyMatch");
	        this.acSelector.attr('disabled', 'disabled');
	        this.firstNameField.attr('disabled', 'disabled');
	        this.middleNameField.attr('disabled', 'disabled');
	        this.lastNameField.attr('disabled', 'disabled');
	        this.acSelector.val('');
	        this.firstNameField.val('');
	        this.middleNameField.val('');
	        this.lastNameField.val('');
	        // org fields
	        this.orgRadio.attr('checked', true); // needed for reset when cancel button is clicked
	        this.orgName.addClass("acSelector");
	        this.selectedOrg.addClass("acSelection");
	        this.selectedOrgName.addClass("acSelectionInfo");
	        this.orgLink.addClass("verifyMatch");
	        this.orgName.attr('disabled', '');
	        this.orgUriField.attr('disabled', '');

	        addCreatorForm.addAcHelpText(this.orgName);
	        addCreatorForm.initAutocomplete();
	        addCreatorForm.hideSelectedPerson();
	    }
	    else if ( creatorType == "person" ) {
	        this.orgSection.hide();
	        this.personSection.show();
	        // org fields
	        this.orgRadio.attr('checked', false);  // needed for reset when cancel button is clicked
	        this.orgName.removeClass("acSelector");
	        this.orgName.removeClass(this.acHelpTextClass);
	        this.selectedOrg.removeClass("acSelection");
	        this.selectedOrgName.removeClass("acSelectionInfo");
	        this.orgLink.removeClass("verifyMatch");
	        this.orgName.attr('disabled', 'disabled');
	        this.orgUriField.attr('disabled', 'disabled');
	        this.orgName.val('');
	        this.orgUriField.val('');
            // person fields
            this.acSelector.addClass("acSelector");
            this.personRadio.attr('checked', true);  // needed for reset when cancel button is clicked
	        this.selectedCreator.addClass("acSelection");
	        this.selectedCreatorName.addClass("acSelectionInfo");
	        this.personLink.addClass("verifyMatch");
	        this.acSelector.attr('disabled', '');
	        this.firstNameField.attr('disabled', '');
	        this.middleNameField.attr('disabled', '');
	        this.lastNameField.attr('disabled', '');

	        addCreatorForm.addAcHelpText(this.acSelector);
	        addCreatorForm.initAutocomplete();
	        addCreatorForm.hideSelectedOrg();
	        
	    }
    }
};

$(document).ready(function() {   
    addCreatorForm.onLoad();
}); 
