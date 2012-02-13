/**
 * Created by JetBrains RubyMine.
 * User: arijit
 * Date: 18/1/12
 * Time: 1:09 PM
 * To change this template use File | Settings | File Templates.
 */

$(function() {
    (function($) {
        $.fn.extend({
            oldAnimate: $.fn.animate,
            animate: function(props, speed, easing, callback) {
                var camelToHyphen = function(camel) {
                    return camel.replace(/([A-Z])/g, "-$1").toLowerCase();
                }, prefixes = [
                    "Moz", "Webkit",
                    "O", "Ms", "Khtml"
                ], transitionProp = false,
                    $this = $(this);
                callback = (typeof easing === "function") ? easing : (callback) ? callback : function() {
                };
                easing = (easing && typeof easing === "string") ? easing : "ease-in-out";
                for (var i = 0; i < prefixes.length; i++) {
                    if (prefixes[i] + "Transition" in $this.get(0).style) {
                        transitionProp = "-" + prefixes[i].toLowerCase() + "-transition";
                        break;
                    }
                }
                return $this.each(function() {
                    var $$this = $(this);
                    var transitionString;
                    if (transitionProp) {
                        var oldTransition = $$this.css(transitionProp);
                        transitionString = (oldTransition) ? oldTransition + ", " : "";
                        for (prop in props) {
                            transitionString += camelToHyphen(prop) + " " + speed + "ms " + easing + ", ";
                        }
                        transitionString = transitionString.replace(/\, $/, "");
                        $$this.css(transitionProp, transitionString).css(props);
                        setTimeout(function() {
                            $$this.css(transitionProp, oldTransition);
                            callback();
                        }, speed);
                    }
                    else {
                        $$this.oldAnimate(props, speed, callback);
                    }
                });
            }
        });
    })(jQuery);

    (function($) {
        $.fn.extend({
            danceSwitcher: function(options) {
                var defaults = {
                    speed: 1,
                    collapsedWidth: 230,
                    collapsedHeight: 80,
                    collapsedMPB: [10, 10, 10, 10],
                    collapsedLineHeight: '80px',
                    activeLineHeight: '48px',
                    animationSequence: 'prev/next'
                };
                options = $.extend(defaults, options);
                return $(this).each(function() {
                    var $this = $(this),
                        speed = options.speed,
                        first = $(this).children('div').eq(0), // the first child of the switcher, so that it is open by default
                        i;
                    $this.css('height', ($this.children('div').length - 1) * (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2]) + 'px'); // set the height of the switcher to the appropriate value
                    first.addClass('active'); // make the first box active
                    for (i = 1; i < $this.children('div').length; i++) { // position all of the boxes appropriately
                        $this.children('div').eq(i).css('top', (i - 1) * (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2]) + 'px');
                    }
                    if (options.animationSequence === 'prev/next') { // using the default animation
                        $this.children('div').click(function() { // bind aclick event to all the boxes
                            var $$this = $(this);
                            if (!$$this.hasClass('active') && !$this.hasClass('inprogress')) { // if the box clicked isn't already active and there isn't already animation going on
                                var next, prev;
                                $this.addClass('inprogress'); // make sure 2 animations don't happen at once
                                $this.children('.active').children('.content').animate({ // fade out the content of the active box
                                    opacity: 0
                                }, 750 / speed);
                                $this.children('.active').children('h3').animate({ // animate the active header line height
                                    lineHeight: options.collapsedLineHeight
                                }, 750 / speed);
                                if ($$this.next(':not(.active)').get(0)) { // if the clicked box isn't last
                                    next = $(this).next();
                                    prev = false;
                                }
                                else {
                                    next = $$this.prev();
                                    prev = true;
                                }
                                $$this.css({ // convert the height property of the clicked box to the bottom property
                                    bottom: $this.height() - $$this.position().top - (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2]),
                                    height: 'auto'
                                });
                                $this.children('.active').css('height', $this.children('.active').height()).animate({
                                    top: next.css('top'), // move the active box to the vertical position of its final destination
                                    height: options.collapsedHeight // make its height the height of a collapsed box
                                }, 750 / speed, function() {
                                    $$this.animate({ // move the clicked box out untill it's the same dimensions as the previously active box
                                        left: 0,
                                        right: (options.collapsedWidth + options.collapsedMPB[1] + options.collapsedMPB[3])
                                    }, 500 / speed, function() {
                                        next.animate({ // move the box next to the previously active box (to the right) to the place where the clicked box used to be
                                            top: $$this.css('top')
                                        }, 750 / speed, function() {
                                            $this.children('.active').animate({ // move the previously active box to where the last animated box just was
                                                left: next.position().left,
                                                right: 0
                                            }, 750 / speed, function() {
                                                $$this.children('h3').animate({ // animate the line height of the clicked box to the height of an active box
                                                    lineHeight: options.activeLineHeight
                                                }, 750 / speed);
                                                $$this.children('.content').animate({ // and make its content opaque
                                                    opacity: 1
                                                }, 750 / speed);
                                                $$this.animate({ // and give it the dimensions of an active box
                                                    top: 0,
                                                    bottom: 0
                                                }, 750 / speed, function() {
                                                    if (!prev) {
                                                        $this.children('.active').insertAfter(next); // if the "next" box was the box underneath the now active box, mave its position in the DOM to where it now is visually on the page
                                                    }
                                                    else if (prev) {
                                                        $this.children('.active').insertBefore(next); // same thing but if it was above the now active box
                                                    }
                                                    $this.children('.active').removeClass('active'); // remove the active class from the box that is no longer active
                                                    $$this.addClass('active'); // and add it to the now active box

                                                    $$this.prependTo($$this.parent()); // move the now active box to the top of the switcher DOM tree
                                                    $this.removeClass('inprogress'); // and set the switcher to not animating
                                                });
                                            });
                                        });
                                    });
                                });
                            }
                        });
                    }
                    else if (options.animationSequence === 'first/last') {
                        $this.children('div').click(function() {
                            var $$this = $(this), active = $this.children('.active'), last = !$$this.next().get(0), alreadyCalled = false,
                                callback = function() {
                                    console.log($this.width() - (options.collapsedWidth + options.collapsedMPB[1] + options.collapsedMPB[3]));
                                    active.css('bottom', 'auto').animate({
                                        right: 0,
                                        left: $this.width() - (options.collapsedWidth + options.collapsedMPB[1] + options.collapsedMPB[3])
                                    }, 750 / speed, function() {
                                        $$this.animate({
                                            top: 0,
                                            bottom: 0
                                        }, 750 / speed).children('h3').animate({
                                                lineHeight: options.activeLineHeight
                                            }, 750 / speed);
                                        $$this.children('.content').animate({
                                            opacity: 1
                                        }, 750 / speed, function() {
                                            if (!last) {
                                                active.appendTo($this).removeClass('active');
                                            }
                                            else {
                                                active.prependTo($this).removeClass('active');
                                            }
                                            $$this.prependTo($this).addClass('active');
                                            $this.removeClass('inprogress');
                                        });
                                    });
                                };
                            if (!$$this.hasClass('active') && !$this.hasClass('inprogress')) {
                                $this.addClass('inprogress');
                                active.children('h3').animate({
                                    lineHeight: options.collapsedLineHeight
                                }, 750 / speed);
                                active.children('.content').animate({
                                    opacity: 0
                                }, 750 / speed);
                                active.animate({
                                    top: (!last) ? $this.height() - options.collapsedHeight - options.collapsedMPB[0] - options.collapsedMPB[2] : 0,
                                    bottom: (!last) ? 0 : $this.height() - options.collapsedHeight - options.collapsedMPB[0] - options.collapsedMPB[2]
                                }, 750 / speed, function() {
                                    active.css({
                                        top: (!last) ? $this.height() - active.height() - options.collapsedMPB[0] - options.collapsedMPB[2] : 0,
                                        height: active.height()
                                    });
                                    $$this.css({
                                        bottom: $this.height() - $$this.position().top - (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2]),
                                        height: 'auto'
                                    });
                                    $$this.animate({
                                        left: 0,
                                        right: (options.collapsedWidth + options.collapsedMPB[1] + options.collapsedMPB[3])
                                    }, 500 / speed, function() {
                                        if (!last) {
                                            $$this.nextAll('div').each(function() {
                                                var $$$this = $(this);
                                                $$$this.animate({
                                                    top: $$$this.position().top - (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2])
                                                }, 750 / speed, function() {
                                                    if (!alreadyCalled) {
                                                        callback();
                                                    }
                                                    alreadyCalled = true;
                                                });
                                            });
                                        }
                                        else {
                                            $$this.prevAll('div:not(.active)').each(function() {
                                                var $$$this = $(this);
                                                $$$this.animate({
                                                    top: $$$this.position().top + (options.collapsedHeight + options.collapsedMPB[0] + options.collapsedMPB[2])
                                                }, 750 / speed, function() {
                                                    if (!alreadyCalled) {
                                                        callback();
                                                    }
                                                    alreadyCalled = true;
                                                });
                                            });
                                        }
                                    });
                                });
                            }
                        });
                    }
                });
            }
        });
    }(jQuery));
})
