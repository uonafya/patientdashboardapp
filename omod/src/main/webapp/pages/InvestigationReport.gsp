<form id="investigationForm" action="investigationReportPage.htm" method="post">
    <input type="hidden" name="patientId" value="${patientId }"/>
    <table width="100%" >
        <tr valign="top">
            <td width="60%" id="resultContainer">

            </td>
            <td width="30%">
                <div style="overflow: hidden;border: 1px solid #8FABC7; " >
                    <ul class="tree">
                        <% investigations.each { investigation--> %>

                        the test test

                       <% }  %>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
</form>