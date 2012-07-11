// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require_tree .

//= require twitter/bootstrap
//= require bootstrap-datepicker

//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es
//= require bootstrap-datepicker/locales/bootstrap-datepicker.fr
$(document).ready(function() {
	$("#levels-drop-down li a").click(function() {
		$("#drop-down-action").html($(this).html());
		var id = $(this).attr('semester_id');
		$('#subjects li').addClass('hidden');
		$('#subjects li[semester=' + id + ']').removeClass('hidden');
		$("#levels-drop-down").removeClass('open');

		if($('#subjects-drop-down li:not(.hidden)').size() == 0) {
			$('#subjects-drop-down #subjectName').html("Empty");
		} else {
			$('#subjects-drop-down #subjectName').html("Subjects");
			$('#subjects-drop-down').addClass('open');
		}
		return false;
	});
	$('.dropdown-toggle').dropdown();

	// Fix input element click problem
	$('.dropdown input, .dropdown label').click(function(e) {
		e.stopPropagation();
	});

	/*
	$('.wrapper').hover(function() {
		$(this).find('img').animate({
			opacity : ".6"
		}, 300);
		$(this).find('.caption').removeClass('hidden');
		$(this).find('.caption').animate({
			top : "-145px"
		}, 300);
	}, function() {
		$(this).find('img').animate({
			opacity : "1.0"
		}, 300);
		$(this).find('.caption').animate({
			top : "0px"
		}, 100);
		$(this).find('.caption').addClass('hidden');
	});
	*/
	$("#videos-list").ajaxStart(function() {
		$(this).html("<img class='offset5' id='ajax-start' src='http://www.w3schools.com/jquery/demo_wait.gif' />");
	});
});
