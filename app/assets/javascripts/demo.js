$(document).ready(function() {

    // source code syntac highlighter
    SyntaxHighlighter.all();

});

var closeModalWindow = function() {
    window.location.hash = 'close';
};
var openModalWindow = function() {
    window.location.hash = 'modal-window';
};
var openSuccessModalWindow = function() {
    window.location.hash = 'modal-window-success';
};
var openWarningModalWindow = function() {
    window.location.hash = 'modal-window-warning';
};
var openErrorModalWindow = function() {
    window.location.hash = 'modal-window-error';
};
var openModalFilter = function() {
    window.location.hash = 'modal-filter';
};
var openModalDocument = function() {
    window.location.hash = 'modal-document';
};
var openAlertBox = function(alertId) {
    var counter = 3;
    jQuery(alertId).css({
        opacity: 0.0,
        visibility: 'visible'
    }).animate({
        opacity: 1.0
    }, 200);
    var interval = setInterval(function() {
        counter--;
        if (counter === -1) {
            clearInterval(interval);
            jQuery(alertId).css({
                opacity: 1.0,
                visibility: 'hidden'
            }).animate({
                opacity: 0.0
            }, 200);
        }
    }, 1000);
};
var openModalLoading = function(message) {
    var counter = 3;
    // jQuery('#loading-seconds').html(counter + 's');
    jQuery('#loading-message').html(message);
    window.location.hash = 'modal-loading';

    var interval = setInterval(function() {
        counter--;
        // jQuery('#loading-seconds').html(counter + 's');
        if (counter === -1) {
            clearInterval(interval);
            window.location.hash = 'close';
        }
    }, 1000);
};
