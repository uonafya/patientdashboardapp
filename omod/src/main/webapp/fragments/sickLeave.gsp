<script type="text/javascript">
      var jq = jQuery;
          jq(function () {

              jq('#submitSickOff').on( 'click',function () {
                  saveSickOff();
              });

              jq('#resetSickOff').on( 'click',function () {
                  location.reload();
              });
             var tbl =  jq("#sickOffTbl").DataTable({
                 searchPanes: true,
                 searching: true,
                 "pagingType": 'simple_numbers',
                 'dom': 'flrtip',
                 "oLanguage": {
                     "oPaginate": {
                         "sNext": '<i class="fa fa-chevron-right py-1" ></i>',
                         "sPrevious": '<i class="fa fa-chevron-left py-1" ></i>'
                     }
                 }
             });

              jq('#sickOffTbl tbody').on( 'click', 'tr', function () {
                        var trData = tbl.row(this).data();
                  ui.navigate('initialpatientqueueapp', 'sickOffDetailsForPatient', {sickOffId:trData[0]});
              });
          });
          function saveSickOff() {
                  jq.getJSON('${ ui.actionLink("initialpatientqueueapp", "scheduleAppointment", "saveSickOff") }', {
                      patientId:jq("#patientId").val(),
                      provider: jq("#provider").val(),
                      sickOffStartDate: jq("#sickOffStartDate").val(),
                      sickOffEndDate: jq("#sickOffEndDate").val(),
                      clinicianNotes: jq("#clinicianNotes").val(),
                  }).success(function(data) {
                      jq().toastmessage('showSuccessToast', "Patient's Sick leave created successfully");
                      location.reload();
                  });
      }
  </script>
<div class="ke-page-content">
    <input type="hidden" id="patientId" name="patientId" value=${patientId} />
    <div class="ke-panel-frame">
        <div class="ke-panel-heading">Sickness Leave Form</div>
        <div class="ke-panel-content">
            <div class="container">
                    <div class="ke-form-content">
                        <div class="onerow">
                            <div class="col4">
                                <label>Provider</label>
                                <select id="provider" name="provider">
                                    class="required form-combo1">
                                    <option value="">Select provider</option>
                                    <% providerList.each { prod -> %>
                                        <option value="${prod.providerId }">${prod.name}</option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <div class="onerow">
                            <div class="col4">
                                <label>Start Date</label><input type="date" id="sickOffStartDate" name="sickOffStartDate" class="focused">
                            </div>
                            <div class="col4">
                                <label>End Date</label><input type="date" id="sickOffEndDate" name="sickOffEndDate" class="focused">
                            </div>
                        </div>
                        <br />
                        <div class="onerow">
                            <div class="col4">
                                <label>Provider/Facility Notes</label>
                                <field>
                                    <textarea type="text" id="clinicianNotes" name="clinicianNotes"
                                              style="height: 80px; width: 700px;"></textarea>
                                </field>
                            </div>
                        </div>
                    </div>
                    <div class="onerow" style="margin-top: 100px">

                        <button id="submitSickOff" class="confirm" type="submit"
                                style="float:right; display:inline-block; margin-left: 5px;">
                            <span>FINISH</span>
                        </button>

                        <button id="resetSickOff" class="cancel" type="reset" style="float:right; display:inline-block;"/>
                            <span>RESET</span>
                        </button>
                    </div>
                    <div></div>
            </div>
        </div>

    </div>
    <div>
    <br />
    <br />
        <section>
            <div>
                <table border="0" cellpadding="0" cellspacing="0" width="100%" id="sickOffTbl">
                    <thead>
                        <tr>
                            <th>Sick off ID</th>
                            <th>Patient ID</th>
                            <th>Patient Name</th>
                            <th>Authorised Provider</th>
                            <th>Created on</th>
                            <th>Created By</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th style="width:200px">Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (sickOffs.empty) { %>
                            <tr align="center">
                                <td colspan="9">
                                    No records found for specified period
                                </td>
                            </tr>
                        <% } %>
                        <% if (sickOffs) { %>
                            <% sickOffs.each {%>
                                <tr>
                                    <td>${it.sickOffId}</td>
                                    <td>${it.patientIdentifier}</td>
                                    <td>${it.patientName}</td>
                                    <td>${it.provider}</td>
                                    <td>${it.createdOn}</td>
                                    <td>${it.user}</td>
                                    <td>${it.sickOffStartDate}</td>
                                    <td>${it.sickOffEndDate}</td>
                                    <td>${it.notes}</td>
                                </tr>
                            <%}%>
                        <%}%>
                    </tbody>
                </table>
            </div>
        </section>

    </div>
</div>