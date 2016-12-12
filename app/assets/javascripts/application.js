// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
    // add top padding value to content by subheader height
    $('.content').css({'padding-top': ($('.header').height() + $('.subheader').height()) + 'px'});

    // add top position to anchor
    $('.anchor').css({'top': '-' + ($('.header').height() + $('.subheader').height() + 15) + 'px'});

    // menu hiding and showing
    $('.menu').mouseenter(function() {
        $(this).stop(true).animate({left: '0px'}, 250);
    }).mouseleave(function() {
        $(this).stop(true).animate({left: '-230px'}, 250);
    });

    // second and third level of menu
    $('.menu .wrapper-scrollable > ul > li > a').click(function() {
        $(this).parent().toggleClass('active');
    });
    $('.menu .wrapper-scrollable > ul > li > ul > li > a').click(function() {
        $(this).parent().toggleClass('active');
    });

    // re-style select box
    $('select').selectBoxIt();

    // tabs
    $('.panel-tabs .tabs').each(function() {
        // For each set of tabs, we want to keep track of
        // which tab is active and its associated content
        var $active, $content, $links = $(this).find('a');

        // If the location.hash matches one of the links, use that as the active tab.
        // If no match is found, use the first link as the initial active tab.
        $active = $($links.filter('[href="' + location.hash + '"]')[0] || $links[0]);
        $active.parent().addClass('active');

        $content = $($active[0].hash);

        // Hide the remaining content
        $links.not($active).each(function() {
            $(this.hash).hide();
        });

        // Bind the click event handler
        $(this).on('click', 'a', function(e) {
            // Make the old tab inactive.
            $active.parent().removeClass('active');
            $content.hide();

            // Update the variables with the new link and content
            $active = $(this);
            $content = $(this.hash);

            // Make the tab active.
            $active.parent().addClass('active');
            $content.show();

        });
    });

    // button dropdown
    $('.group-submenu-button').not('code .group-submenu-button').dropit();

    // accordion normal panel
    $('.accordion-toggle').click(function() {
        //Expand or collapse this panel
        $(this).next().slideToggle('fast');
        $(this).parent().toggleClass('is-open');

        $(this).find('span').toggleClass('fa-chevron-up');
        $(this).find('span').toggleClass('fa-chevron-down');

        //Hide the other panels
        //$('.accordion-content').not($(this).next()).slideUp('fast');
        //$('.accordion-toggle').not($(this)).find('span').addClass('fa-chevron-down');
        //$('.accordion-toggle').not($(this)).find('span').removeClass('fa-chevron-up');
    });

    var message, type;
    var $flash = $('.flash .flash__container');
    // General settings
    alertify.set('notifier','position', 'bottom-left');
    alertify.set('notifier','delay', 10);

    if($flash.length > 0) {
        $flash.each(function() {
            message = $(this).find('.flash__message').html();

            if($(this).hasClass('flash__notice')) {
                type = 'warning';
            } else if ($(this).hasClass('flash__alert')) {
                type = 'error';
            } else {
                type = 'success';
            }
            alertify.notify(message, type, 15);
        });
    }

    // Nav links
    $('.loan-nav-link').removeClass('finished');
    $('.loan-nav-link.current').parent().prevAll().each(function() {
        $(this).find('.loan-nav-link').addClass('finished');
    });

    function numberWithSpaces(x) {
        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
    }

    $('.format-num').each(function() {
        var currVal = $(this).text();
        var newVal;
        newVal = numberWithSpaces(currVal);
        $(this).text(newVal);
    });

    // Add company
    var open = false;
    $(document).on('click', '#addCompanyTrigger', function(e) {
        $('#addCompanyForm').slideToggle();

        if(open === false) {
            $(this).html('Zavrit');
            open = true;
        } else {
            $(this).html('Pridať spoločnosť');
            open = false;
        }
    });
});

$(document).on('keyup', '#limit-cal', function(){
  var limit = parseInt(this.value);
  $('#inst-with-security').val(limit === 0 ? 200000 : 200000 - (limit * 3));
  $('#inst-without-security').val(limit === 0 ? 135000 : 135000 - (limit * 3));
  $('#overdraft').val(limit === 0 ? 100000 : 100000 - (limit * 3));
  $('#pre-approved').val(limit === 0 ? 100000 : 100000 - (limit * 3));
  $('#credit-card').val(limit === 0 ? 100000 : 100000 - (limit * 3));
  $('#prolongation-overdraft').val(limit === 0 ? 100000 : 100000 - (limit * 3));
});
