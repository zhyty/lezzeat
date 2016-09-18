/* global CLIENT_URL */
/* global USER_CHANNEL */

(function() {
    var updateUserCount = function() {
        if (typeof USER_CHANNEL === 'undefined') return;

        var client = new Faye.Client(CLIENT_URL);
        client.subscribe(USER_CHANNEL, function(data) {
            $('#user-count').text(data['user_count']);
        });
    };

    $(document).on('turbolinks:load', function() {
        updateUserCount();
    });
})();

