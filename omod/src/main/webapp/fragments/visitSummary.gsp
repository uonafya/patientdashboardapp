<script>
	jq(function(){		
		jq(".left-menu").on("click", ".visit-summary", function(){
			jq("#visit-detail").html("<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i>")
			var visitSummary = jq(this);
			jq(".visit-summary").removeClass("selected");
			jq(visitSummary).addClass("selected");
			jq.getJSON('${ ui.actionLink("patientdashboardapp", "visitSummary" ,"getVisitSummaryDetails") }',
				{ 'encounterId' : jq(visitSummary).find(".encounter-id").val() }
			).success(function (data) {
				var visitDetailTemplate =  _.template(jq("#visit-detail-template").html());
				jq("#visit-detail").html(visitDetailTemplate(data.notes));

				if (data.drugs.length > 0) {
					console.log(data);
					var drugsTemplate =  _.template(jq("#drugs-template").html());
					jq("#drugs-detail").html(drugsTemplate(data));
					
					console.log(data.drugs);
				}
				else {
					var drugsTemplate =  _.template(jq("#empty-template").html());
					jq("#drugs-detail").html(drugsTemplate(data));
				}
			})
		});

		var visitSummaries = jq(".visit-summary");
		if (visitSummaries.length > 0) {
			visitSummaries[0].click();
			jq('#cs').show();
		}else{
			jq('#cs').hide();
		}
	});
</script>



<div class="onerow">
	<div style="padding-top: 15px;" class="col15 clear">
		<ul id="left-menu" class="left-menu">
			<% visitSummaries.each { summary -> %>

			<li class="menu-item visit-summary" visitid="54">
				<input type="hidden" class="encounter-id" value="${summary.encounterId}" >
				<span class="menu-date">
					<i class="icon-time"></i>
					<span id="vistdate">
						<script>document.write(moment('${summary.visitDate}').format('DD,MMM YYYY, hh:mm:ss'));</script>
					</span>
				</span>
				<span class="menu-title">
					<i class="icon-stethoscope"></i>
						<% if (summary.outcome) { %>
							${ summary.outcome }
						<% }  else { %>
							No Outcome Yet
						<% } %>
				</span>
				<span class="arrow-border"></span>
				<span class="arrow"></span>
			</li>
			
			<% } %>
			
			<li style="height: 30px;" class="menu-item">
			</li> 
		</ul>
	</div>
	
	<div class="col16 dashboard opdRecordsPrintDiv" style="min-width: 78%">
		<div class="info-section" id="visit-detail">
			<div class="info-header">
				<i class="icon-user-md"></i>
				<h3>CLINICAL HISTORY SUMMARY</h3>
			</div>
			
			<div class="info-body">
				<label><span class="status active"></span>History:</label>
				<span>N/A</span>
				<br>
                <label><span class="status active"></span>physicalExamination:</label>
                <span>N/A</span>
                <br>
				
				<label><span class="status active"></span>Symptoms:</label>
				<span>N/A</span>
				<br>
				
				<label><span class="status active"></span>Diagnosis:</label>
				<span>N/A</span>
				<br>
				
				<label><span class="status active"></span>Investigations:</label>
				<span>N/A</span>
				<br>
				
				<label><span class="status active"></span>Procedures:</label>
				<span>N/A</span>
				<br>

			</div>
		</div>
		
		<div class="info-sections" id="drugs-detail" style="margin: 0px 10px 0px 5px;">			
			
		</div>
	</div>
</div>

<div class="main-content" style="border-top: 1px none #ccc;">
    <div id=""></div>
</div>

<script id="visit-detail-template" type="text/template">
	<div class="info-header">
		<i class="icon-user-md"></i>
		<h3>CLINICAL HISTORY SUMMARY INFORMATION</h3>
	</div>

	<div class="info-body">
		<label><span class='status active'></span>History:</label>
		<span>{{-history}}</span>
		<br>

		<label><span class="status active"></span>Physical Examination:</label>
		<span>{{-physicalExamination}}</span>
		<br>

		<label><span class="status active"></span>Symptoms:</label>
		<span>{{-symptoms}}</span>
		<br>

		<label><span class="status active"></span>Diagnosis:</label>
		<span>{{-diagnosis}}</span>
		<br>

		<label><span class="status active"></span>Investigations:</label>
		<span>{{-investigations}}</span>
		<br>

		<label><span class="status active"></span>Procedures:</label>
		<span>{{-procedures}}</span>
		<br>

		<label><span class="status active"></span>Internal Referral:</label>
		<span>{{-internalReferral}}</span>
		<br>

		<label><span class="status active"></span>External Referral:</label>
		<span>{{-externalReferral}}</span>
		<br>

        <label><span class="status active"></span>Visit Outcome:</label>
        <span>{{-visitOutcome}}</span>
        <br>

	</div>
</script>


<script id="drugs-template" type="text/template">
	<div class="info-header">
		<i class="icon-medicine"></i>
		<h3>DRUGS PRESCRIPTION SUMMARY INFORMATION</h3>
	</div>

	<table id="drugList">
		<thead>
			<tr>
				<th>#</th>
				<th>Name</th>
				<th>Formulation</th>
				<th>Dosage</th>
			</tr>
		</thead>
		<tbody>
		{{ _.each(drugs, function(drug, index) { }}
			<tr>
				<td>{{=index+1}}</td>
				<td>{{-drug.inventoryDrug.name}}</td>
				<td>{{-drug.inventoryDrugFormulation.name}}:{{-drug.inventoryDrugFormulation.dozage}}</td>
				<td>{{-drug.dosage}}:{{-drug.dosageUnit.name}}</td>
			</tr>
		{{ }); }}
		 </tbody>
	</table>
</script>

<script id="empty-template" type="text/template">
	<div class="info-header">
		<i class="icon-medicine"></i>
		<h3>DRUGS PRESCRIPTION SUMMARY INFORMATION</h3>
	</div>

	<table id="drugList">
		<thead>
			<tr>
				<th>#</th>
				<th>Name</th>
				<th>Formulation</th>
				<th>Unit</th>
				<th>Dosage</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td></td>
				<td style="text-align: center;" colspan="4">No Drugs Prescribed</td>
			</tr>
		 </tbody>
	</table>
</script>

<div><button id="opdRecordsPrintButton" onclick="printOpdRecords();" class="confirm" style="float: right;">Print</button></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>

<script>
	var printOpdRecords;

	function printOpdRecords(){
		var printDiv = jq(".opdRecordsPrintDiv").html();
		console.log(printDiv);
		var printWindow = window.open('', '', 'height=400,width=800');
		printWindow.document.write('<html><head><title>Patient Information</title>');
		printWindow.document.write(printDiv);
		printWindow.document.write('</body></html>');
		printWindow.document.close();
		printWindow.print();
	}

</script>

