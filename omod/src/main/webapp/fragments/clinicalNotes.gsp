<%
    ui.includeCss("uicommons", "datetimepicker.css")
	ui.includeCss("registration", "onepcssgrid.css")
	
    ui.includeJavascript("patientdashboardapp", "note.js")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
	ui.includeJavascript("patientdashboardapp", "knockout-3.4.0.js")
	
    def successUrl = ui.pageLink("patientqueueui", "chooseOpd")
%>
<script>
var jq = jQuery,
    NavigatorController,
    previousNote = JSON.parse('${note}'),
    note = new Note(previousNote);



var getJSON = function (dataToParse) {
	if (typeof dataToParse === "string") {
		return JSON.parse(dataToParse);
	}
	return dataToParse;
}
var outcomeOptions = ${outcomeOptions.collect { it.toJson() }}
note.availableOutcomes = jq.map(outcomeOptions, function(outcomeOption){
	return new Outcome(outcomeOption);
});

jQuery(document).ready(function () {
	jq('input[type=radio][name=diagnosis_type]').change(function() {
        if (this.value == 'true') {
            jq('#title-diagnosis').text('PROVISIONAL DIAGNOSIS');
        }
        else {
			if (jq('#title-diagnosis').text() != "DIAGNOSIS"){
				jq('#diagnosis-carrier').html('');
			}
			
            jq('#title-diagnosis').text('FINAL DIAGNOSIS');
        }
    });
});
note.inpatientWards = ${listOfWards.collect { it.toJson() }};
note.internalReferralOptions = ${internalReferralSources.collect { it.toJson() }};
note.externalReferralOptions = ${externalReferralSources.collect { it.toJson() }}

var mappedSigns = jq.map(getJSON(previousNote.signs), function(sign) {
    return new Sign(sign);
});
note.signs(mappedSigns);

var mappedDiagnoses = jq.map(getJSON(previousNote.diagnoses), function(diagnosis) {
    return new Diagnosis(diagnosis);
});
note.diagnoses(mappedDiagnoses);

var mappedInvestigations = jq.map(getJSON(previousNote.investigations), function(investigation) {
    return new Investigation(investigation);
});
note.investigations(mappedInvestigations);

var mappedProcedures = jq.map(getJSON(previousNote.procedures), function(procedure) {
    return new Procedure(procedure);
});
note.procedures(mappedProcedures);

//note

