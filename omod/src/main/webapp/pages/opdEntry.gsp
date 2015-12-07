<h2>Clinical Notes</h2>

<form method="post">
	<div class="container">
		<input type="hidden" name="patientId" value="${patientId }" />
		<input type="hidden" name="opdId" value="${opd.conceptId }" />
		<input type="hidden" name="queueId" id="queueId" value="${queueId }" />
		<input type="hidden" name="opdLogId" id="opdLogId" value="${opdLogId }" />
		
		<label for="history">History of Presenting illness</label>
		<textarea id="history" name="history" rows="1" cols="15"></textarea>
		
		<label for="symptom">Symptom</label>
		<input id="symptom" title="${opd.conceptId}" name="symptom" />
		<select id="selectedSymptomList" name="selectedSymptomList" multiple="multiple" >
		</select>
		<div id="selected-symptoms"></div>
		
		<input type="radio" name="radio_dia" value="prov_dia" id="prov_dia" onclick="loadSelectedDiagnosisList();"/><strong>Provisional</strong>
		<input type="radio" name="radio_dia" value="final_dia" id="final_dia" onclick="removeSelectedDia();"/><strong>Final</strong>&nbsp;&nbsp;
		<label for="diagnosis">Diagnosis:</label><em>(Required)</em>
		<input id="diagnosis" title="${opd.conceptId}" name="diagnosis" />
		<select id="selectedDiagnosisList" size="4" style="width: 550px" name="selectedDiagnosisList" multiple="multiple" onclick="moveSelectedById( 'selectedDiagnosisList', 'availableDiagnosisList' );">
		</select>
		<div id="selected-diagnosis"></div>
		
		<label for="procedure">Post for Procedure:</label>
		<input title="${opd.conceptId }" id="procedure" name="procedure" />
		<select size="4" name="selectedProcedureList" multiple="multiple" onclick="moveSelectedById( 'selectedProcedureList', 'availableProcedureList' );">
		</select>
		<div id="selected-procedures"></div>
		
		<label for="investigation">Investigation:</label>
		<input title="${opd.conceptId}" id="investigation" name="investigation" />
		<select id="selectedInvestigationList" name="selectedInvestigationList" multiple="multiple" onclick="moveSelectedById( 'selectedInvestigationList', 'availableInvestigationList' )">
		<select>
		<div id="selected-investigations"></div>
		
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
		
		<label for="note">Other Instructions</label>
		<input type="text" id="note" name="note" />
		
		<label for="internalReferral">Internal Referral</label>
		<select id="internalReferral" name="internalReferral">
			<option value="">Select Referral</option>
			<% listInternalReferral.each { %>
				<option value="${it.answerConcept.id}">${it.answerConceptId.name}</option>
			<% } %>
		</select>
		<label for="externalReferral">External Referral</label>
		<select id="externalReferral" name="externalReferral">
			<option value="">Select Referral</option>
			<% listExternalReferral.each { %>
				<option value="${it.answerConcept.id}">${it.answerConceptId.name}</option>
			<% } %>
		</select>
		
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
		
		<% if(!queueId) { %>
			<input type="submit" value="Conclude Visit" onclick="DASHBOARD.submitOpdEntry(); javascript:return validateTriage();" />
			<label id="lblPrompt" style="color: #FF0000;" ><b>Please click on 'CONCLUDE VISIT' to save the patient's details</b></label>
		<% } %>
		<% if (!opdLogId) { %>
			<input type="submit" value="Conclude Visit" onclick="DASHBOARD.submitOpdEntry();" />
			<input type="submit" value="Back" onclick="DASHBOARD.backToOpdQueue('${opdLogId}');" />
			<label id="lblPrompt" style="color: #FF0000;" ><b>Please click on 'CONCLUDE VISIT' to save the patient's details</b></label>
		<% } %>
	</div>
</form>
