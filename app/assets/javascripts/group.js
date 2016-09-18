/* global CLIENT_URL */
/* global USER_CHANNEL */
/* global START_CHANNEL */

(function() {
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

    $(document).on('turbolinks:load', function() {
        updateUserCount();
        appRemoteStart();
    });
})();

