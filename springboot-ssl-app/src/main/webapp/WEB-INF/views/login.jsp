<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<fb:login-button scope="public_profile,email" onlogin="checkLoginState();"></fb:login-button>
<button onclick="logout()">로그아웃</button>
<div id="status"></div>

<script async defer crossorigin="anonymous" src="https://connect.facebook.net/en_US/sdk.js"></script>
<script>
	window.fbAsyncInit = function() {
		FB.init({
			appId : '{페이스북 앱 아이디}',
			cookie : true,
			xfbml : true,
			version : 'v14.0'
		});
     	FB.AppEvents.logPageView();   
     };

	function checkLoginState() {
   		FB.getLoginStatus(function(response) {
     		statusChangeCallback(response);
		});
	}
 
	function logout() {
   		FB.logout(function(response) {
	   		location.href = "/";
		});
  	}
 
	function statusChangeCallback(response) {  // Called with the results from FB.getLoginStatus().
   		console.log('statusChangeCallback');
		console.log(response);                   // The current login status of the person.
		if (response.status === 'connected') {   // Logged into your webpage and Facebook.
			FB.api('/me', function(response) {
				console.log('Successful login for: ' + response.name);
				document.getElementById('status').innerHTML =  'Thanks for logging in, ' + response.name + '!';
			});
  		} else {                                 // Not logged into your webpage or we are unable to tell.
			document.getElementById('status').innerHTML = 'Please log ' + 'into this webpage.';
		}
	}
</script>
</body>
</html>
