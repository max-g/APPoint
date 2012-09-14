var app = app || {};

app.page = null;

app.configuration = {
    baseUrl: 'https://fbapps.my.phpcloud.com/appointments/',
    ogNamespace: 'appointments-app'
};

app.Index = function() {

    this.userIsAuthorized_ = false;

    this.mapDom_();
    this.init_();
    this.bindEvents_();
};

app.Index.prototype.init_ = function() {
    
    FB.init({
      appId      : '416854151706592', // App ID
      channelUrl : '//fbapps.my.phpcloud.com/appointments/channel.php', // Channel File
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });
};

app.Index.prototype.mapDom_ = function() {
    this.dom_ = {};

    this.dom_.ogActions = $('#og-actions');
    this.dom_.rate = $('#rate');
};

app.Index.prototype.bindEvents_ = function() {
    var self = this;

    this.dom_.rate.on('click', function() {
        var me = $(this),
            rating = $('#rating').val();
        
        self.executeIfAuthorized(function() {
            FB.api('/me/' + app.configuration.ogNamespace + ':rate', 
                'post',
                {
                    service: app.configuration.baseUrl + 'service.php?id=1',
                    rating: rating
                },
                function(data) {
                    console.log(arguments);
                });
            });
        });
};

app.Index.prototype.executeIfAuthorized = function(callback, askForLogin){
    var self = this;
    
    if(askForLogin === undefined)
        askForLogin = true;

    // if user already logged in
    if(self.userIsAuthorized_)
        callback();
    else {
        FB.getLoginStatus(function(response) {
            if (response.authResponse) {
                self.userIsAuthorized_ = true;
                callback();
            } else if (askForLogin) {
                FB.login(function(response) {
                    if (response.authResponse) {
                        self.userIsAuthorized_ = true;
                        callback();     
                    } else {
                        callback();
                    }
                }, { scope: 'publish_actions, friends_actions:' + app.configuration.ogNamespace + ', user_actions:' + app.configuration.ogNamespace });
            } else 
                callback();
        });
    }
};