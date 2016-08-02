<cfif qParcels.recordcount>
<div class="alert alert-danger" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close">
	<span aria-hidden="true">&times;</span></button>
	<a data-toggle="modal" data-target="#baseModal" data-action="parcelHistory"><span class="glyphicon glyphicon-envelope"></span>  <strong>Notice:</strong>  You have a Parcel/Mail waiting for pick-up</a>
</div>
</cfif>