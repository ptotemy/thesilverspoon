/*
 * jQuery pageSlide
 * Version 2.0
 * http://srobbin.com/jquery-pageslide/
 *
 * jQuery Javascript plugin which slides a webpage over to reveal an additional interaction pane.
 *
 * Copyright (c) 2011 Scott Robbin (srobbin.com)
 * Dual licensed under the MIT and GPL licenses.
*/

;(function($){
    // Convenience vars for accessing elements
    var $body_ps = $('body'),
        $page_slide = $('#pageslide');
    
    var _sliding_ps = false,   // Mutex to assist closing only once
        _lastCaller_ps;        // Used to keep track of last element to trigger pageslide
    
	// If the pageslide element doesn't exist, create it
    if( $page_slide.length == 0 ) {
         $page_slide = $('<div />').attr( 'id', 'pageslide' )
                                  .css( 'display', 'none' )
                                  .appendTo( $('body') );
    }
    
    /*
     * Private methods 
     */
    function _load( url, useIframe ) {
        // Are we loading an element from the page or a URL?
        if ( url.indexOf("#") === 0 ) {                
            // Load a page element                
            $(url).clone(true).appendTo( $page_slide.empty() ).show();
        } else {
            // Load a URL. Into an iframe?
            if( useIframe ) {
                var iframe = $("<iframe />").attr({
                                                src: url,
                                                frameborder: 0,
                                                hspace: 0
                                            })
                                            .css({
                                                width: "100%",
                                                height: "100%"
                                            });
                
                $page_slide.html( iframe );
            } else {
                $page_slide.load( url );
            }
            
            $page_slide.data( 'localEl', false );
            
        }
    }
    
    // Function that controls opening of the pageslide
    function _start( direction, speed ) {
        var slideWidth = $page_slide.outerWidth( true ),
            bodyAnimateIn = {},
            slideAnimateIn = {};
        
        // If the slide is open or opening, just ignore the call
        if( $page_slide.is(':visible') || _sliding_ps ) return;	        
        _sliding_ps = true;
                                                                    
        switch( direction ) {
            case 'left':
                $page_slide.css({ left: 'auto', right: '-' + slideWidth + 'px' });
                bodyAnimateIn['margin-left'] = '-=' + slideWidth;
                slideAnimateIn['right'] = '+=' + slideWidth;
                break;
            default:
                $page_slide.css({ left: '-' + slideWidth + 'px', right: 'auto' });
                bodyAnimateIn['margin-left'] = '+=' + slideWidth;
                slideAnimateIn['left'] = '+=' + slideWidth;
                break;
        }
                    
        // Animate the slide, and attach this slide's settings to the element
        $body_ps.animate(bodyAnimateIn, speed);
        $page_slide.show()
                  .animate(slideAnimateIn, speed, function() {
                      _sliding_ps = false;
                  });
    }
      
    /*
     * Declaration 
     */
    $.fn.pageslide = function(options) {
        var $elements = this;
        
        // On click
        $elements.click( function(e) {
            var $self = $(this),
                settings = $.extend({ href: $self.attr('href') }, options);
            
            // Prevent the default behavior and stop propagation
            e.preventDefault();
            e.stopPropagation();
            
            if ( $page_slide.is(':visible') && $self[0] == _lastCaller_ps ) {
                // If we clicked the same element twice, toggle closed
                $.pageslide.close();
            } else {                 
                // Open
                $.pageslide( settings );

                // Record the last element to trigger pageslide
                _lastCaller_ps = $self[0];
            }       
        });                   
	};
	
	/*
     * Default settings 
     */
    $.fn.pageslide.defaults = {
        speed:      200,        // Accepts standard jQuery effects speeds (i.e. fast, normal or milliseconds)
        direction:  'right',    // Accepts 'left' or 'right'
        modal:      false,      // If set to true, you must explicitly close pageslide using $.pageslide.close();
        iframe:     true,       // By default, linked pages are loaded into an iframe. Set this to false if you don't want an iframe.
        href:       null        // Override the source of the content. Optional in most cases, but required when opening pageslide programmatically.
    };
	
	/*
     * Public methods 
     */
	
	// Open the pageslide
	$.pageslide = function(options) {
        // Extend the settings with those the user has provided
        var settings = $.extend({}, $.fn.pageslide.defaults, options);

        // Are we trying to open in different direction?
        if ($page_slide.is(':visible') && $page_slide.data('direction') != settings.direction) {
            $.pageslide.close(function() {
                _load(settings.href, settings.iframe);
                _start(settings.direction, settings.speed);
            });
        } else {
            _load(settings.href, settings.iframe);
            if ($page_slide.is(':hidden')) {
                _start(settings.direction, settings.speed);
            }
        }

        $page_slide.data(settings);
    };
	
	// Close the pageslide
	$.pageslide.close = function(callback) {
        var $page_slide = $('#pageslide'),
            slideWidth = $page_slide.outerWidth(true),
            speed = $page_slide.data('speed'),
            bodyAnimateIn = {},
            slideAnimateIn = {};

        // If the slide isn't open, just ignore the call
        if ($page_slide.is(':hidden') || _sliding_ps) return;
        _sliding_ps = true;

        switch ($page_slide.data('direction')) {
            case 'left':
                bodyAnimateIn['margin-left'] = '+=' + slideWidth;
                slideAnimateIn['right'] = '-=' + slideWidth;
                break;
            default:
                bodyAnimateIn['margin-left'] = '-=' + slideWidth;
                slideAnimateIn['left'] = '-=' + slideWidth;
                break;
        }

        $page_slide.animate(slideAnimateIn, speed);
        $body_ps.animate(bodyAnimateIn, speed, function() {
            $page_slide.hide();
            _sliding_ps = false;
            if (typeof callback != 'undefined') callback();
        });
    };
	
	/* Events */
	
	// Don't let clicks to the pageslide close the window
    $page_slide.click(function(e) {
        e.stopPropagation();
    });

	// Close the pageslide if the document is clicked or the users presses the ESC key, unless the pageslide is modal
	$(document).bind('click keyup', function(e) {
	    // If this is a keyup event, let's see if it's an ESC key
        if( e.type == "keyup" && e.keyCode != 27) return;
	    
	    // Make sure it's visible, and we're not modal	    
	    if( $page_slide.is( ':visible' ) && !$page_slide.data( 'modal' ) ) {	        
	        $.pageslide.close();
	    }
	});
	
})(jQuery);