jq(function() {
    NavigatorController = new KeyboardController();
    ko.applyBindings(note, jq("#notes-form")[0]);
    jq( "#symptom" ).autocomplete({
         source: function( request, response ) {
          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getSymptoms") }',
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
           event.preventDefault();
           jq(this).val(ui.item.label);
           jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getQualifiers") }',
               {
                   signId: ui.item.value
               }
           ).success(function(data) {
               var qualifiers = jq.map(data, function (qualifier) {
                   return new Qualifier(qualifier.id, qualifier.label, 
                       jq.map(qualifier.options, function (option) {
                           return new Option(option.id, option.label);
                       }));
               });
               note.addSign(new Sign({"id": ui.item.value, "label": ui.item.label, "qualifiers": qualifiers}));
               jq('#symptom').val('');
			   jq('#task-symptom').show();
           });
         },
         open: function() {
           jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
         },
         close: function() {
           jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
         }
       });

    jq("#diagnosis").autocomplete({
      source: function( request, response ) {
        jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDiagnosis") }',
          {
            q: request.term
          }
        ).success(function(data) {
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
        event.preventDefault();
        jq(this).val(ui.item.label);
        note.addDiagnosis(new Diagnosis({id: ui.item.value, label: ui.item.label}));
        
		jq('#diagnosis').val('');
        jq('#diagnosis').focus();
        jq('#task-diagnosis').show();
		
      },
      open: function() {
        jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
      },
      close: function() {
        jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
      }
    });

    jq("#procedure").autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getProcedures") }',
                    {
                        q: request.term
                    }
            ).success(function(data) {
                        procedureMatches = [];
                        for (var i in data) {
                            var result = { label: data[i].label, value: data[i].id, schedulable: data[i].schedulable };
                            procedureMatches.push(result);
                        }
                        response(procedureMatches);
                    });
        },
        minLength: 3,
        select: function( event, ui ) {
            event.preventDefault();
            jq(this).val(ui.item.label);
            var procedure = procedureMatches.find(function (procedureMatch) {
               return procedureMatch.value === ui.item.value;
            });
            note.addProcedure(new Procedure({id: procedure.value, label: procedure.label, schedulable: procedure.schedulable}));
            jq('#procedure').val('');
            jq('#task-procedure').show();
        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    jq("#investigation").autocomplete({
        source: function( request, response ) {
            jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getInvestigations") }',
                    {
                        q: request.term
                    }
            ).success(function(data) {
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
            event.preventDefault();
            jq(this).val(ui.item.label);
            note.addInvestigation(new Investigation({id: ui.item.value, label: ui.item.label}));
            jq('#investigation').val('');
            jq('#task-investigation').show();
        },
        open: function() {
            jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
        },
        close: function() {
            jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
        }
    });

    jq(".symptoms-qualifiers").on("click", "span.show-qualifiers", function(){
        console.log("Clicked");
        var qualifierContainer = jq(this).parents(".symptom-container").find(".qualifier-container");
        var icon = jq(this).find("i");
        qualifierContainer.toggle();
        if (qualifierContainer.is(":visible")) {
            icon.removeClass("icon-caret-down").addClass("icon-caret-up");
        } else {
            icon.removeClass("icon-caret-up").addClass("icon-caret-down");
        }
    });

    jq(".submitButton").on("click", function(event){
        event.preventDefault();
        jq.ajax({
          type: 'POST',
          url: '${ ui.actionLink("patientdashboardapp", "clinicalNoteProcessor", "processNote", [ successUrl: successUrl ]) }',
          data :{ note: ko.toJSON(note, ["label", "id", "admitted", "diagnosisProvisional","diagnoses", "illnessHistory", "inpatientWarads", "investigations", "opdId", "opdLogId", "otherInstructions", "patientId", "procedures", "queueId", "signs", "referredTo", "outcome", "admitTo", "followUp","option"]) },
          success: function (data, status, xhr) {
              var redirectUrl = xhr.getResponseHeader('Location');
              console.log(xhr.getAllResponseHeaders());
              console.log(redirectUrl);
              window.location.href = '${ui.pageLink("patientqueueui", "queue", [app: "patientdashboardapp.opdqueue"])}';
          }
        });
    });

    jq(".cancel").on("click", function(e){
        e.preventDefault();
    });
});

var prescription = {}

jq(function(){
	jq("#notes-form").on('focus', '#follow-up-date', function () {
		jq(this).datetimepicker({
		  minView: 2,
		  autoclose: true,
		  pickerPosition: "bottom-left",
		  todayHighlight: false,
		  startDate: "+0d",
		  format: "dd/mm/yyyy"});
	});

	var prescriptionDialog = emr.setupConfirmationDialog({
	    selector: '#prescription-dialog',
	    actions: {
		    confirm: function() {
				note.addPrescription(prescription.drug());
				console.log("This is the prescription object:");
				console.log(prescription);
				prescription.drug(new Drug());
				prescriptionDialog.close();
			},
			cancel: function() {
				prescription.drug(new Drug());
				prescriptionDialog.close();
			}
	    }
	});

	jq("#add-prescription").on("click", function(e){
		e.preventDefault();

	    prescriptionDialog.show();
	});

	jq(".drug-name").on("focus.autocomplete", function () {
	      var selectedInput = this;
	      jq(this).autocomplete({
	        source: function( request, response ) {
	          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDrugs") }',
	            {
	              q: request.term
	            }
	          ).success(function(data) {
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
	          event.preventDefault();
	          jq(selectedInput).val(ui.item.label);
	        },
	        change: function (event, ui) {
	          event.preventDefault();
	          jq(selectedInput).val(ui.item.label);
	          console.log(ui.item.label);
	          jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getFormulationByDrugName") }',
	            {
	              "drugName": ui.item.label
	            }
	          ).success(function(data) {
	            var formulations = jq.map(data, function (formulation) {
                    console.log(formulation);
	              return new Formulation({ id: formulation.id, label: formulation.name});
	            });
	            prescription.drug().formulationOpts(formulations);
	          });

              //fetch the frequenciesui.
              jq.getJSON('${ui.actionLink("patientdashboardapp","ClinicalNotes","getFrequencies")}').success(function(data){
                   console.log(data);
                  var frequency = jq.map(data, function (frequency) {
                      return new Frequency({id: frequency.id, label: frequency.name});
                  });
                  prescription.drug().frequencyOpts(frequency);
                });

	        },
	        open: function() {
	          jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
	        },
	        close: function() {
	          jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
	        }
	    });
	});
});
</script>

