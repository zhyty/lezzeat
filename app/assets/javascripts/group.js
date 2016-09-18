/* global CLIENT_URL */
/* global USER_CHANNEL */
/* global START_CHANNEL */
/* global END_CHANNEL */

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
    };

    var appRemoteEnd = function() {
        if (typeof END_CHANNEL === 'undefined' || !END_CHANNEL) return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(END_CHANNEL, function(data) {
            window.location.replace(data['dest']);
        });

        window.console.log("Listening to end channel");
    };

    var appRemoteStart = function() {
        if (typeof START_CHANNEL === 'undefined' || !START_CHANNEL) return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(START_CHANNEL, function(data) {
            window.location.replace(data['dest']);
        });

        window.console.log("Listening to start channel");
    };

    var updateUserCount = function() {
        if (typeof USER_CHANNEL === 'undefined' || !USER_CHANNEL) return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(USER_CHANNEL, function(data) {
            $('#user-count').text(data['user_count']);
        });

        window.console.log("Listening to user count channel");
    };

    $(document).on('turbolinks:load', function() {
        updateUserCount();
        appRemoteStart();
        appRemoteEnd();

        var $listForm = $('#list-form');
        var alertText = $('#alert').text();

        if (alertText.length) {
            Materialize.toast(alertText, 3000);
        }

        $listForm.on('submit', function(ev) {
            ev.preventDefault();

            var res = [];

            $('.restaurant-entry').each(function() {
                res.push($(this).data('id'));
            });

            $.post($listForm.attr('action'), {id: res}).fail(function() {
                window.alert("Couldn't send data to server :(. Please try again later");
            });
        });

        // load stars
        $('span.stars').stars();
    });
})();
