/* global CLIENT_URL */
/* global USER_CHANNEL */

$(document).on('turbolinks:load', function() {
    var client = new Faye.Client(CLIENT_URL);

    client.subscribe(USER_CHANNEL, function(data) {
        $('#user-count').text(data['user_count']);
    });
});
