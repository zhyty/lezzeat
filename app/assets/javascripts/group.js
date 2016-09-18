$(document).on('turbolinks:load', function() {
    var alertText = $('#alert').text();
    if (alertText.length) {
        Materialize.toast(alertText, 3000);
    }
});