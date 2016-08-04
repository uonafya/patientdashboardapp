<script>
	jq(function(){
		jq("#ul-left-menu").on("click", ".visit-summary", function(){
			jq("#visit-detail").html('<i class=\"icon-spinner icon-spin icon-2x pull-left\"></i> <span style="float: left; margin-top: 12px;">Loading...</span>');	
			jq("#drugs-detail").html("");
			jq("#opdRecordsPrintButton").hide();
			
			var visitSummary = jq(this);
			jq(".visit-summary").removeClass("selected");
			jq(visitSummary).addClass("selected");
			jq.getJSON('${ ui.actionLink("patientdashboardapp", "visitSummary" ,"getVisitSummaryDetails") }',
				{ 'encounterId' : jq(visitSummary).find(".encounter-id").val() }
			).success(function (data) {
				var visitDetailTemplate =  _.template(jq("#visit-detail-template").html());
				console.log(data.notes);
				jq("#visit-detail").html(visitDetailTemplate(data.notes));

				if (data.drugs.length > 0) {
					var drugsTemplate =  _.template(jq("#drugs-template").html());
					jq("#drugs-detail").html(drugsTemplate(data));
				}
				else {
					var drugsTemplate =  _.template(jq("#empty-template").html());
					jq("#drugs-detail").html(drugsTemplate(data));
				}
				
				jq("#opdRecordsPrintButton").show(100);
			})
		});
		
		jq('#opdRecordsPrintButton').click(function(){
			jq("#printSection").print({
				globalStyles: 	false,
				mediaPrint: 	false,
				stylesheet: 	'${ui.resourceLink("patientdashboardapp", "styles/printout.css")}',
				iframe: 		false,
				width: 			600,
				height:			700
			});			
		});

		var visitSummaries = jq(".visit-summary");
		
		if (visitSummaries.length > 0) {
			visitSummaries[0].click();
			jq('#cs').show();
		}else{
			jq('#cs').hide();
		}
		
		jq('#ul-left-menu').slimScroll({
			allowPageScroll: false,
			height		   : '426px',
			distance	   : '11px',
			color		   : '#363463'
		});
		
		jq('#ul-left-menu').scrollTop(0);
		jq('#slimScrollDiv').scrollTop(0);
	});
</script>

<style>
	#ul-left-menu {
		border-top: medium none #fff;
		border-right: 	medium none #fff;
	}
	#ul-left-menu li:nth-child(1) { 
		border-top: 	1px solid #ccc;
	}
	#ul-left-menu li:last-child { 
		border-bottom:	1px solid #ccc;
		border-right:	1px solid #ccc;
	}
	.visit-summary{
		
	}
</style>

<div class="onerow">
	<div id="div-left-menu" style="padding-top: 15px;" class="col15 clear">
		<ul id="ul-left-menu" class="left-menu">
			<% visitSummaries.each { summary -> %>
			<li class="menu-item visit-summary" visitid="54" style="border-right:1px solid #ccc; margin-right: 15px; width: 168px; height: 18px;">
				<input type="hidden" class="encounter-id" value="${summary.encounterId}" >
				<span class="menu-date">
					<i class="icon-time"></i>
					<span id="vistdate">
						${ui.formatDatetimePretty(summary.visitDate)}
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
			
			<li style="height: 30px; margin-right: 15px; width: 168px;" class="menu-item">
			</li>
		</ul>
	</div>
	
	<div class="col16 dashboard opdRecordsPrintDiv" style="min-width: 78%">
		<div id="printSection">
			<div id="person-detail">
				<h3>PATIENT SUMMARY INFORMATION</h3>
				
				<label>
					<span class='status active'></span>
					Identifier:
				</label>
				<span>${patient.getPatientIdentifier()}</span>
				<br/>
				
				<label>
					<span class='status active'></span>
					Full Names:
				</label>
				<span>${patient.givenName} ${patient.familyName} ${patient.middleName?patient.middleName:''}</span>
				<br/>
				
				<label>
					<span class='status active'></span>
					Age:
				</label>
				<span>${patient.age} (${ui.formatDatePretty(patient.birthdate)})</span>
				<br/>
				
				<label>
					<span class='status active'></span>
					Gender:
				</label>
				<span>${gender}</span>
				<br/>
			</div>
			
			<div class="info-section" id="visit-detail">
				
			</div>
			
			<div class="info-sections" id="drugs-detail" style="margin: 0px 10px 0px 5px;">			
				
			</div>		
		</div>
		
		<button id="opdRecordsPrintButton" class="task" style="float: right; margin: 10px;">
			<i class="icon-print small"></i>
			Print
		</button>
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
		<label style="display: inline-block; font-weight: bold; width: 190px"><span class='status active'></span>History:</label>
		<span>{{-history}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Physical Examination:</label>
		<span>{{-physicalExamination}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Symptoms:</label>
		<span>{{-symptoms}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Diagnosis:</label>
		<span>{{-diagnosis}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Investigations:</label>
		<span>{{-investigations}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Procedures:</label>
		<span>{{-procedures}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Internal Referral:</label>
		<span>{{-internalReferral}}</span>
		<br>

		<label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>External Referral:</label>
		<span>{{-externalReferral}}</span>
		<br>

        <label style="display: inline-block; font-weight: bold; width: 190px"><span class="status active"></span>Visit Outcome:</label>
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
			<tr style="border-bottom: 1px solid #eee;">
				<th>#</th>
				<th>NAME</th>
				<th>FORMULATION</th>
				<th>DOSAGE</th>
			</tr>
		</thead>
		<tbody>
		{{ _.each(drugs, function(drug, index) { }}
			<tr style="border: 1px solid #eee;">
				<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{=index+1}}</td>
				<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.inventoryDrug.name}}</td>
				<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.inventoryDrugFormulation.name}}:{{-drug.inventoryDrugFormulation.dozage}}</td>
				<td style="border: 1px solid #eee; padding: 5px 10px; margin: 0;">{{-drug.dosage}}:{{-drug.dosageUnit.name}}</td>
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

<div></div>
<div style="clear: both;"></div>
<div style="clear: both;"></div>