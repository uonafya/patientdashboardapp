<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

<script>
jq = jQuery;
jq(function() {
    jq( "#symptom" ).autocomplete({
         source: function( request, response ) {
          jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getSymptoms") }',
              {
                  q: request.term
              }
          ).success(function(data) {
   			  var results = [];
			  for (var i in data) {
				 var result = { label: data[i].name, value: data[i].id};
				 results.push(result);
			  }
			  console.log(data);
			  response(results);
          });
         },
         minLength: 3,
         select: function( event, ui ) {
           var selectedSymptom = document.createElement('option');
		   selectedSymptom.value = ui.item.value;
		   selectedSymptom.text = ui.item.label;
		   var selectedSymptomList = document.getElementById("selectedSymptomList");
		   //check if the item already exist before appending
		   var exists = false;

		   for (var i = 0; i < selectedSymptomList.length; i++) {
               if(selectedSymptomList.options[i].value==ui.item.value)
               {
               		exists = true;
               }
           }

			if(exists == false)
			   selectedSymptomList.appendChild(selectedSymptom);

           log( ui.item ?
             "Selected: " + ui.item.id :
             "Nothing selected, input was " + this.name);
         },
         open: function() {
           jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
         },
         close: function() {
           jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
         }
       });
  });
</script>

<form method="post">
	<fieldset>
		<legend>
			Clinical Notes
		</legend>
		<input type="hidden" name="patientId" value="${patientId }" />
		<input type="hidden" name="opdId" value="${opd.conceptId }" />
		<input type="hidden" name="queueId" id="queueId" value="${queueId}" />
		<input type="hidden" name="opdLogId" id="opdLogId" value="${opdLogId}" />
		<p class="input-position-class">
			<label for="history">History of Presenting illness</label>
			<textarea id="history" name="history" rows="1" cols="15"></textarea>
		</p>
		
		<p class="input-position-class">
			<label for="symptom">Symptom</label>
			<input id="symptom" title="${opd.conceptId}" name="symptom" />
			<select id="selectedSymptomList" name="selectedSymptomList" multiple="multiple" >
			</select>
			<div id="selected-symptoms"></div>
		</p>
		
		<p class="input-position-class left">
			<input type="radio" name="radio_dia" value="prov_dia" id="prov_dia" onclick="loadSelectedDiagnosisList();"/>
			<label for="prov_dia">Provisional</label>
		</p>
		<p class="input-position-class left">
			<input type="radio" name="radio_dia" value="final_dia" id="final_dia" onclick="removeSelectedDia();"/>
			<label for="final_dia">Final</label>
		</p>
		<p class="input-position-class">
			<label for="diagnosis">Diagnosis:</label><em>(Required)</em>
			<input id="diagnosis" title="${opd.conceptId}" name="diagnosis" />
			<select id="selectedDiagnosisList" name="selectedDiagnosisList" multiple="multiple" onclick="moveSelectedById( 'selectedDiagnosisList', 'availableDiagnosisList' );">
			</select>
			<div id="selected-diagnosis"></div>
		</p>
		
		<p class="input-position-class">
			<label for="procedure">Post for Procedure:</label>
			<input title="${opd.conceptId }" id="procedure" name="procedure" />
			<select size="4" name="selectedProcedureList" multiple="multiple" onclick="moveSelectedById( 'selectedProcedureList', 'availableProcedureList' );">
			</select>
			<div id="selected-procedures"></div>
		</p>
		
		<p class="input-position-class">
			<label for="investigation">Investigation:</label>
			<input title="${opd.conceptId}" id="investigation" name="investigation" />
			<select id="selectedInvestigationList" name="selectedInvestigationList" multiple="multiple" onclick="moveSelectedById( 'selectedInvestigationList', 'availableInvestigationList' )">
			<select>
			<div id="selected-investigations"></div>
		</p>
		
		<p class="input-position-class">
			<label>Drug:
				<input title="${opd.conceptId}" id="drugName" name="drugName" placeholder="Search for drugs" onblur="ISSUE.onBlur(this);" />
				<select id="formulation" name="formulation">
					<option value="">
						Select Formulation
					</option>
				</select>
				<select id="frequency" name="frequency">
					<option value="">Select Frequency</option>
					<% drugFrequencyList.each { %>
						<option value="${it.name}.${it.conceptId}">${it.name}</option>
					<% } %>
				</select>
				<input type="text" id="noOfDays" name="noOfDays" placeholder="No Of Days" >
				<input id="comments"  type="text" name="comments" placeholder="Comments" >
				<input type="button" value="Add" onClick="addDrugOrder();" />
			</label>
		</p>
		
		<p class="input-position-class">
			<label for="note">Other Instructions</label>
			<input type="text" id="note" name="note" />
		</p>
		
		<p class="input-position-class left">
		<label for="internalReferral">Internal Referral</label>
		<select id="internalReferral" name="internalReferral">
			<option value="">Select Referral</option>
			<% listInternalReferral.each { %>
				<option value="${it.answerConcept.id}">${it.answerConcept.name}</option>
			<% } %>
		</select>
		</p>
		
		<p class="input-position-class left">
			<label for="externalReferral">External Referral</label>
			<select id="externalReferral" name="externalReferral">
				<option value="">Select Referral</option>
				<% listExternalReferral.each { %>
					<option value="${it.answerConcept.id}">${it.answerConcept.name}</option>
				<% } %>
			</select>
		</p>
		
		<p class="input-position-class">
			<label>OPD Outcome
				<input type="radio" name="radio_f" value="Died" id="died" onclick="DASHBOARD.onChangeRadio(this);radio_fSelected();">Died&nbsp;&nbsp;
				<% if (!admitted) {%>
					<input type="radio" name="radio_f" id="input_follow"
						value="Follow-up" onclick="DASHBOARD.onChangeRadio(this); removePrompt(); ">Follow Up 
					<input	type="text" class="date-pick left" readonly="readonly"
						ondblclick="this.value='';" name="dateFollowUp"
						id="dateFollowUp" onclick="DASHBOARD.onClickFollowDate(this); " onchange=" radio_fSelected();">
						&nbsp;&nbsp;
					<input type="radio" name="radio_f" value="Cured" id="cured"
						onclick="DASHBOARD.onChangeRadio(this);radio_fSelected();">Cured
						&nbsp;&nbsp;
				<% } %>
				<input type="radio" name="radio_f" value="Reviewed" id="reviewed" onclick="DASHBOARD.onChangeRadio(this);radio_fSelected();">Reviewed&nbsp;&nbsp;
				<% if (!admitted) {%>
					<input type="radio" name="radio_f" value="Admit" id="admit" onclick="DASHBOARD.onChangeRadio(this); removePrompt();">Admit
				<% } %>
				<select id="ipdWard" name="ipdWard" onChange="radio_fSelected();">
					<option value="">--Select--</option>
					<% listIpd.each {%>
						<option value="${it.answerConcept.id}">${it.answerConcept.name}</option>
					<% } %>
				</select>
			</label>
		</p>
		
		<% if(queueId != null) { %>
			<p class="input-position-class">
				<input type="submit" value="Conclude Visit" onclick="DASHBOARD.submitOpdEntry(); javascript:return validateTriage();" />
				<label id="lblPrompt" style="color: #FF0000;" ><b>Please click on 'CONCLUDE VISIT' to save the patient's details</b></label>
			</p>
		<% } %>
		<% if (opdLogId != null) { %>
			<p class="input-position-class">
				<input type="submit" value="Conclude Visit" onclick="DASHBOARD.submitOpdEntry();" />
				<input type="submit" value="Back" onclick="DASHBOARD.backToOpdQueue('${opdLogId}');" />
				<label id="lblPrompt" style="color: #FF0000;" ><b>Please click on 'CONCLUDE VISIT' to save the patient's details</b></label>
			</p>
		<% } %>
	</fieldset>
	<div>
		<h2>Debug Vals</h2>
		<p>
			queueId=${queueId}
		</p>
		<p>
			opdLogId=${opdLogId}
		</p>
	</div>
</form>
