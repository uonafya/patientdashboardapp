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
note.availableOutcomes = jq.map(outcomeOptions, function(outcomeOption) {
    return new Outcome(outcomeOption);
});

jQuery(document).ready(function() {
    jq('input[type=radio][name=diagnosis_type]').change(function() {
        if (this.value == 'true') {
            jq('#title-diagnosis').text('PROVISIONAL DIAGNOSIS');
        } else {
            if (jq('#title-diagnosis').text() != "DIAGNOSIS") {
                jq('#diagnosis-carrier').html('');
            }

            jq('#title-diagnosis').text('FINAL DIAGNOSIS');
        }
    });
});

function loadExternalReferralCases() {
    jQuery('#referralReasons').empty();
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
            0: 'N/A'
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
}

jQuery(document).ready(function() {

    jq('input[type=radio][name=diagnosis_type]').change(function() {
        if (this.value == 'true') {
            jq('#title-diagnosis').text('PROVISIONAL DIAGNOSIS');
        } else {
            if (jq('#title-diagnosis').text() != "DIAGNOSIS") {
                jq('#diagnosis-carrier').html('');
            }

            jq('#title-diagnosis').text('FINAL DIAGNOSIS');
        }
    });

});

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

    NavigatorController = new KeyboardController();
    ko.applyBindings(note, jq("#notes-form")[0]);
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
                console.log(data);
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

            jq('#diagnosis').val('');
            jq('#diagnosis').focus();
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

    jq(".submitButton").on("click", function(event) {
        event.preventDefault();
        jq().toastmessage({
            sticky: true
        });
        var savingMessage = jq().toastmessage('showNoticeToast', 'Saving...');
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
                    jq().toastmessage('showNoticeToast', 'Saved!');
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

});


var prescription = {}

jq(function() {
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
                console.log(ui.item.label);
                jq.getJSON('${ ui.actionLink("patientdashboardapp", "ClinicalNotes", "getFormulationByDrugName") }', {
                    "drugName": ui.item.label
                }).success(function(data) {
                    var formulations = jq.map(data, function(formulation) {
                        console.log(formulation);
                        return new Formulation({
                            id: formulation.id,
                            label: formulation.name + ":" + formulation.dozage
                        });
                    });
                    prescription.drug().formulationOpts(formulations);
                });

                // fetch the frequenciesui.
                jq.getJSON('${ui.actionLink("patientdashboardapp","ClinicalNotes","getFrequencies")}').success(function(data) {
                    console.log(data);
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
});
</script>
