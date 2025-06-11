(function ($) {

	"use strict";

	/*
	======================================
		Element Animation
	======================================
	*/
	(function() {
		$("[data-paroller-factor]").paroller();
	})();



	/*
	======================================
		Echo User Click
	======================================
	*/
	(function() {
		$('.feature-btn').on('click', function() {
			$(this).parent().children('.feature-wrapper').children('.thecho-ovh').children().toggleClass('open');
		});
	})();


	/*
	======================================
		Slinky Menu INIT
	======================================
	*/
	(function() {
		const slinky = $('.thecho-mobile-menu').slinky();
	})();


	/*
	======================================
		Swiper slider
	======================================
	*/
	(function() {
	    var swiper = new Swiper('.swiper-container', {
	      slidesPerView: 1,
	      spaceBetween: 30,
	      autoplay: true,
	      loop: true,
	      pagination: {
	        el: '.swiper-pagination',
	        clickable: true,
	      },
	      navigation: {
	        nextEl: '.swiper-button-next',
	        prevEl: '.swiper-button-prev',
	      },
	    });
	})();


	/*
	======================================
		One Page Init
	======================================
	*/
	(function() {
		var $root = $('html, body');
		$('.one-page-nav a[href^="#"]').on('click', function () {
		    $root.animate({
		        scrollTop: $( $.attr(this, 'href') ).offset().top
		    }, 2000, "easeInOutExpo");

		    return false;
		});
	})();



	/*
	======================================
		ScrollTop Init
	======================================
	*/
	(function() {
		$('#top').on('click', function(){
			$('html, body').animate({'scrollTop': '0px'}, 3000, "easeInOutExpo");
			return false;
		});
	})();



	/*
	======================================
		Active Class On Scroll
	======================================
	*/
	$(window).on('scroll', function(e){

		var $headerH 	= jQuery('.thecho-header-area').height();
		var $headerMH 	= jQuery('.thecho-mobile-menu-area').height();
		var $windowH 	= jQuery(window).scrollTop();
		var $header 	= jQuery('.thecho-header-area');
		var $headerM 	= jQuery('.thecho-mobile-menu-area');

		if( $windowH > $headerH ) {
			$header.addClass('fixed');
		} else {
			$header.removeClass('fixed');
		}

		if( $windowH > $headerMH ) {
			$headerM.addClass('fixed');
		} else {
			$headerM.removeClass('fixed');
		}

	    var position = $(this).scrollTop();

	    $('section').each(function() {
	        var target = $(this).offset().top - 70;
	        var id = $(this).attr('id');

	        if (position >= target) {
	            $('.one-page-nav li > a').removeClass('active');
	            $('.one-page-nav li > a[href="#' + id + '"]').addClass('active');
	        }
	    });

		/*
		======================================
			ScrollTop Visibility Init
		======================================
		*/
		var $scrollTop 	= jQuery(window).scrollTop();
		var $top 		= jQuery('#top');
		
		if( $scrollTop > 500 ) {
			$top.fadeIn(500);
		} else {
			$top.fadeOut(500);
		}

	});


})(jQuery);