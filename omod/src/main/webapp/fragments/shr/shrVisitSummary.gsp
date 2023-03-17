<%
    ui.includeCss("kenyaemr", "referenceapplication.css", 100)
%>
<div>
    <div class="clear"></div>
    <div class="container">
        <div id="content" class="container">
            <div class="dashboard clear">
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
                                <p>No vitals recorded found</p>
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
                                <p>No vitals conditions found</p>
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
                                           <% } %>
                                       </table>
                                        </fieldset>
                                    <td>
                            <% } else { %>
                                <p>No vitals investigations found</p>
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
                                    <p>No vitals diagnosis found</p>
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
                                <p>No vitals appointments found</p>
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
                                    <p>No vitals procedures found</p>
                                <%}%>
                        </tr>
                    </table>

            </div>
        </div>
    </div>
</div>
