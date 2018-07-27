(function(window,$,undefined){

	ShipSticks = function(){
		this.initialized=false;



	};
	

	ShipSticks.prototype.Initialize = function()
	{
		if(this.initialized) return;
		this.initialized=true;

		console.log('initializing interface');
		$('#package-calculator-btn').on('click',this.LaunchCalculator.bind(this));
	}

	ShipSticks.prototype.LaunchCalculator = function()
	{

		console.log('launching calculator');
		$('.calculator-modal').modal({
			show: true
		});
		$('.calculator-modal').on('click','.calculate-button',this.OnCalculateButtonClick.bind(this));
	}
	ShipSticks.prototype.OnCalculateButtonClick = function()
	{
		var length_value = parseInt($('#input-length').val());
		if(length_value==undefined || length_value==0 || isNaN(length_value)){
			$('.calculator-alert').removeClass('hidden').html("Please enter a valid length");
			return;
		}
		var width_value = parseInt($('#input-width').val());
                if(width_value==undefined || width_value==0 || isNaN(width_value) ){
                        $('.calculator-alert').removeClass('hidden').html("Please enter a valid width");
                        return;
                }
		var height_value = parseInt($('#input-height').val());
                if(height_value==undefined || height_value==0 || isNaN(height_value) ){
                        $('.calculator-alert').removeClass('hidden').html("Please enter a valid height");
                        return;
                }
		var weight_value = parseInt($('#input-weight').val());
                if(weight_value==undefined || weight_value==0 || isNaN(weight_value) ){
                        $('.calculator-alert').removeClass('hidden').html("Please enter a valid weight");
                        return;
                }
		$('.calculator-alert').html('');

		var img=$('<img>')
			.attr('src','https://s3.amazonaws.com/shipsticks-challenge/wait22trans.gif');
		$('.calculator-selection').html(img);


		$.getJSON('/products', {
				length: length_value,
				width: 	width_value,
				height: height_value,
				weight: weight_value
			})
			.done(function(data){
				console.log('got',data);
				var product = data[0];
				$('.calculator-selection')
					.css({color: 'green',
						fontSize: '14pt',
						fontWeight: 'bold',
						textAlign: 'center'
					})
					.html('Use this '+product.name);

				$('.selected-packaging')
					.attr('data-packageid',product.id)
					.attr('data-packagetype',product.type)
					.attr('data-packagename',product.name)
					.html(product.name);

				localStorage.setItem('selected-packaging',JSON.stringify(product));

				setTimeout(function(){
					$('.calculator-modal').modal('hide');
				},5000);
			})
			.fail(function(jqxhr,textStatus,error){
				console.log('something went wrong',jqxhr,textStatus,error);
				$('.calculator-selection')
					.css({ 	color: 'red', 
						fontSize: '14pt',
                                                fontWeight: 'bold',
						textAlign: 'center'
					})
					.html("Sorry, we did not find a package that fits those dimensions.");

			});
	}

	window.ShipSticks = new ShipSticks();

})(window,jQuery);



$(document).ready(function(){
	if(window.ShipSticks) window.ShipSticks.Initialize();
});