<style>
	.tasks {
		background: white none repeat scroll 0 0;
		border: 1px solid #cdd3d7;
		border-radius: 4px;
		box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
		color: #404040;
		font: 14px/20px "Lucida Grande",Verdana,sans-serif;
		margin: 10px 0 0 4px;
		width: 98.6%;
	}

	.tasks-header {
	  position: relative;
	  line-height: 24px;
	  padding: 7px 15px;
	  color: #5d6b6c;
	  text-shadow: 0 1px rgba(255, 255, 255, 0.7);
	  background: #f0f1f2;
	  border-bottom: 1px solid #d1d1d1;
	  border-radius: 3px 3px 0 0;
	  background-image: -webkit-linear-gradient(top, #f5f7fd, #e6eaec);
	  background-image: -moz-linear-gradient(top, #f5f7fd, #e6eaec);
	  background-image: -o-linear-gradient(top, #f5f7fd, #e6eaec);
	  background-image: linear-gradient(to bottom, #f5f7fd, #e6eaec);
	  -webkit-box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
	  box-shadow: inset 0 1px rgba(255, 255, 255, 0.5), 0 1px rgba(0, 0, 0, 0.03);
	}

	.tasks-title {
	  line-height: inherit;
	  font-size: 14px;
	  font-weight: bold;
	  color: inherit;
	}

	.tasks-lists {
	  position: absolute;
	  top: 50%;
	  right: 10px;
	  margin-top: -11px;
	  padding: 10px 4px;
	  width: 19px;
	  height: 3px;
	  font: 0/0 serif;
	  text-shadow: none;
	  color: transparent;
	}
	.tasks-lists:before {
	  content: '';
	  display: block;
	  height: 3px;
	  background: #8c959d;
	  border-radius: 1px;
	  -webkit-box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
	  box-shadow: 0 6px #8c959d, 0 -6px #8c959d;
	}
	.tasks-list{
	  font: 13px/20px 'Lucida Grande', Verdana, sans-serif;
	  
	}
	.tasks-list-item {
		display: inline-block;
		line-height: 24px;
		padding: 5px 5px;
		margin-right: 20px;
		cursor: pointer;
		-webkit-user-select: none;
		-moz-user-select: none;
		-ms-user-select: none;
		user-select: none;
		border-bottom: 1px solid #aaa;
		width: 150px;
	}

	.tasks-list-cb {
	  display: none;
	}

	.tasks-list-mark {
	  position: relative;
	  display: inline-block;
	  vertical-align: top;
	  margin-right: 0px;
	  width: 20px;
	  height: 20px;
	  border: 2px solid #c4cbd2;
	  border-radius: 12px;
	}
	.tasks-list-mark:before {
	  content: '';
	  display: none;
	  position: absolute;
	  top: 50%;
	  left: 50%;
	  margin: -5px 0 0 -6px;
	  height: 4px;
	  width: 8px;
	  border: solid #39ca74;
	  border-width: 0 0 4px 4px;
	  -webkit-transform: rotate(-45deg);
	  -moz-transform: rotate(-45deg);
	  -ms-transform: rotate(-45deg);
	  -o-transform: rotate(-45deg);
	  transform: rotate(-45deg);
	}
	.tasks-list-cb:checked ~ .tasks-list-mark {
	  border-color: #39ca74;
	}
	.tasks-list-cb:checked ~ .tasks-list-mark:before {
	  display: block;
	}

	.tasks-list-desc {
	  font-weight: bold;
	  color: #555;
	}
	.tasks-list-cb:checked ~ .tasks-list-desc {
	  color: #34bf6e;
	}
	.tasks-list input[type="radio"] {
	   position: absolute!important;
	   top: -9999px!important;
	   left: -9999px!important;
	}
	#provisional-diagnosis:focus ~#ts01{
		border-bottom: 2px solid #f00!important;
	}
    .symptom-container, 
	.diagnosis-container, 
	.procedure-container, 
	.investigation-container {
        border-top: 1px solid darkgrey!important;
        margin: 8px;
    }
	.symptom-label span{
		padding-left: 10px;
	}
    .diagnosis-container p,
    .investigation-container p,
    .procedure-container p {
        margin: -5px 10px -10px !important;
    }
    .right {
		padding-left: 0 !important;
        padding-right: 5px;
        padding-top: 3px;
    }
	.simple-form-ui section {
	   width: 74%;
	}
	.dialog input {
		display: block;
		margin: 5px 0;
		color: #363463;
		padding: 5px 0 5px 10px;
		background-color: #FFF;
		border: 1px solid #DDD;
		width: 97%;
	}
	.symptom-container, .diagnosis-container, .procedure-container, .investigation-container {
		border-top: darkgrey dashed 1px;
		margin-top: 8px;
	}
	.qualifier-container {
		background-color: white;
		border-top: 5px solid #404040;
		margin-left: 0;
		margin-top: 5px;
		padding: 5px 0 5px 25px;
	}
	.qualifier-container p.qualifier-field label, .outcomes-container p.outcome {
		font-size: .95em;
		line-height: 19px;
	}
	.qualifier-option {
		margin-bottom: 10px;
	}
	.pointer :hover {
		cursor: pointer;
	}
	.qualifier li{
		border-bottom: 1px solid #eee;
		margin-bottom: 5px;
	}
	.dialog select option {
		font-size: 1em;
	}
	#modal-overlay{
		background: #000 none repeat scroll 0 0;
		opacity: 0.4!important;
	}
</style>

<div id="content">
<form method="post" id="notes-form" class="simple-form-ui">
    <section>
        <span class="title">Clinical Notes</span>
        <fieldset class="no-confirmation">
            <legend>Illness History</legend>
            <p>
                <label for="history">History of Presenting illness</label>
                <textarea data-bind="value: \$root.illnessHistory" id="history" name="history" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
		
		
        <fieldset class="no-confirmation">
            <legend>Symptoms</legend>
                <p class="input-position-class">
                    <label for="symptom">Symptom</label>
                    <input type="text" id="symptom" name="symptom" placeholder="Add Symptoms" />
                </p>

                <div class="tasks" id="task-symptom" style="display:none;">
					<header class="tasks-header">
						<span id="title-symptom" class="tasks-title">PATIENT'S SYMPTOMS</span>
						<a class="tasks-lists"></a>
					</header>
					
					<div class="symptoms-qualifiers" data-bind="foreach: signs" >
						<div class="symptom-container">
							<div class="symptom-label">
								<span class="right pointer show-qualifiers"><i class="icon-caret-down small" title="more"></i></span>
								<span class="right pointer" data-bind="click: \$root.removeSign"><i class="icon-remove small"></i></span>
								<span data-bind="text: label"></span>
							</div>
							
							<div class="qualifier-container" style="display: none;">
								<ul class="qualifier" data-bind="foreach: qualifiers">
									<li>
										<span data-bind="text: label"></span>
										<div data-bind="if: options().length >= 1">
											<div data-bind="foreach: options" class="qualifier-option">
												<p class="qualifier-field">
													<input type="radio" data-bind="checkedValue: \$data, checked: \$parent.answer" >
													<label data-bind="text: label"></label>
												</p>
											</div>
										</div>
										<div data-bind="if: options().length === 0" >
											<p>
												<input type="text" data-bind="value: \$parent.freeText" >
											</p>
										</div>
									</li>
								</ul>
							</div> 
						</div>
					</div>
				</div>
        </fieldset>
		
		
        <fieldset class="no-confirmation">
            <legend>Physical Examination</legend>
            <p class="input-position-class">
                <label>Physical Examination</label>
                <textarea data-bind="value: \$root.physicalExamination" id="examination" name="examination" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Diagnosis</legend>
            <div>
				<h2>Patient's Diagnosis</h2>
				<div class="tasks-list">
					<p class="left">
						<label id="ts01" class="tasks-list-item" for="provisional-diagnosis">
							
							<input type="radio" name="diagnosis_type" id="provisional-diagnosis" value="true" data-bind="checked: diagnosisProvisional" class="tasks-list-cb focused"/>
							
							<span class="tasks-list-mark"></span>
							<span class="tasks-list-desc">Provisional</span>
						</label>
					</p>
					
					<p class="left">
						<label class="tasks-list-item" for="final-diagnosis">
							<input type="radio" name="diagnosis_type" id="final-diagnosis" value="false" data-bind="checked: diagnosisProvisional" class="tasks-list-cb"/>
							<span class="tasks-list-mark"></span>
							<span class="tasks-list-desc">Final</span>
						</label>
					</p>
				</div>

                <div>
                    <p class="input-position-class">
                        <input type="text" id="diagnosis" name="diagnosis" placeholder="Select Diagnosis" />
                    </p>
					
					<div id="task-diagnosis" class="tasks" style="display:none;">
						<header class="tasks-header">
							<span id="title-diagnosis" class="tasks-title">DIAGNOSIS</span>
							<a class="tasks-lists"></a>
						</header>
						
						<div id="diagnosis-carrier" data-bind="foreach: diagnoses" style="margin-top: -2px">
							<div class="diagnosis-container">
								<span class="right pointer" data-bind="click: \$root.removeDiagnosis"><i class="icon-remove small"></i></span>
								<p data-bind="text: label"></p>
							</div>
						</div>
					</div>
					
                    
                </div>
            </div>
        </fieldset>
		
        <fieldset class="no-confirmation">
            <legend>Procedures</legend>
            <div>
				<h2>Patient Procedures</h2>
                <p class="input-position-class">
                    <input type="text" id="procedure" name="procedure" placeholder="Specify a Procedure" />
                </p>
				
				<div id="task-procedure" class="tasks" style="display:none;">
					<header class="tasks-header">
						<span id="title-procedure" class="tasks-title">PROCEDURES</span>
						<a class="tasks-lists"></a>
					</header>
					
					<div data-bind="foreach: procedures">
						<div class="procedure-container">
							<span class="right pointer" data-bind="click: \$root.removeProcedure"><i class="icon-remove small"></i></span>
							<p data-bind="text: label"></p>
							<span data-bind="if: schedulable">Schedule:<input type="date"></span>
						</div>
					</div>
				</div>
                
            </div>
        </fieldset>
		
        <fieldset class="no-confirmation">
            <legend>Investigations</legend>
            <div>
                <p class="input-position-class">
                    <label for="investigation">Investigation:</label>
                    <input type="text" id="investigation" name="investigation" />
                </p>
				
				<div id="task-investigation" class="tasks" style="display:none;">
					<header class="tasks-header">
						<span id="title-investigation" class="tasks-title">INVESTIGATION</span>
						<a class="tasks-lists"></a>
					</header>
					
					<div data-bind="foreach: investigations">
						<div class="investigation-container">
							<span class="right pointer" data-bind="click: \$root.removeInvestigation"><i class="icon-remove small"></i></span>
							<p data-bind="text: label"></p>
						</div>
					</div>
				</div>
            </div>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Prescription</legend>
            <div>
                <div style="display:none">
                    <p><input type="text" ></p>
                </div>
                <h2>Prescribe Medicine</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Drug Name</th>
                            <th>Formulation</th>
                            <th>Frequency</th>
                            <th>Number of Days</th>
                            <th>Comments</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody data-bind="foreach: drugs">
                        <tr>
                            <td data-bind="text: name"></td>
                            <td data-bind="text: formulation().label"></td>
                            <td data-bind="text: frequency().label"></td>
                            <td data-bind="text: numberOfDays"></td>
                            <td data-bind="text: comment"></td>
                            <td>
                                <a href="#" title="Remove"><i data-bind="click: \$root.removePrescription" class="icon-remove small"></i></a>
                                <!-- <a href="#"><i class="icon-edit small"></i></a> -->
                            </td>
                        </tr>
                    </tbody>
                </table>
                <br/>
                <button id="add-prescription">Add</button>
            </div>
        </fieldset>
		
		
        <fieldset class="no-confirmation">
            <legend>Other Instructions</legend>
            <p class="input-position-class">
                <label>Other Instructions</label>
				<textarea data-bind="value: \$root.otherInstructions" id="instructions" name="instructions" rows="10" cols="74"></textarea>
            </p>
        </fieldset>
        <fieldset class="no-confirmation">
            <legend>Outcome</legend>
            <div>
                <h2> Patient Referral</h2>
				<div class="onerow">
					<div class="col4"><label for="internalReferral">Internal Referral</label></div>
					<div class="col4"><label for="externalReferral">External Referral</label></div>
					<div class="col4 last">&nbsp;</div>
				</div>
				
				<div class="onerow">
					<div class="col4">
						<p class="input-position-class">
							<select id="internalReferral" name="internalReferral" data-bind="options: \$root.internalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
							</select>
						</p>
					</div>
					
					<div class="col4">
						<p class="input-position-class">
							<select id="externalReferral" name="externalReferral" data-bind="options: \$root.externalReferralOptions, optionsText: 'label', value: \$root.referredTo, optionsCaption: 'Please select...'">
							</select>
						</p>
					</div>
					<div class="col4 last">&nbsp;</div>
				</div>
            </div> <br/> <br/> <br/>
			
			
            <div>
                <h2>What is the outcome of this visit?</h2>
				
                <div data-bind="foreach: availableOutcomes" class="outcomes-container">
                    <div data-bind="if: !(\$root.admitted !== false && \$data.id !== 2)">
                        <p class="outcome">
                            <input type="radio" name="outcome" data-bind="click: updateOutcome" >
                            <label data-bind="text: option.label"></label>
                            <span data-bind="if: \$data.option.id === 1 && \$root.outcome() && \$root.outcome().option.id === 1">
                                <span id="follow-up-date" class="date">
                                    <input data-bind="value : followUp" >
                                    <span class="add-on"><i class="icon-calendar small"></i></span>
                                </span>
                            </span>
                            <span data-bind="if: \$data.option.id === 2 && \$root.outcome() && \$root.outcome().option.id === 2">
                                <select data-bind="options: \$root.inpatientWards, optionsText: 'label', value: admitTo" ></select>
                            </span>
                        </p>
                    </div>
                </div>
            </div>
        </fieldset>
    </section>
    <div id="confirmation" style="width:74.6%; min-height: 400px;">
        <span id="confirmation_label" class="title">Confirmation</span>
        <div class="before-dataCanvas"></div>
        <div id="dataCanvas"></div>
        <div class="after-data-canvas"></div>
        <div id="confirmationQuestion">
            &nbsp; &nbsp; Confirm Posting Information?<br/><br/>
            <p style="display: inline">
                <button class="submitButton confirm" style="float: right">Submit</button>
            </p>
            <p style="display: inline">
                <button class="cancel">Cancel</button>
            </p>
        </div>
    </div>
</form>
</div>

<div id="prescription-dialog" class="dialog">
    <div class="dialog-header">
      <i class="icon-folder-open"></i>
      <h3>Prescription</h3>
    </div>
    <div class="dialog-content">
        <ul>
            <li>
                <span>Drug</span>
                <input class="drug-name" type="text" data-bind="value: prescription.drug().name, valueUpdate: 'blur'" >
            </li>
            <li>
                <span>Formulation</span>
                <select data-bind="options: prescription.drug().formulationOpts, value: prescription.drug().formulation, optionsText: 'label',  optionsCaption: 'Select Formulation'"></select>
            </li>
            <li>
                <span>Frequency</span>
                <select data-bind="options: prescription.drug().frequencyOpts, value: prescription.drug().frequency, optionsText: 'label',  optionsCaption: 'Select Frequency'"></select>
            </li>
            <li>
                <span>Number of Days</span>
                <input type="text" data-bind="value: prescription.drug().numberOfDays" >
            </li>
            <li>
                <span>Comment</span>
                <textarea data-bind="value: prescription.drug().comment"></textarea>
            </li>
        </ul>
       
        <span class="button confirm right"> Confirm </span>
        <span class="button cancel"> Cancel </span>
    </div>
</div>

<script>
	var prescription = {drug: ko.observable(new Drug())};
	ko.applyBindings(prescription, jq("#prescription-dialog")[0]);
</script>