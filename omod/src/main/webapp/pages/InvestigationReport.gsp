<form id="investigationForm" action="investigationReportPage.htm" method="post">
    <input type="hidden" name="patientId" value="${patientId }"/>
    <table width="100%" >
        <tr valign="top">
            <td width="60%" id="resultContainer">

            </td>
            <td width="30%">
                <div style="overflow: hidden;border: 1px solid #8FABC7; " >
                    <ul class="tree">

                        <% investigations.each { investigation -> %>
                            <li>
                                <% if(investigation.children==null || investigation.children==""){ %>
                                     <input type="checkbox"  value="${investigation.id}"/>
                                     <label>${investigation.name }</label>
                                     <ul class="tree">
                                         <% investigation.children.each { leaf -> %>
                                             <li>
                                                <input type="checkbox" name="tests"  value="${leaf.id}"/>
                                                <label>${leaf.name }</label>
                                             </li>
                                         <% }  %>
                                     </ul>
                                <%}else{%>
                                    <input type="checkbox"  name="tests" value="${investigation.id}"/><label>${investigation.name }</label>
                                <% } %>
                            </li>
                       <% }  %>
                    </ul>
                </div>
            </td>
        </tr>
    </table>
</form>