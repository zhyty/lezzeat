/* global CLIENT_URL */
/* global USER_CHANNEL */
/* global START_CHANNEL */
/* global SUBMITTED_CHANNEL */

(function() {
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

    function change_ui(ui_shown) {
        ui_shown = ui_shown || 'wait';
        if (ui_shown === 'wait') {
            $('#waiting-ui')[0].style="display:block;";
            $('#selection-ui')[0].style="display:none;";
        } else {
            $('#waiting-ui')[0].style="display:none;";
            $('#selection-ui')[0].style="display:block;";
        }
    }

    var appRemoteStart = function() {
        if (typeof START_CHANNEL === 'undefined') return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(START_CHANNEL, function(data) {
            window.location.replace(data['dest']);
        });

        window.console.log("Listening to start channel");
    };

    var updateUserCount = function() {
        if (typeof USER_CHANNEL === 'undefined') return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(USER_CHANNEL, function(data) {
            $('#user-count').text(data['user_count']);
        });

        window.console.log("Listening to user count channel");
    };

    var updateSubmittedCount = function() {
        if (typeof SUBMITTED_CHANNEL === 'undefined') return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(SUBMITTED_CHANNEL, function(data) {
            $('#submitted-count').text(data['submitted_count']);
            window.console.log("Got " + data);
        });

        window.console.log("Listening to submitted count channel");
    };

    $(document).on('turbolinks:load', function() {
        updateUserCount();
        updateSubmittedCount();
        appRemoteStart();

        var alertText = $('#alert').text();
        if (alertText.length) {
            Materialize.toast(alertText, 3000);
        }

        // load stars
        $('span.stars').stars();
    });
})();
