<script type="text/javascript">

   $(document).ready(function(){
		$('#utility3').css('cursor','pointer').fancybox({
			'height':580,
			'width':680,
			'autoDimensions':false,
			'type':'iframe',
			'href': 'popup/weather.cfm'
		});

		$('#utility4').css('cursor','pointer').fancybox({
			'height':580,
			'width':680,
			'autoDimensions':false,
			'type':'iframe',
			'href': 'popup/message.cfm?type=staff'
		});

		$('#utility5').css('cursor','pointer').fancybox({
			'height':580,
			'width':680,
			'autoDimensions':false,
			'type':'iframe',
			'href': 'popup/message.cfm?type=resident'
		});
		$('#utility6').css('cursor','pointer').fancybox({
			'height':580,
			'width':680,
			'autoDimensions':false,
			'type':'iframe',
			'href': 'popup/bbcomments.cfm?type=resident'
		});

	});	

</script>


</body>
</html>
