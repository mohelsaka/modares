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
	
	// levels selection drop down list functionalities
	$("#levels-drop-down li a").click(function() {
		
		// updating the semester button text with the selected level name
		$("#drop-down-action").html($(this).html());
		
		// getting id of the semester
		var id = $(this).attr('semester_id');
		
		// hiding alll subjects
		$('#subjects li').addClass('hidden');
		
		// displaying only chosed subjects
		$('#subjects li[semester=' + id + ']').removeClass('hidden');
		$("#levels-drop-down").removeClass('open');

		// handling empty semesters
		if($('#subjects-drop-down li:not(.hidden)').size() == 0) {
			$('#subjects-drop-down #subjectName').html("Empty");
		} else {
			$('#subjects-drop-down #subjectName').html("Subjects");
			$('#subjects-drop-down').addClass('open');
		}
		return false;
	});
	
	// Fix input element click problem
	// problem: login pop up automatically being closed when clicked
	$('.dropdown input, .dropdown label').click(function(e) {
		e.stopPropagation();
	});

	// displaying loading flag on ajax request
	$("#videos-list").ajaxStart(function() {
		$(this).html("<img class='offset5' id='ajax-start' src='http://www.w3schools.com/jquery/demo_wait.gif' />");
	});
});
