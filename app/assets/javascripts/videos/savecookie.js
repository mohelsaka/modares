function onYouTubePlayerReady(playerId) {
	ytplayer = document.getElementById("myytplayer");
	startCookie();
}
function setCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function deleteCookie(name) {
    setCookie(name,"",-1);
}

function startCookie(){
	setCookie("videoId", videoId ,365) ;
	setCookie("watchPercent", ytplayer.getCurrentTime()/ytplayer.getDuration() ,365) ;
	setTimeout(startCookie,3000);
}

