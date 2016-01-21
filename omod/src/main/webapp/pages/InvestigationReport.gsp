<form id="investigationForm" action=""  method="post">
    <input type="hidden" name="patientId" value="${patientId }"/>
    <table width="100%" >
        <tr valign="top">
            <td width="60%" id="resultContainer">

            </td>
            <td width="30%">
                <div style="overflow: hidden;border: 1px solid #8FABC7; " >
                    <ul class="tree">

                        <% nodes.each { node -> %>
                            <li>
                                <% if(node.children==null || node.children==""){ %>
                                     <input type="checkbox"  value="${node.id}"/>
                                     <label>${node.name }</label>
                                     <ul class="tree">
                                         <% node.children.each { leaf -> %>
                                             <li>
                                                <input type="checkbox" name="tests"  value="${leaf.id}"/>
                                                <label>${leaf.name }</label>
                                             </li>
                                         <% }  %>
                                     </ul>
                                <%}else{%>
                                    <input type="checkbox"  name="tests" value="${node.id}"/><label>${node.name }</label>
                                <% } %>
                            </li>
                       <% }  %>
                    </ul>
                </div>
                <div>
                    <select name="date">
                        <option value="all">--All--</option>
                        <option value="recent">--Recent--</option>
                        <% dates.each { date -> %>
                             <option value="${date}">${date }</option>
                        <% } %>
                    </select>
                    <input type="submit" class="ui-button ui-widget ui-state-default ui-corner-all" value="View"/>
                </div>
            </td>
        </tr>
    </table>
</form>