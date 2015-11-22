// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree
//= require filterrific/filterrific-jquery

function MapaUbicacion(latitud, longitud, selectorLat, selectorLng, idMapa, mapDisabled) {

	var latitud;
	var longitud;
	var map;
	var mapProp;
	var selectorLat;
	var selectorLng;
	var marker;
	//var infowindow;

	this.latitud = latitud;
	this.longitud = longitud;
	this.selectorLat = selectorLat;
	this.selectorLng = selectorLng;
	$(this.selectorLat).val(this.latitud);
	$(this.selectorLng).val(this.longitud);

 	this.mapProp = {
		center: new google.maps.LatLng(this.latitud, this.longitud),
		zoom:15,
		mapTypeId: google.maps.MapTypeId.ROADMAP
  	};
	this.map = new google.maps.Map(document.getElementById(idMapa), this.mapProp);
	this.refreshMarker();
	var self = this;
	if (!mapDisabled || typeof mapDisabled === 'undefined') {
		this.map.addListener('click', function(event) {
			$(self.selectorLat).val(event.latLng.lat());
			$(self.selectorLng).val(event.latLng.lng());
			self.latitud = event.latLng.lat();
			self.longitud = event.latLng.lng();
			self.refreshMarker();
		});
	}
}

MapaUbicacion.prototype.refreshMarker = function() {
	if (this.marker) {
		this.marker.setMap(null);
	}
	var latlng = new google.maps.LatLng(this.latitud, this.longitud);
	this.marker = new google.maps.Marker({
		position: latlng,
		map: this.map
	});
}

function loadMapaScript(calllback) {
  var script = document.createElement("script");
  script.src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyDtDVYB3gnF3bj6nMqzma3IHMNUvYe_rdY&callback=" + calllback;
  document.body.appendChild(script);
}


// $(function() {
//   $('.datepicker').datepicker({
//   	changeYear: true,
//   	yearRange: "-100:+2",
// 	format: 'dd-mm-yyyy'  	
//   });
// });