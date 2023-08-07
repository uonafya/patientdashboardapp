<div>
    <div class="clear"></div>
    <div class="container">
        <div id="content" class="container">
            <div class="dashboard clear">
              <% if(patient) {%>
                  <% if(fhirObs) {%>
                    <fieldset>
                        <legend>Encounter Observations</legend>
                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <% if (vitals) { %>
                                  <td valign="top">
                                    <fieldset>
                                       <legend>Vitals</legend>
                                       <table>
                                           <% vitals.each { it -> %>
                                           <tr>
                                               <td>${it.display}</td>
                                               <td>${it.value}</td>
                                           </tr>
                                           <% } %>
                                       </table>
                                    </fieldset>
                                  <td>
                                 <% } else { %>
                                    <p>No vitals recordeds</p>
                                <%}%>
                                <% if (conditions) { %>
                                  <td valign="top">
                                      <fieldset>
                                         <legend>Conditions</legend>
                                         <table>
                                             <% conditions.each { it -> %>
                                             <tr>
                                                 <td>${it.display}</td>
                                                 <td>${it.value}</td>
                                             </tr>
                                             <% } %>
                                         </table>
                                      </fieldset>
                                  <td>
                               <% } else { %>
                                  <p>No Conditions found</p>
                               <%}%>
                            </tr>
                            <tr>
                                <% if (investigations) { %>
                                  <td valign="top">
                                    <fieldset>
                                       <legend>Investigations</legend>
                                       <table>
                                         <% investigations.each { it -> %>
                                         <tr>
                                             <td>${it.display}</td>
                                             <td>${it.value}</td>
                                         </tr>
                                         <%}%>
                                       </table>
                                    </fieldset>
                                  <td>
                                <% } else { %>
                                    <p>No vitals Investigations</p>
                                <%}%>

                                <% if (diagnosis) { %>
                                    <td valign="top">
                                        <fieldset>
                                           <legend>Diagnosis</legend>
                                           <table>
                                                <% diagnosis.each { it -> %>
                                                  <tr>
                                                      <td>${it.display}</td>
                                                      <td>${it.value}</td>
                                                  </tr>
                                                <% } %>
                                           </table>
                                        </fieldset>
                                    <td>
                                    <% } else { %>
                                        <p>No Diagnosis found</p>
                                <%}%>
                            </tr>
                            <tr>
                                <% if (appointments) { %>
                                  <td valign="top">
                                      <fieldset>
                                         <legend>Appointments</legend>
                                         <table>
                                           <% appointments.each { it -> %>
                                           <tr>
                                               <td>${it.display}</td>
                                               <td>${it.value}</td>
                                           </tr>
                                           <% } %>
                                         </table>
                                      </fieldset>
                                  <td>
                                <% } else { %>
                                    <p>No Appointments scheduled yet</p>
                                <%}%>

                                <% if (procedures) { %>
                                    <td valign="top">
                                        <fieldset>
                                          <legend>Procedures</legend>
                                           <table>
                                                <% procedures.each { it -> %>
                                                <tr>
                                                    <td>${it.display}</td>
                                                    <td>${it.value}</td>
                                                </tr>
                                                <% } %>
                                           </table>
                                        </fieldset>
                                    <td>
                                <% } else { %>
                                    <p>No Procedures ordered yet</p>
                                <%}%>
                            </tr>
                        </table>
                    </fieldset>
                  <%} else {%>
                    <div>
                      <p>No Observations recorded</p>
                    </div>
                  <%}%>
                  <% if(fhirServiceRequest) {%>
                    <div>
                      <p>Service Request raised for this Patient</p>
                    </div>
                  <%} else {%>
                    <div>
                      <p>No Service request raised</p>
                    </div>
                  <%}%>
                  <% if(fhirEncounter) {%>
                  <%} else {%>
                    <div>
                      <p>No Encounters filled</p>
                    </div>
                  <%}%>
              <%}%>
              <%} else {%>
                <div>
                  <p>This patient does NOT have a record on the SHR</p>
                </div>
              <%}%>
            </div>
        </div>
    </div>
</div>
