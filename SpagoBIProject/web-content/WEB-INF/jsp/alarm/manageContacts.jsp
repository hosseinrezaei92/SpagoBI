<%--
SpagoBI - The Business Intelligence Free Platform

Copyright (C) 2005-2008 Engineering Ingegneria Informatica S.p.A.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--%>

<%@ include file="/WEB-INF/jsp/commons/portlet_base311.jsp"%>
<%@ page import="java.util.ArrayList,
				 java.util.List" %>
<%

	List resourcesList = (List) aSessionContainer.getAttribute("RESOURCES_LIST");

%>

<script type="text/javascript">
<%
String resourcesJSON ="{}";
if(resourcesList != null){
	resourcesJSON="[";
	for(int i=0; i< resourcesList.size(); i++){
		String res = (String)resourcesList.get(i);
		resourcesJSON+="['"+res+"']";
		if(i != (resourcesList.size()-1)){
			resourcesJSON+=",";
		}
	}
	resourcesJSON+="]";
}
%>
	var config=<%= resourcesJSON%>;
	var url = {
    	host: '<%= request.getServerName()%>'
    	, port: '<%= request.getServerPort()%>'
    	, contextPath: '<%= request.getContextPath().startsWith("/")||request.getContextPath().startsWith("\\")?
    	   				  request.getContextPath().substring(1):
    	   				  request.getContextPath()%>'
    	    
    };

    Sbi.config.serviceRegistry = new Sbi.service.ServiceRegistry({
    	baseUrl: url
    });
   Ext.onReady(function(){
	Ext.QuickTips.init();
	var manageContacts = new Sbi.alarm.ManageContacts(config);
	var viewport = new Ext.Viewport({
		layout: 'border'
		, items: [
		    {
		       region: 'center',
		       items: [manageContacts]
		    }
		]

	});
   	
	});

</script>


<%@ include file="/WEB-INF/jsp/commons/footer.jsp"%>