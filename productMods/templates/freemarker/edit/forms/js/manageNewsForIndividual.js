/* $This file is distributed under the terms of the license in /doc/license.txt$ */

var manageNewsLinks = {

    /* *** Initial page setup *** */
   
    onLoad: function() {
    
        this.mixIn();               
        this.initPage();       
    },

    mixIn: function() {
        
        // Get the custom form data from the page
        $.extend(this, customFormData);
        $.extend(this, i18nStrings);
    },
    
    // Initial page setup. Called only at page load.
    initPage: function() {

        this.initNewsLinkData();
       
        this.bindEventListeners();
               
        this.initDragAndDrop();
        
        if ($('.newsLink').length) {  // make sure we have at least one newsLink
            // Reorder news links on page load so that previously unranked items get a rank. Otherwise,
            // when we add a new news link, it will get put ahead of any previously unranked news links, instead
            // of at the end of the list. (It is also helpful to normalize the data before we get started.)            
            this.reorder();
        }     
    },

    // On page load, associate data with each list item. Then we don't
    // have to keep retrieving data from or modifying the DOM as we manipulate the
    // items.
    initNewsLinkData: function() {
        $('.newsLink').each(function(index) {
            $(this).data(newsLinkData[index]);    
            
            // RY We might still need position to put back an element after reordering
            // failure. Rank might already have been reset? Check.
            $(this).data('position', index+1);      
        });
    },
    
    bindEventListeners: function() {

        $('.remove').click(function() {
            manageNewsLinks.removeNewsLink(this);
            return false;
        });
               
    },
    
    /* *** Ajax initializations *** */

    /* Drag-and-drop */
    initDragAndDrop: function() {
        
        var newsLinks = $('#newsLinkList');
        
        // No DD if < 2 items
        if (newsLinks.children('li') < 2) {
            return;
        }
        
        $('.newsLinkName').each(function() {
            $(this).attr('title', manageNewsLinks.dragDropToReorderNewsLinks);
        });
        
        newsLinks.sortable({
            cursor: 'move',
            update: function(event, ui) {
                manageNewsLinks.reorder(event, ui);
            }
        });     
    },
    
    // Reorder news links. Called on page load and after drag-and-drop and remove.
    // Event and ui parameters are defined only in the case of drag-and-drop.
    reorder: function(event, ui) {
        var newsLinks = $('li.newsLink').map(function(index, el) {
            return $(this).data('newsLinkUri');
        }).get();

        $.ajax({
            url: manageNewsLinks.reorderUrl,
            data: {
                predicate: manageNewsLinks.rankPredicate,
                individuals: newsLinks
            },
            
            traditional: true, // serialize the array of individuals for the server
            dataType: 'json',
            type: 'POST',
            success: function(data, status, request) {
                var pos;
                $('.newsLinks').each(function(index){
                    pos = index + 1;
                    // Set the new position for this element. The only function of this value 
                    // is so we can reset an element to its original position in case reordering fails.
                    manageNewsLinks.setPosition(this, pos);                
                }); 
            },
            error: function(request, status, error) {
                // ui is undefined on page load and after a newsLink removal.
                if (ui) {
                    // Put the moved item back to its original position.
                    // Seems we need to do this by hand. Can't see any way to do it with jQuery UI. ??
                    var pos = manageNewsLinks.getPosition(ui.item),                       
                        nextpos = pos + 1, 
                        newsLinks = $('#newsLinkList'), 
                        next = manageNewsLinks.findNewsLink('position', nextpos);
                    
                    if (next.length) {
                        ui.item.insertBefore(next);
                    }
                    else {
                        ui.item.appendTo(newsLinks);
                    }
                    
                    alert(manageNewsLinks.newsLinkReorderingFailed);                                 
                }      
            }
        });           
    },
    
    getPosition: function(newsLink) {
        return $(newsLink).data('position');
    },
    
    setPosition: function(newsLink, pos) {
        $(newsLink).data('position', pos);
    },
    
    findNewsLink: function(key, value) {
        var matchingNewsLink = $(); // if we don't find one, return an empty jQuery set
        
        $('.newsLink').each(function() {
            var newsLink = $(this);
            if ( newsLink.data(key) === value ) {
                matchingNewsLink = newsLink; 
                return false; // stop the loop
            }
        });
         
        return matchingNewsLink;       
    },
                  
    removeNewsLink: function(link) {
        // RY Upgrade this to a modal window
        var removeLast = false,
            message = manageNewsLinks.confirmNewsLinkDeletion;
            
        if (!confirm(message)) {
            return false;
        }

        $('a#returnToIndividual').hide();
        $('img#indicator').removeClass('hidden');
        $('a#showAddForm').addClass('disabledSubmit');
        $('a#showAddForm').attr('disabled', 'disabled');
        
        if ($(link)[0] === $('.remove:last')[0]) {
            removeLast = true;
        } 
        
        $.ajax({
            url: $(link).attr('href'),
            type: 'POST', 
            data: {
                deletion: $(link).parents('.newsLink').data('newsLinkUri')
            },
            dataType: 'json',
            context: link, // context for callback
            complete: function(request, status) {
                var newsLink;
            
                if (status === 'success') {
                    
                    newsLink = $(this).parents('.newsLink');
                    
                    newsLink.fadeOut(400, function() {
                        var numNewsLinks;
                        
                        // Remove from the DOM                       
                        $(this).remove();

                        // Actions that depend on the news link having been removed from the DOM:
                        numNewsLinks = $('.newsLink').length; // retrieve the new length after removing news link from the DOM
                        
                        // If removed item not last, reorder to remove any gaps
                        if (numNewsLinks > 0 && ! removeLast) {                            
                            manageNewsLinks.reorder();
                        }
                            
                        // If fewer than two news links remaining, disable drag-drop
                        if (numNewsLinks < 2) {
                            manageNewsLinks.disableDD();
                        }                           
                        $('img#indicator').fadeOut(100, function() {
                            $(this).addClass('hidden');
                        });

                        $('a#returnToIndividual').fadeIn(100, function() {
                            $(this).show();
                        });
                        $('a#showAddForm').removeClass('disabledSubmit');
                        $('a#showAddForm').attr('disabled', '');
                    });

                } else {
                    alert(manageNewsLinks.errorRemovingNewsLink);
                }
            }
        });        
    },
    
    // Disable DD and associated cues if only one item remains
    disableDD: function() {
        var newsLinks = $('#newsLinkList');
        
        $('#newsLinkList').sortable({ disable: true } )
                         /* Use class dd rather than jQuery UI's class ui-sortable, so that we can remove
                          * the class if there's fewer than one news link. We don't want to remove the ui-sortable
                          * class, in case we want to re-enable DD without a page reload (e.g., if implementing
                          * adding a news link via Ajax request). 
                          */
                         .removeClass('dd');
              
        $('.newsLinkName').removeAttr('title');
    }

};

$(document).ready(function() {   
    manageNewsLinks.onLoad();
}); 
