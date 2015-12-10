<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery-1.10.2.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

<script>
jq = jQuery;
jq(function() {
    jq( "#symptom" ).autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getSymptoms") }',
                { q: request.term })
            .success(function(data) {
                var results = [];
                for (var i in data) {
                    var result = { label: data[i].name, value: data[i].id};
                    results.push(result);
                }
                response(results);
            });
        },
        minLength: 3,
        select: function( event, ui ) {
            var selectedSymptom = document.createElement('option');
            selectedSymptom.value = ui.item.value;
            selectedSymptom.text = ui.item.label;
            selectedSymptom.id = ui.item.value;
            var selectedSymptomList = document.getElementById("selectedSymptomList");


            //adds the selected symptoms to the div
            var selectedSymptomP = document.createElement("P");

            var selectedSymptomT = document.createTextNode(ui.item.label);
            selectedSymptomP.id = ui.item.value;
            selectedSymptomP.appendChild(selectedSymptomT);
            var btnselectedSymptom = document.createElement("input");
            btnselectedSymptom.id = "remove";
            btnselectedSymptom.type = "button";
            btnselectedSymptom.value = "Remove";

            selectedSymptomP.appendChild(btnselectedSymptom);
            var selectedSymptomDiv = document.getElementById("selected-symptoms");

            //check if the item already exist before appending
            var exists = false;
            for (var i = 0; i < selectedSymptomList.length; i++) {
                if(selectedSymptomList.options[i].value==ui.item.value) {
                    exists = true;
                }
            }

           if(exists == false) {
                selectedSymptomList.appendChild(selectedSymptom);
                selectedSymptomDiv.appendChild(selectedSymptomP);
            }

        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    //removes symptom from the selected list upon clicking the remove button
     jq("#selected-symptoms").on("click", "#remove",function(){
        var symptomId = jq(this).parent("p").attr("id");
        var symptomP = jq(this).parent("p");

        var divSymptom = symptomP.parent("div");
        var selectInputPosition = divSymptom.siblings("p");
        var selectedSymptom = selectInputPosition.find("select");
        var removeSymptom = selectedSymptom.find("#" + symptomId);

        symptomP.remove();
        removeSymptom.remove();

        });

    jq( "#diagnosis" ).autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getDiagnosis") }',
                { q: request.term })
            .success(function(dataD) {
                var results = [];
                for (var i in dataD) {
                    var result = { label: dataD[i].name, value: dataD[i].id};
                    results.push(result);
                }
                response(results);
            });
        },
        minLength: 3,
        select: function( event, ui ) {
            var selectedDiagnosis = document.createElement('option');
            selectedDiagnosis.value = ui.item.value;
            selectedDiagnosis.text = ui.item.label;
            selectedDiagnosis.id = ui.item.value;
            var selectedDiagnosisList = document.getElementById("selectedDiagnosisList");


            //adds the selected diagnosis to the div
            var selectedDiagnosisP = document.createElement("P");
             var selectedDiagnosisT = document.createTextNode(ui.item.label);
               selectedDiagnosisP.id = ui.item.value;
               selectedDiagnosisP.appendChild(selectedDiagnosisT);
               var btnselectedDiagnosis = document.createElement("input");
               btnselectedDiagnosis.id = "remove";
               btnselectedDiagnosis.type = "button";
               btnselectedDiagnosis.value = "Remove";

             selectedDiagnosisP.appendChild(btnselectedDiagnosis);
            var selectedDiagnosisDiv = document.getElementById("selected-diagnosis");




            //check if the item already exist before appending
            var exists = false;
            for (var i = 0; i < selectedDiagnosisList.length; i++) {
                if(selectedDiagnosisList.options[i].value==ui.item.value) {
                    exists = true;
                }
            }

            if(exists == false) {
                selectedDiagnosisList.appendChild(selectedDiagnosis);
                selectedDiagnosisDiv.appendChild(selectedDiagnosisP);
            }

        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    //removes diagnosis from the selected list upon clicking the remove button
         jq("#selected-diagnosis").on("click", "#remove",function(){
            var diagnosisId = jq(this).parent("p").attr("id");
            var diagnosisP = jq(this).parent("p");

            var divDiagnosis = diagnosisP.parent("div");
            var selectInputPosition = divDiagnosis.siblings("p");
            var selectedDiagnosis = selectInputPosition.find("select");
            var removeDiagnosis = selectedDiagnosis.find("#" + diagnosisId);

            diagnosisP.remove();
            removeDiagnosis.remove();

            });


    jq(function() {
        jq( "#procedure" ).autocomplete({
             source: function( request, response ) {
              jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getProcedures") }',
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
               var selectedProcedure = document.createElement('option');
    		   selectedProcedure.value = ui.item.value;
    		   selectedProcedure.text = ui.item.label;
    		   selectedProcedure.id = ui.item.value;
    		   var selectedProcedureList = document.getElementById("selectedProcedureList");


    		   //adds the selected procedures to the div
    		   var selectedProcedureP = document.createElement("P");

               var selectedProcedureT = document.createTextNode(ui.item.label);
               selectedProcedureP.id = ui.item.value;
               selectedProcedureP.appendChild(selectedProcedureT);
               var btnselectedProcedure = document.createElement("input");
               btnselectedProcedure.id = "remove";
               btnselectedProcedure.type = "button";
               btnselectedProcedure.value = "Remove";

               selectedProcedureP.appendChild(btnselectedProcedure);
               var selectedProcedureDiv = document.getElementById("selected-procedures");

               //check if the item already exist before appending
               var exists = false;
    		   for (var i = 0; i < selectedProcedureList.length; i++) {
                   if(selectedProcedureList.options[i].value==ui.item.value)
                   {
                   		exists = true;
                   }
               }

    			if(exists == false)
    			{
    			   selectedProcedureList.appendChild(selectedProcedure);
    			   selectedProcedureDiv.appendChild(selectedProcedureP);
    			}

             },
             open: function() {
               jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
             },
             close: function() {
               jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
             }
           });
      });

       //removes procedures from the selected list upon clicking the remove button
       jq("#selected-procedures").on("click", "#remove",function(){
          var procedureId = jq(this).parent("p").attr("id");
          var procedureP = jq(this).parent("p");

          var divProcedure = procedureP.parent("div");
          var selectInputPosition = divProcedure.siblings("p");
          var selectedProcedure = selectInputPosition.find("select");
          var removeProcedure = selectedProcedure.find("#" + procedureId);

          procedureP.remove();
          removeProcedure.remove();

          });

      jq( "#investigation" ).autocomplete({
              source: function( request, response ) {
                  jq.getJSON('${ ui.actionLink("patientdashboardui", "ClinicalNotes", "getInvestigations") }',
                      { q: request.term })
                  .success(function(data) {
                      var results = [];
                      for (var i in data) {
                          var result = { label: data[i].name, value: data[i].id};
                          results.push(result);
                      }
                      response(results);
                  });
              },
              minLength: 3,
              select: function( event, ui ) {
                    var selectedInvestigation = document.createElement('option');
                     selectedInvestigation.value = ui.item.value;
                     selectedInvestigation.text = ui.item.label;
                     selectedInvestigation.id = ui.item.value;
                     var selectedInvestigationList = document.getElementById("selectedInvestigationList");


                     //adds the selected symptoms to the div
                     var selectedInvestigationP = document.createElement("P");

                     var selectedInvestigationT = document.createTextNode(ui.item.label);
                     selectedInvestigationP.id = ui.item.value;
                     selectedInvestigationP.appendChild(selectedInvestigationT);
                     var btnselectedInvestigation = document.createElement("input");
                     btnselectedInvestigation.id = "remove";
                     btnselectedInvestigation.type = "button";
                     btnselectedInvestigation.value = "Remove";

                     selectedInvestigationP.appendChild(btnselectedInvestigation);
                     var selectedInvestigationDiv = document.getElementById("selected-investigations");


                  //check if the item already exist before appending
                  var exists = false;
                  for (var i = 0; i < selectedInvestigationList.length; i++) {
                      if(selectedInvestigationList.options[i].value==ui.item.value) {
                          exists = true;
                      }
                  }

                  if(exists == false) {
                      selectedInvestigationList.appendChild(selectedInvestigation);
                      selectedInvestigationDiv.appendChild(selectedInvestigationP);
                  }

              },
              open: function() {
                  jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
              },
              close: function() {
                  jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
              }
          });
           //removes Investigation from the selected list upon clicking the remove button
               jq("#selected-investigations").on("click", "#remove",function(){
                  var investigationId = jq(this).parent("p").attr("id");
                  var investigationP = jq(this).parent("p");

                  var divInvestigation = investigationP.parent("div");
                  var selectInputPosition = divInvestigation.siblings("p");
                  var selectedInvestigation = selectInputPosition.find("select");
                  var removeInvestigation = selectedInvestigation.find("#" + investigationId);

                  investigationP.remove();
                  removeInvestigation.remove();

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
			<select size="4" id="selectedProcedureList" name="selectedProcedureList" multiple="multiple" onclick="moveSelectedById( 'selectedProcedureList', 'availableProcedureList' );">
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
