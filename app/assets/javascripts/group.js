$(document).on('turbolinks:load', function() {
    // toast anything in the alert div
    var alertText = $('#alert').text();
    if (alertText.length) {
        Materialize.toast(alertText, 3000);
    }
    // load stars
    $(function() {
        $('span.stars').stars();
    });
});
$.fn.stars = function() {
    return $(this).each(function() {
        // Get the value
        var val = parseFloat($(this).html());
        // Make sure that the value is in 0 - 5 range, multiply to get width
        var size = Math.max(0, (Math.min(5, val))) * 16;
        // Create stars holder
        var $span = $('<span />').width(size);
        // Replace the numerical value with stars
        $(this).html($span);
    });
}

function find_remaining_restaurants() {
    var elements = $.map($('.restaurant-id'), function (e) { return e.innerHTML; });
    return elements;
}

function change_ui(ui_shown = 'wait') {
    if (ui_shown === 'wait') {
        $('#waiting-ui')[0].style="display:block;";
        $('#selection-ui')[0].style="display:none;";
    } else {
        $('#waiting-ui')[0].style="display:none;";
        $('#selection-ui')[0].style="display:block;";
    }
}