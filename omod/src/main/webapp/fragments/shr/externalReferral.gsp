
<script type="text/javascript">
  jq(document).ready(function () {
    jq("#healthFacilities").on("focus.autocomplete", function () {
        console.log("we got here though");
      jq(this).autocomplete({
        source: function(request, response) {
          jq.getJSON('${ ui.actionLink("patientdashboardapp", "clinicalNotes", "getLocationByNameOrMflCode") }', {
            referredToFacility: request.term
          }).success(function(data) {
            console.log("data is >>", data);
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
        }
      });
    });
  });
</script>
<div class="ke-page-content">
  <div class="onerow">
    <div class="col3"><label for="healthFacilities">Referred to facility</label></div>
    <div class="col3">
        <input type="text" id="healthFacilities" name="healthFacilities" size="200" />
    </div>
  </div>
  <div class="onerow" id="refReasonCoded">
    <div class="col3"><label for="externalReferralReasonCoded">Referral reasons</label></div>
    <div class="col3">
      <select id="externalReferralReasonCoded" name="externalReferralReasonCoded" style="margin-top: 5px;">
      </select>
    </div>
  </div>
  <div class="onerow" id="externalReferralNotes">
      <div class="col3">
        <label for="externalReferralReasonText" style="margin-top:20px;">Clinical notes</label>
      </div>
      <div class="col3">
        <textarea type="text" id="externalReferralReasonText"   name="externalReferralReasonText" placeholder="Clinical notes"  style="height: 80px; width: 650px;"></textarea>
      </div>
  </div>
</div>