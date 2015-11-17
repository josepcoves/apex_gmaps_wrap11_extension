<p>
	Updated by JCoves</p>
<p>
	================</p>
<strong>Last updated: 10/07/2015. Version 1.1 new features:</strong>
<ul>
<li>Upgraded inner gomaps plugin to version 1.3.3 (includes Googlemaps v3)</li>
<li>Added possibility to group plugins using new sql column group</li>
</ul>
<strong>Version 1.0 new features:</strong>
<p>
	Added the following attributes at SQL Query:</p>
<p>
	&nbsp;</p>
<ul>
	<li>
		Icon: Use custom pin image, specify the image URL&nbsp;</li>
	<li>
		Latlong: Specify Latitude and Longitude instead of address to increase performance on multiple markers. Ex:&nbsp;41.380268, 2.190475</li>
</ul>
<p>
	&nbsp;</p>
<p>
	&nbsp;</p>
<p>
	================</p>
<p>
	The Warp11 GMaps plugin provides an easy way of incorporating a Google Map on your page.</p>
<p>
	The plugin was created bij Richard &amp; Sergei Martens of the Warp 11 Center of Excellence.</p>
<p>
	The plugin uses a number of parameters / settings:</p>
<ul>
	<li>
		StreetViewControl</li>
	<li>
		navigationControl</li>
	<li>
		maptype</li>
	<li>
		mapTypeControl</li>
	<li>
		mapTypeControl_position</li>
	<li>
		mapTypeControl_style</li>
	<li>
		address (page item)</li>
	<li>
		zoom (integer)</li>
</ul>
<p>
	It is essential that the page-items mentioned in the settings are rendered <strong>before</strong> then gmaps plugin. Otherwise the plugin cannot read the values. The page items can be of the <em>hidden</em> type.</p>
<p>
	Width and Hight of the page-item are used to create the map.</p>
<p>
	More information can be found at <a href="http://apex.warp11.nl" target="_blank">http://apex.warp11.nl</a></p>