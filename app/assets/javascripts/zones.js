// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function cargarUbicacionZona() {
	var latitud = $('#zone_latitud').val();
	var longitud = $('#zone_longitud').val();

	if (!latitud || !longitud) {
		latitud = -34.6425867
		longitud = -58.5659176;
	}

	var mapaUbicacion = new MapaUbicacion(latitud, longitud, '#zone_latitud', '#zone_longitud', 'googleMapZona');

  $('#new_zone_modal').ready(function() {
    $('#new_zone_modal').on('shown.bs.modal',function() {
      google.maps.event.trigger(mapaUbicacion.map, 'resize');
      mapaUbicacion.map.center(new google.maps.LatLng(mapaUbicacion.map.latitud, mapaUbicacion.map.longitud));
    });
  });
};

$(document).ready(function(){

  $(document).bind('ajaxError', 'form#new_zone', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

});

(function($) {

  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');

    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="text"]').val('');

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.render_form_errors = function(errors){

    $form = this;
    this.clear_previous_errors();
    model = this.data('model');

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    });

  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }

}(jQuery));