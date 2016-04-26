<%
	def successUrl = ui.pageLink("patientqueueapp", "opdQueue", [app: 'patientdashboardapp.opdqueue'])
%>

<script>
	var jq = jQuery,
		NavigatorController,
		previousNote = JSON.parse('${config.note}'),
		note = new Note(previousNote);

	var getJSON = function(dataToParse) {
		if (typeof dataToParse === "string") {
			return JSON.parse(dataToParse);
		}
		return dataToParse;
	}
	var outcomeOptions = ${
		config.outcomeOptions.collect {
			it.toJson()
		}
	}
	
	var prescription = {}
	var emrMessages = {};

	emrMessages["numericRangeHigh"] = "value should be less than {0}";
	emrMessages["numericRangeLow"] = "value should be more than {0}";
	emrMessages["requiredField"] = "Mandatory Field. Kindly provide details";
	emrMessages["numberField"] = "Value not a number";
	
	note.availableOutcomes = jq.map(outcomeOptions, function(outcomeOption) {
		return new Outcome(outcomeOption);
	});

	function loadExternalReferralCases() {
		jq('#referralReasons').empty();
		note.referralReasonsOptions.removeAll();

		if (jQuery("#externalReferral option:selected").text() === "LEVEL 2" || jQuery("#externalReferral option:selected").text() === "LEVEL 3" || jQuery("#externalReferral option:selected").text() === "LEVEL 4") {
			jQuery("#referralComments").attr("readonly", false);
			jQuery("#referralComments").val("");
			jQuery("#facility").attr("readonly", false);
			jQuery("#facility").val("");
			jQuery("#specify").attr("readonly", false);
			jQuery("#specify").val("");

			<% config.referralReasonsSources.collect { it.toJson() }.each {%>
				note.referralReasonsOptions.push(${it});
			<%}%>
		} else if (jQuery("#externalReferral option:selected").text() === "Please select...") {

			var myOptions = {
				'': 'N/A'
			};
			var mySelect = jQuery('#referralReasons');
			jQuery.each(myOptions, function(val, text) {
				mySelect.append(
					jQuery('<option></option>').val(val).html(text)
				);
			});

			jQuery("#referralComments").val("N/A");
			jQuery("#referralComments").attr("readonly", true);

			jQuery("#facility").val("N/A");
			jQuery("#facility").attr("readonly", true);

			jQuery("#specify").val("N/A");
			jQuery("#specify").attr("readonly", true);
		}
		
		jq('#referralReasons').change();
	}

	note.inpatientWards = ${
		config.listOfWards.collect {
			it.toJson()
		}
	};
	note.internalReferralOptions = ${
		config.internalReferralSources.collect {
			it.toJson()
		}
	};
	note.externalReferralOptions = ${
		config.externalReferralSources.collect {
			it.toJson()
		}
	};

	var mappedSigns = jq.map(getJSON(previousNote.signs), function(sign) {
		return new Sign(sign);
	});
	note.signs(mappedSigns);

	var mappedDiagnoses = jq.map(getJSON(previousNote.diagnoses), function(diagnosis) {
		return new Diagnosis(diagnosis);
	});
	note.diagnoses(mappedDiagnoses);

	// final diagnoses are never returned
	if (mappedDiagnoses.length > 0) {
		note.diagnosisProvisional("true");
	}

	var mappedInvestigations = jq.map(getJSON(previousNote.investigations), function(investigation) {
		return new Investigation(investigation);
	});
	note.investigations(mappedInvestigations);

	var mappedProcedures = jq.map(getJSON(previousNote.procedures), function(procedure) {
		return new Procedure(procedure);
	});
	note.procedures(mappedProcedures);


	jq(function() {
		ko.applyBindings(note, jq("#notes-form")[0]);
		NavigatorController = new KeyboardController();
		
		jq('#referralReasons').change(function(){
			if (jQuery("#referralReasons option:selected").text().trim() === "OTHER REASONS"){
				jq('#specify').show();
				jq('#specify-lbl').show();
			}
			else {
				jq('#specify').hide();
				jq('#specify-lbl').hide();
			}
		}).change();
		
		jq('#availableReferral').change(function(){
			var option = jq('#availableReferral').val();
			var outcom = note.outcome()? note.outcome().option.label : '';
			
			if (option == 1){
				jq('#refTitle').text('Internal Referral');
				jq('#refTitle').show();
				jq('#facTitle').hide();
				
				jq('#facility').hide()
				
				jq('#refReason1').hide();
				jq('#refReason2').hide();
				jq('#refReason3').hide();
				
				jq('#internalReferral').show();
				jq('#externalReferral').hide();

				jq("select#externalReferral")[0].selectedIndex = 0;
			}
			else if (option == 2){
				jq('#refTitle').text('External Referral');
				jq('#refTitle').show();
				jq('#facTitle').show();
				
				jq('#facility').show()
				
				jq('#refReason1').show();
				jq('#refReason2').show();
				jq('#refReason3').show();
				
				jq('#externalReferral').show();
				jq('#internalReferral').hide();
				
				jq("select#internalReferral")[0].selectedIndex = 0;
			}
			else {
				jq('#refTitle').hide();
				jq('#facTitle').hide();
				
				jq('#facility').hide()
				
				jq('#refReason1').hide();
				jq('#refReason2').hide();
				jq('#refReason3').hide();
				
				jq('#externalReferral').hide();
				jq('#internalReferral').hide();
				
				jq("select#internalReferral")[0].selectedIndex = 0;
				jq("select#externalReferral")[0].selectedIndex = 0;				
			}
			
			if (option == 0){
				if (outcom == ''){
					outcom = 'N/A'
				}
			}
			else{
				if (outcom == ''){
					outcom = jq("#availableReferral option:selected").text();
				}
				else{
					outcom += ' ('+jq("#availableReferral option:selected").text()+')';
				}
			}
			
			jq('#summaryTable tr:eq(8) td:eq(1)').text(outcom);
			
		}).change();
		
		jq('.dialog-content input').on('keydown', function(e){
			if (e.keyCode == 9 || e.which == 9) {
				e.preventDefault();
				e.stopImmediatePropagation();
			}
		});
		
		jq('#examination, #history, #instructions').change(function(){
			var idnt = jq(this).attr('id');
			var rows = -1;
			var text = jq(this).val();
			
			if (idnt == 'history'){
				rows = 1;
			}
			else if (idnt == 'examination'){
				rows = 2;
			}
			else if (idnt == 'instructions'){
				rows = 7;
			}
			
			if (text == ''){
				text = 'N/A';
			}
			
			jq('#summaryTable tr:eq('+ rows +') td:eq(1)').text(text);
		});
		
		jq('input[type=radio][name=diagnosis_type]').change(function() {
			if (this.value == 'true') {
				jq('#title-diagnosis').text('PROVISIONAL DIAGNOSIS');
			} else {
				jq('#title-diagnosis').text('FINAL DIAGNOSIS');
				note.diagnoses.removeAll();
				jq('#diagnosis-set').val('');
			}
		});
		
		jq("#symptom").autocomplete({
			source: function(request, response) {
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getSymptoms") }', {
					q: request.term
				}).success(function(data) {
					var results = [];
					for (var i in data) {
						var result = {
							label: data[i].name,
							value: data[i].id
						};
						results.push(result);
					}
					response(results);
				});
			},
			minLength: 3,
			select: function(event, ui) {
				event.preventDefault();
				jq(this).val(ui.item.label);
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getQualifiers") }', {
					signId: ui.item.value
				}).success(function(data) {
					var qualifiers = jq.map(data, function(qualifier) {
						return new Qualifier(qualifier.id, qualifier.label,
							jq.map(qualifier.options, function(option) {
								return new Option(option.id, option.label);
							}));
					});
					note.addSign(new Sign({
						"id": ui.item.value,
						"label": ui.item.label,
						"qualifiers": qualifiers
					}));
					
					jq('#symptom').val('');
					jq('#task-symptom').show();
					jq("#symptoms-set").val("Symptom set");
					jq('#symptoms-lbl').hide();
				});
			},
			open: function() {
				jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function() {
				jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		});

		jq("#diagnosis").autocomplete({
			source: function(request, response) {
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDiagnosis") }', {
					q: request.term
				}).success(function(data) {
					var results = [];
					for (var i in data) {
						var result = {
							label: data[i].name,
							value: data[i].id
						};
						results.push(result);
					}
					response(results);
				});
			},
			minLength: 3,
			select: function(event, ui) {
				event.preventDefault();
				jq(this).val(ui.item.label);
				note.addDiagnosis(new Diagnosis({
					id: ui.item.value,
					label: ui.item.label
				}));
				
				jq("#diagnosis-set").val("Diagnosis set");
				jq("#diagnosis-lbl").hide();
				jq('#diagnosis').focus();
				jq('#diagnosis').val('');
				jq('#task-diagnosis').show();

			},
			open: function() {
				jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function() {
				jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		});

		jq("#procedure").autocomplete({
			source: function(request, response) {
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getProcedures") }', {
					q: request.term
				}).success(function(data) {
					procedureMatches = [];
					for (var i in data) {
						var result = {
							label: data[i].label,
							value: data[i].id,
							schedulable: data[i].schedulable
						};
						procedureMatches.push(result);
					}
					response(procedureMatches);
				});
			},
			minLength: 3,
			select: function(event, ui) {
				event.preventDefault();
				jq(this).val(ui.item.label);
				jq("#procedure-set").val("Procedure set");
				var procedure = procedureMatches.find(function(procedureMatch) {
					return procedureMatch.value === ui.item.value;
				});
				note.addProcedure(new Procedure({
					id: procedure.value,
					label: procedure.label,
					schedulable: procedure.schedulable
				}));
				jq('#procedure').val('');
				jq('#task-procedure').show();
			},
			open: function() {
				jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function() {
				jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		});

		jq("#investigation").autocomplete({
			source: function(request, response) {
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getInvestigations") }', {
					q: request.term
				}).success(function(data) {
					var results = [];
					for (var i in data) {
						var result = {
							label: data[i].name,
							value: data[i].id
						};
						results.push(result);
					}
					response(results);
				});
			},
			minLength: 3,
			select: function(event, ui) {
				event.preventDefault();
				jq(this).val(ui.item.label);
				jq("#investigation-set").val("Investigation set");
				note.addInvestigation(new Investigation({
					id: ui.item.value,
					label: ui.item.label
				}));
				jq('#investigation').val('');
				jq('#task-investigation').show();
			},
			open: function() {
				jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
			},
			close: function() {
				jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
			}
		});

		jq(".symptoms-qualifiers").on("click", "span.show-qualifiers", function() {
			var qualifierContainer = jq(this).parents(".symptom-container").find(".qualifier-container");
			var icon = jq(this).find("i");
			qualifierContainer.toggle();
			if (qualifierContainer.is(":visible")) {
				icon.removeClass("icon-caret-down").addClass("icon-caret-up");
			} else {
				icon.removeClass("icon-caret-up").addClass("icon-caret-down");
			}
		});

		jq(".submitButton").on("click", function(event) {
			if (!jq('input[name="diagnosis_type"]:checked').val()){
				jq().toastmessage('showErrorToast', "Ensure that Provisional or Final Diagnosis has been selected first before you continue!");
				return false
			}
		
			event.preventDefault();
			jq().toastmessage({
				sticky: true
			});
			var savingMessage = jq().toastmessage('showSuccessToast', 'Please wait as Information is being Saved...');
						
			if (note.referralReasons === "") {
				delete note['referralReasons'];
			}
			
			jq.ajax({
					type: 'POST',
					url: '${ ui.actionLink("patientdashboardapp", "clinicalNoteProcessor", "processNote", [ successUrl: successUrl ]) }',
					data: {
						note: ko.toJSON(note, ["label", "id", "admitted", "diagnosisProvisional",
							"diagnoses", "illnessHistory", "referralReasons", "externalReferralComments", "physicalExamination",
							"inpatientWarads", "investigations", "opdId",
							"opdLogId", "otherInstructions", "patientId",
							"procedures", "queueId", "signs", "referredTo",
							"outcome", "admitTo", "followUpDate", "option",
							"drugs", "comment", "externalReferral", "formulation", "specify", "dosage", "drugUnit", "frequency",
							"drugName", "numberOfDays"
						])
					},
					dataType: 'json'
				})
				.done(function(data) {
					jq().toastmessage('removeToast', savingMessage);
					if (data.status == "success") {
						jq().toastmessage('showSuccessToast', 'Data Successfully Posted!');
						window.location.href = '${ui.pageLink("patientqueueapp", "opdQueue", [app: "patientdashboardapp.opdqueue"])}';
					} else if (data.status == "fail") {
						jq().toastmessage('showErrorToast', data.message);
					}
				})
				.fail(function(data) {
					jq().toastmessage('removeToast', savingMessage);
					jq().toastmessage('showErrorToast', "An error occurred while saving. Please contact your system administrator");
				});
		});

		jq(".cancel").on("click", function(e) {
			e.preventDefault();
		});

		jq(".cancel").on("click", function(e) {
			e.preventDefault();
		});

		loadExternalReferralCases();
		
		jq("#notes-form").on('focus', '#follow-up-date', function() {
			jq(this).datetimepicker({
				minView: 2,
				autoclose: true,
				pickerPosition: "bottom-left",
				todayHighlight: false,
				startDate: "+0d",
				format: "dd/mm/yyyy"
			});
		});

		var prescriptionDialog = emr.setupConfirmationDialog({
			selector: '#prescription-dialog',
			actions: {
				confirm: function() {
					note.addPrescription(prescription.drug());
					prescription.drug(new Drug());
					prescriptionDialog.close();
				},
				cancel: function() {
					prescription.drug(new Drug());
					prescriptionDialog.close();
				}
			}
		});
		jq("#add-prescription").on("click", function(e) {
			e.preventDefault();

			prescriptionDialog.show();
		});

		jq(".drug-name").on("focus.autocomplete", function() {
			var selectedInput = this;
			jq(this).autocomplete({
				source: function(request, response) {
					jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getDrugs") }', {
						q: request.term
					}).success(function(data) {
						var results = [];
						for (var i in data) {
							var result = {
								label: data[i].name,
								value: data[i].id
							};
							results.push(result);
						}
						response(results);
					});
				},
				minLength: 3,
				select: function(event, ui) {
					event.preventDefault();
					jq(selectedInput).val(ui.item.label);
				},
				change: function(event, ui) {
					event.preventDefault();
					jq(selectedInput).val(ui.item.label);
					jq("#drug-set").val("Drug set");
					jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getFormulationByDrugName") }', {
						"drugName": ui.item.label
					}).success(function(data) {
						var formulations = jq.map(data, function(formulation) {
							return new Formulation({
								id: formulation.id,
								label: formulation.name + ":" + formulation.dozage
							});
						});
						prescription.drug().formulationOpts(formulations);
					});

					// fetch the frequenciesui.
					jq.getJSON('${ui.actionLink("patientdashboardapp","ClinicalNotes","getFrequencies")}').success(function(data) {
						var frequency = jq.map(data, function(frequency) {
							return new Frequency({
								id: frequency.id,
								label: frequency.name
							});
						});
						prescription.drug().frequencyOpts(frequency);
					});
					jq.getJSON('${ui.actionLink("patientdashboardapp","clinicalNotes","getDrugUnit")}')
						.success(function(data) {
							var drugUnit = jq.map(data, function(drugUnit) {
								return new DrugUnit({
									id: drugUnit.id,
									label: drugUnit.label
								});
							});
							prescription.drug().drugUnitsOptions(drugUnit);
						});

				},
				open: function() {
					jq(this).removeClass("ui-corner-all").addClass("ui-corner-top");
				},
				close: function() {
					jq(this).removeClass("ui-corner-top").addClass("ui-corner-all");
				}

			});
		});

		if (!jq('.symptoms-qualifiers').text().trim() == "") {
			jq('#task-symptom').show();
		}
		
		if (!jq('.diagnosis-container').text().trim() == "") {
			jq('#task-diagnosis').show();
		}
		
		if (note.signs().length > 0){
			jq('#symptoms-set').val('symptoms-set');
		}
		
		if (note.diagnoses().length > 0){
			jq('#diagnosis-set').val('diagnosis-set');
		}
		
		if (note.procedures().length > 0){
			jq('#procedure-set').val('procedure-set');
		}
		
		if (note.investigations().length > 0){
			jq('#investigation-set').val('investigation-set');
		}
		
		if (note.drugs().length > 0){
			jq('#drug-set').val('drug-set');
		}		
	});
</script>
