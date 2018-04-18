<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>
   
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src='../js/general.js' ></script>
    <script type="text/javascript" src='../js/treeComponet.js' ></script> 
</head>
<body>
  <h:form id="form1"  >                
      <h:dataTable value="#{userList}" var="user" styleClass="table-background" headerClass="headers" footerClass="table-footer"
                   rowClasses="table-odd-row, table-even-row" cellspacing="5" cellpadding="5" binding="#{userEditForm.userEditTable}">
         <f:facet name="header">
            <h:outputText value="Edit user information" styleClass="table-header"/>
         </f:facet>
         
         <h:column>
            <f:facet name="header">
               <h:outputText value="First Name"/>
            </f:facet>
            <h:inputText id="inputName" value="#{user.firstName}"/>
         </h:column>
                 
         <h:column>
            <f:facet name="header">
                <h:outputText value="Last Name"/>
            </f:facet>
            <h:inputText value="#{user.lastName}"/>
         </h:column>

         <h:column>
            <f:facet name="header">
                <h:outputText value="Balance"/>
            </f:facet>
            <h:inputText value="#{user.balance}">
                <f:convertNumber type="currency"/>
            </h:inputText>
         </h:column>
         
   
        <h:column>
            <f:facet name="header">
                <h:outputText value="Registered?"/>
            </f:facet>
            <h:outputText value="#{user.registered}"/>
        </h:column>
        
        <h:column>
            <h:commandLink actionListener="#{userEditForm.deleteUser}">
                <h:outputText value="Delete"/>
            </h:commandLink>
        </h:column>
        
        <f:facet name="footer">
            <h:panelGroup>
                <h:commandButton value="Submit"/>
                <h:commandButton value="Reset" type="reset"/>
            </h:panelGroup>
        </f:facet>
    </h:dataTable>
  </h:form>
</body>
</html>
    
</f:view>

