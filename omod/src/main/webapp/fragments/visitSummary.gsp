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
				}
			})
		});
		var visitSummaries = jq(".visit-summary");
		if (visitSummaries.length > 0) {
			visitSummaries[0].click();
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
	
	<div class="col16 dashboard" style="min-width: 78%">
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
		
		<div class="info-section" id="drugs-detail">
			<div class="info-header">
				<i class="icon-list-ul"></i>
				<h3>PRESCRIBED DRUGS SUMMARY</h3>
			</div>
			<table>
				<thead>
					<tr>
						<td>Name</td>
						<td>Unit</td>
						<td>Formulation</td>
						<td>Dosage</td>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>N/A</td>
						<td>N/A</td>
						<td>N/A</td>
						<td>N/A</td>
					</tr>
				 </tbody>
			</table>
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

        <label><span class="status active"></span>physicalExamination:</label>
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

	</div>
</script>

<script id="drugs-template" type="text/template">
    <p>
        <small>Drugs</small>
    </p>
    <table>
        <thead>
            <tr>
                <td>Name</td>
                <td>Unit</td>
                <td>Formulation</td>
            </tr>
        </thead>
        <tbody>
		{{ _.each(drugs, function(drug) { }}
            <tr>
                <td>{{-drug.inventoryDrug.name}}</td>
                <td>{{-drug.inventoryDrug.unit.name}}</td>
                <td>{{-drug.inventoryDrugFormulation.name}}:{{-drug.inventoryDrugFormulation.dozage}}</td>
            </tr>
		{{ }); }}
         </tbody>
    </table>
</script>