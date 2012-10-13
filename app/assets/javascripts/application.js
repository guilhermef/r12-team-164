// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


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
            window.location = document.location.origin + '/users/auth/facebook';
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