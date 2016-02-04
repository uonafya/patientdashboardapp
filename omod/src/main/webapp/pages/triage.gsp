<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeCss("uicommons", "datetimepicker.css")
    ui.includeJavascript("patientdashboardapp", "note.js")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
%>

<script>
var NavigatorController;
var emrMessages = {};

emrMessages["numericRangeHigh"] = "value should be less than {0}";
emrMessages["numericRangeLow"] = "value should be more than {0}";

function getFloatValue(source) {
    return isNaN(parseFloat(source)) ? 0 : parseFloat(source);
}

jq(function(){
    NavigatorController = new KeyboardController();

    emrMessages["numericRangeHigh"] = "value should be less than {0}";
    emrMessages["numericRangeLow"] = "value should be more than {0}";

    jq("#height-field,#weight-field").change(function () {
        console.log("Value changed.")
        var height = getFloatValue(jq("#height-field").val())/100;
        var weight = getFloatValue(jq("#weight-field").val());
        var bmi = weight/(height * height);
        console.log("BMI " + bmi);
        jq(".bmi").html(bmi);
    });
});
</script>

${ui.includeFragment("coreapps", "patientHeader", [patient: patient])}

<div id="content">
    <form method="post" id="notes-form" class="simple-form-ui">
        <section>
            <span class="title">Vital Stats</span>
            <fieldset>
                <legend>Vitals</legend>
                <div>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Weight",
                            id:"weight",
                            formFieldName: "weight",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "kg",
                            left: true
                        ])}
                    </p>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Height",
                            id:"height",
                            formFieldName: "height",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "cm",
                            left: true
                        ])}
                    </p>
                    <div style="clear:left"></div>
                    <% if (patient.age >= 18) { %>
                        <p>
                            <label>BMI: <span class="bmi"></span></label>
                        </p>
                    <% } %>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "MUA Circumference",
                            id:"muac",
                            formFieldName: "mua",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "cm",
                            left: false
                        ])}
                    </p>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Chest Circumference",
                            id:"chest-circum",
                            formFieldName: "chest",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "cm",
                            left: false
                        ])}
                    </p>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Abdominal Circumference",
                            id:"abdominal-circum",
                            formFieldName: "abdominal",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "cm",
                            left: false
                        ])}
                    </p>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Temperature ",
                            id:"temperature",
                            formFieldName: "temperature",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            appendToValueDisplayed: "(degree C)",
                            left: false
                        ])}
                    </p>
                    <p>
                        <label>Blood Pressure</label>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "<span>(Systolic B.P)</span>",
                            id:"systolic-bp",
                            formFieldName: "systolic",
                            maxLength: 3,
                            size: 4,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            left: true
                        ])}
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "<span>(Diastolic B.P)</span>",
                            id:"diastolic-bp",
                            formFieldName: "diastolic",
                            maxLength: 3,
                            size: 4,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            left: true
                        ])}
                    </p>
                    <div style="clear:left"></div>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Respiratory Rate",
                            id:"resp-rate",
                            formFieldName: "respiratoryRate",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            left: false
                        ])}
                    </p>
                    <p>
                        ${ ui.includeFragment("uicommons", "field/text", [
                            label: "Pulse Rate",
                            id:"pulse-rate",
                            formFieldName: "pulsRate",
                            maxLength: 7,
                            min: 0,
                            max: 999,
                            classes: ["numeric-range"],
                            left: false
                        ])}
                    </p>
                    <% if (patient.gender == "F")  { %>
                        <p>
                            ${ui.includeFragment("uicommons", "field/datetimepicker", [
                                id: 'datetime',
                                label: 'Last Menstual Period',
                                formFieldName: 'lastMenstrualDate',
                                useTime: false])
                            }
                        </p>
                    <% } %>
                </div>
            </fieldset>
            <fieldset>
                <legend>Blood Group</legend>
                <div>
                    <p>
                        <label>Blood Group</label>
                        <select id="bloodGroup" name="bloodGroup" >
                            <option value="">-Please select-</option>
                            <option value="O">O</option>
                            <option value="A">A</option>
                            <option value="B">B</option>
                            <option value="AB">AB</option>
                            <option value="Not Known">Not Known</option>
                        </select>
                    </p>
                    <p>
                        <label>Rhesus Factor</label>
                        <select id="rhesusFactor" name="rhesusFactor" >
                            <option value="">-Please select-</option>
                            <option value="Positive (+)">Positive (+)</option>
                            <option value="Negative (-)">Negative (-)</option>
                            <option value="Not Known">Not Known</option>
                        </select>
                    </p>
                </div>
            </fieldset>
            <fieldset>
                <legend>PITCT</legend>
                <p class="no-confirmation">
                    <label>PITCT</label>
                    <select id="pitct" name="pitct" style="width: 278px;">
                        <option value="">-Please select-</option>
                        <option value="Reactive">Reactive</option>
                        <option value="Non-Reactive">Non-Reactive</option>
                        <option value="Not Known">Not Known</option>
                    </select>
                </p>
            </fieldset>
            <fieldset>
                <legend>Room to Visit</legend>
                <p>
                    <select id="room-to-visit" name="roomToVisit">
                        <option value="">-Please select-</option>
                        <% listOPD.each { opd -> %>
                            <option value="${opd.answerConcept.id }"
                                <% if (opdId == opd.answerConcept.id)  { %>selected="selected"<% } %>>${opd.answerConcept.name}</option>
                        <% } %>
                    </select>
                </p>
            </fieldset>
        </section>
        <div id="confirmation">
            <span id="confirmation_label" class="title">Confirm</span>
            <div class="before-dataCanvas"></div>
            <div id="dataCanvas"></div>
            <div class="after-data-canvas"></div>
            <div id="confirmationQuestion">
                Are the details correct?
                <p style="display: inline">
                    <input id="submit" type="submit" class="submitButton confirm right" value="YES" />
                </p>
                <p style="display: inline">
                    <input id="cancelSubmission" class="cancel" type="button" value="NO" />
                </p>
            </div>
        </div>
    </form>
</div>

<style>
.simple-form-ui section.focused {
    width: 75%;
}
</style>