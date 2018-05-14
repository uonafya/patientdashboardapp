<%
	def successUrl = ui.pageLink("patientqueueapp", "opdQueue", [app: 'patientdashboardapp.opdqueue'])
%>

<script>
	var jq = jQuery,
		NavigatorController,
        drugIdnt = 0,
		previousNote = JSON.parse(jsonEscape('${config.note}')),
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
	emrMessages["requiredField"] = "Ensure details have been filled properly";
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

	function page_verified(){
		var error = 0;

		if (jq(".drug-name").val().trim() == ''){
			jq(".drug-name").addClass('red');
			error ++;
		}
		else {
			jq(".drug-name").removeClass('red');
		}
		
		if (jq(".drug-dosage").val().trim() == ''){
			jq(".drug-dosage").addClass('red');
			error ++;
		}
		else {
			jq(".drug-dosage").removeClass('red');
		}
		
		if (jq('.drug-dosage-unit :selected').text() == "Select Unit"){
			jq(".drug-dosage-unit").addClass('red');
			error ++;
		}
		else {
			jq(".drug-dosage-unit").removeClass('red');
		}
		
		if (jq('.drug-formulation :selected').text() == "Select Formulation"){
			jq(".drug-formulation").addClass('red');
			error ++;
		}
		else {
			jq(".drug-formulation").removeClass('red');
		}
		if (jq('.drug-frequency :selected').text() == "Select Frequency"){
			jq(".drug-frequency").addClass('red');
			error ++;
		}
		else {
			jq(".drug-frequency").removeClass('red');
		}
		if (jq(".drug-number-of-days").val().trim() == '0' || jq(".drug-number-of-days").val().trim() == ''){
			jq(".drug-number-of-days").addClass('red');
			error ++;
		}
		else {
			jq(".drug-number-of-days").removeClass('red');
		}

		if (error == 0){
			return true;
		} else{
			return false;
		}
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

	var mappedInvestigations = jq.map(getJSON(previousNote.investigations), function(investigation) {
		return new Investigation(investigation);
	});
	note.investigations(mappedInvestigations);

	var mappedProcedures = jq.map(getJSON(previousNote.procedures), function(procedure) {
		return new Procedure(procedure);
	});
	note.procedures(mappedProcedures);
	
	function verifyDiagnosis(){
		var anyUnchecked = false;
		
		jq('.diagnosis-container').children('div').each(function () {
			if (jq(this).find('input:checked').length === 0){
				anyUnchecked = true;
				jq("#diagnosis-set").val('');
				return;
			}
		});		
		
		if (note.diagnoses().length > 0 && !anyUnchecked){
			jq("#diagnosis-set").val('SET');
		}
		else{
			jq("#diagnosis-set").val('');		
		}
	}

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
		
		jq('#diagnosis-carrier').on('click', 'input', function(){
			verifyDiagnosis();	
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
							value: data[i].name,
							id: data[i].id,
							uuid: data[i].uuid
						};
						results.push(result);
					}
					var nonCoded = {
						label: "(Non-coded) " + request.term,
						value: "(Non-coded) " + request.term,
						id: afyaehmsConstants.OTHER_SYMPTOM_ID,
						uuid: afyaehmsConstants.OTHER_SYMPTOM_UID
					};
					results.push(nonCoded);
					response(results);
				});
			},
			minLength: 3,
			select: function(event, ui) {
				event.preventDefault();
				jq(this).val(ui.item.label);
				jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getQualifiers") }', {
					signId: ui.item.id
				}).success(function(data) {
					var qualifiers = jq.map(data, function(qualifier) {
						return new Qualifier( qualifier.id,qualifier.label,
							jq.map(qualifier.options, function(option) {
								return new Option( option.id, option.label);
							}));
					});
					
					note.addSign(new Sign({
						"id": ui.item.id,
						"label": ui.item.label.replace(/\\(Non-coded\\) /i, ''),
						"uuid":ui.item.uuid,
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
				
				verifyDiagnosis();
				
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
		
		jq("#diagnosis-carrier").on("click", "inputs", function(){
			var provDiagnosisInput = jq(this).parents(".diagnosis-carrier-div").find(".chk-provisional");
			//
			var chkbox = jq(this).attr('class');			
			if (chkbox == 'chk-provisional'){
				jq(this).parents(".diagnosis-carrier-div").find(".chk-final").prop('checked', false);
			}
			else{
				jq(this).parents(".diagnosis-carrier-div").find(".chk-provisional").prop('checked', false);
			}
		});
		

		jq(".submitButton").on("click", function(event) {
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
						note: ko.toJSON(note, ["label", "id", "admitted","provisional",
							"diagnoses", "illnessHistory", "referralReasons", "externalReferralComments", "physicalExamination",
							"inpatientWarads", "investigations", "opdId",
							"opdLogId", "otherInstructions", "patientId",
							"procedures", "queueId", "signs", "referredTo",
							"outcome", "admitTo", "followUpDate", "option",
							"drugs", "comment", "externalReferral", "formulation", "specify", "dosage", "drugUnit", "frequency",
							"drugName", "numberOfDays", "qualifiers","answer","freeText"
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
			dialogOpts: {
				overlayClose: false,
				close: true
			},
			selector: '#prescription-dialog',
			actions: {
				confirm: function() {
					if (!page_verified()){
						jq().toastmessage('showErrorToast', 'Ensure fields marked in red have been properly filled before you continue')
						return false;
					}

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

            jq('#prescriptionAlert').hide();
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
                    jq('#prescriptionAlert').hide();

                    drugIdnt = ui.item.value;
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
					jq.getJSON('${ui.actionLink("patientdashboardapp","clinicalNotes","getDrugUnit")}').success(function(data) {
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

        jq("#drugFormulation").on("change", function (e) {
            var formulationName = jq('#drugFormulation :selected').text();

            console.log(formulationName);
            console.log(drugIdnt);

            jq.ajax({
                type: "GET"
                , dataType: "json"
                , url: '${ ui.actionLink("pharmacyapp", "issueDrugAccountList", "getReceiptDrugBatchCount") }'
                , data: ({drugId: drugIdnt, name: formulationName})
                , async: false
                , success: function (data) {
                    if (data == 0){
                        jq('#prescriptionAlert').show(100);
                    } else {
                        jq('#prescriptionAlert').hide();
                    }


                },
                error: function (xhr) {
                    //alert("An Error occurred");
                }
            })
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
			verifyDiagnosis();
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
