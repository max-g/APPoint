var _g = _g || {};
var K7 = K7 || {};

K7.Facebook = K7.Facebook || {};

K7.Destination = function(opts){
	this.opts = $.extend({}, K7.Destination.Options, opts);

	this.userLogged = false;
	this.reviewTimer = 0;
	this.reviewIDs = {};
	this.friends = undefined;

	this._mapDOM();
	this._bindEvents();
	this._init();
};

K7.Destination.Options = {
	appID: 0,
	ogns: '',
	location: ''
};

K7.Destination.prototype._init = function() {
	
	// init facebook lib
	FB.init({
		appId: this.opts.appID, 
		cookie: true,
		status: true, 
		xfbml: true, 
		oauth: true
	});
	
	this.loadFriendsReviews(false);
};

K7.Destination.prototype._mapDOM = function() {
	this.dom = {};
	
	this.dom.ogcta = $('#og_cta');
	this.dom.dreamBt = this.dom.ogcta.find('.dream');
	this.dom.bookBt = this.dom.ogcta.find('.book');
	this.dom.goBt = this.dom.ogcta.find('.go');
	this.dom.shareBt = this.dom.ogcta.find('.share');
	this.dom.friendBt = $('#friends');
	this.dom.reviews = $('#reviews');
	this.dom.reviewsContainer = $('#reviews-container');
	this.dom.refreshReviewsBt = $('#reviews-refresh');
	// this.dom.inviteFriendsBt = $('#apprequest')
};

K7.Destination.prototype._bindEvents = function() {
	var self = this;
	
	// this.dom.inviteFriendsBt.on('click', function(){
	// 	self.executeIfAuthorized(function(){
	// 		FB.ui({method: 'apprequests',
	//           message: 'My Great Request'
	//         }, function(r){
	//         	console.log(r);
	// 	    });
	// 	});
	// });

	this.dom.friendBt.on('click', function(){
		self.loadFriendsReviews(true);
	});

	this.dom.refreshReviewsBt.on('click', function(){
		self.loadFriendsReviews(false);
	});

	this.dom.dreamBt.on('click', function() {
		var me = $(this);
		self.executeIfAuthorized(function(){
			FB.api('/me/' + self.opts.ogns + ':dream_about?destination=' + self.opts.location, 'post', function(response) {
				if (!response || response.error) {
					alert('Error');
				} else {
					// alert('Action posted on Facebook!');
					me.addClass('success');		
				}
			});	
		});

	});

	this.dom.bookBt.on('click', function() {
		var me = $(this);
		self.executeIfAuthorized(function(){
			FB.api('/me/'+self.opts.ogns+':book?destination=' + self.opts.location, 'post', function(response) {
				if (!response || response.error) {
					alert('Error');
				} else {
					// alert('Action posted on Facebook!');
					me.addClass('success');		
				}
			});
		});

	});

	this.dom.goBt.on('click',function() {
		var me = $(this);
		self.executeIfAuthorized(function(){
			FB.api('/me/'+self.opts.ogns+':visit?destination=' + self.opts.location, 'post', function(response) {
				if (!response || response.error) {
					alert('Error');
				} else {
					// alert('Action posted on Facebook!');
					me.addClass('success');						
				}
			});	
		});	

	});

	this.dom.shareBt.on('click', function() {
		var me = $(this);
		self.executeIfAuthorized(function(){
			var msg = prompt("Share your experience");
			// var rating = Math.random() * 6;

			if (msg && msg.toString().length > 0)
				FB.api('/me/'+self.opts.ogns+':review'+ 
							'?message=' + msg.toString().substr(0, 200) + 
							'&destination=' + self.opts.location,
							// '&rating=' + (Math.round(rating) != Math.floor(rating) ? Math.round(rating) + 0.5 : Math.round(rating)), 
						'post', 
					function(response) {
						if (!response || response.error) {
							alert('Error');
						} else {
							// alert('Action posted on Facebook!');
					me.addClass('success');		
						}
				});
		});

	});
};

K7.Destination.prototype.executeIfAuthorized = function(callback, askForLogin){
	var self = this;
	
	if(askForLogin === undefined)
		askForLogin = true;

	// if user already logged in
	if(self.userLogged)
		callback();
	else {
		FB.getLoginStatus(function(response) {
			if (response.authResponse) {
				self.userLogged = true;
				callback();
			} else if(askForLogin) {
				FB.login(function(response) {
					if (response.authResponse){
						self.userLogged = true;
						callback();		
					} else {
						callback();
					}
				}, { scope: 'publish_actions, friends_actions:og_tssocialoffers, user_actions:og_tssocialoffers' });
			} else 
				callback();
		});
	}
};

K7.Destination.prototype.stopReviewsRefresh = function() {
	clearTimeout(this.reviewTimer);
};

K7.Destination.prototype.loadFriendsReviews = function(askForLogin) {
	
	var self = this;
	
	self.dom.reviewsContainer.addClass('loading');
	
	self.executeIfAuthorized(function(){
		if(!self.userLogged){
			self.dom.reviewsContainer.removeClass('loading');
			self.dom.reviews.removeClass('success empty');
		} else {
			self._loadFriendsReviews(function(){
				self.dom.reviewsContainer.removeClass('loading');
				self.dom.reviews.toggleClass('empty', !self.dom.reviews.children('.review').length);
			});
			
			self.reviewTimer = setTimeout(function(){
				self.loadFriendsReviews(false);
			}, 5000);
		}
	}, askForLogin);
};

K7.Destination.prototype._loadFriendsReviews = function(callback) {
	var self = this,
		city = document.location.pathname.substring(1);
	
	var loadReviews = function(friends, callback){
		
		if(!friends.length && typeof callback == 'function'){
			callback();
			return;
		}
		
		// Building batch requests
		// Gets all reviews by all my friends who installed the app
		var batchRequests = [];
		for(var i = 0; i < friends.length && i < 50; i++){
			batchRequests.push({
				"method": "GET",
				"relative_url": "/" + friends[i].uid + "/og_tssocialoffers:review/"
			});
		}

		FB.api('/', 'POST', { "batch": batchRequests}, function(r){
			for (var i = 0; i < r.length; i++) {
				var response = $.parseJSON(r[i].body);
				if(response.data){
					for (var j = response.data.length - 1; j >= 0; j--) {
						var review = response.data[j];
						var uid = review.from.id;
						if(city == review.data.destination.title && !self.reviewIDs[review.id]){
							self.reviewIDs[review.id] = true;
							self.dom.reviews.removeClass('empty').addClass('success').prepend(
								'<li class="review">\
									<img src="https://graph.facebook.com/' + uid + '/picture?type=square" />\
									<a target="_blank" href="https://www.facebook.com/' + uid + '">' + review.from.name + '</a> reviewed \
									<a target="_blank" href="' + review.data.destination.url + '">' + review.data.destination.title + '</a> \
									<p>' + review.message + '</p>\
								</li>'
							);
						}
					}
				}
			}
			callback();
		});
	};
	
	if(self.friends == undefined){
		FB.Data.query('SELECT uid FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1 = me()) AND is_app_user = 1')
		.wait(function(rows) {
			self.friends = rows;
			loadReviews(self.friends, callback);
		});	
	} else {
		loadReviews(self.friends, callback);
	}
};
