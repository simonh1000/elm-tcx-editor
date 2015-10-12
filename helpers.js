// var map = Elm.fullscreen(Elm.Main);


var insertedNodes = [];
var observer = new MutationObserver(function(mutations) {
 mutations.forEach(function(mutation) {
   for (var i = 0; i < mutation.addedNodes.length; i++)
     insertedNodes.push(mutation.addedNodes[i]);
 })
 console.log(insertedNodes);
});
observer.observe(document, { childList: true });

map.ports.gmap.subscribe(function(load) {
    console.log(load);

    setTimeout( function() {
        var mapDiv = mapDiv || document.getElementById('map');

        if (mapDiv) {
            var myLatlng = new google.maps.LatLng(43, 4.5);
            var mapOptions = {
              zoom: 6,
              center: myLatlng
            };
            var gmap = new google.maps.Map(mapDiv, mapOptions);
        }

        if (load.length) {
            load.forEach(function(pos) {
                var markerPos = new google.maps.LatLng(pos.lat, pos.lng);
                var m = new google.maps.Marker({
                    position: markerPos,
                    map: gmap
                });
            });
        }
    }, 50)
});
