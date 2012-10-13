window.fbAsyncInit = function() {
    FB.init({
        appId: "411973878869082",
        channelUrl: document.location.origin + "/channel.html",
        status: true,
        cookie: true,
        xfbml: true
    });

    FB.Event.subscribe('auth.login', function(response) {
        window.location = window.location;
    });

    FB.getLoginStatus(function(response) {
        var isAuthenticated = $('#fb-server-authenticated').length > 0;
        if (!isAuthenticated && response.status === 'connected') {
            window.location = 'http://' + document.location.host + '/users/auth/facebook';
        }
    });
};

(function(d, s, id) {
var js, fjs = d.getElementsByTagName(s)[0];
if (d.getElementById(id)) return;
js = d.createElement(s); js.id = id;
js.src = "//connect.facebook.net/en_US/all.js";
fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));