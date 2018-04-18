package personalAreaProduccion;



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
            <script type="text/javascript" src="../js/general.js" ></script>
           
           
        </head>
        <%--<body onLoad="window.defaultStatus='Hola, yo soy la barra de estado.';">--%>
            
            <body>
            <a4j:form id="form1">
                <center>
                <rich:panel id="panelCambiar" headerClass="headerClassACliente" style="width:70%">
                     <f:facet name="header">
                            <h:outputText value="Registrar Cambio de Area"
                                          escape="false"   />
                      </f:facet>
                      <h:panelGrid columns="3" border="0" >
                          <h:outputText value="Personal" styleClass="outputText2"/>
                          <h:outputText value="::" styleClass="outputText2"/>
                          <h:outputText value="#{ManagedPersonalAreasProduccion.nuevo.persona.nombrePersonal}" styleClass="outputText2"/>
                          <h:outputText value="Area Actual" styleClass="outputText2"/>
                          <h:outputText value="::" styleClass="outputText2"/>
                          <h:outputText value="#{ManagedPersonalAreasProduccion.nuevo.areaEmpresa.nombreAreaEmpresa}" styleClass="outputText2"/>
                          <h:outputText value="Nueva Area" styleClass="outputText2"/>
                          <h:outputText value="::" styleClass="outputText2"/>
                          <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.codCambio}"  styleClass="inputText">

                                <f:selectItems value="#{ManagedPersonalAreasProduccion.listaAreas}" />
                         </h:selectOneMenu>
                         <h:outputText value="fecha Inicio" styleClass="outputText2"/>
                         <h:outputText value="::" styleClass="outputText2"/>
                         <h:outputText value="#{ManagedPersonalAreasProduccion.fechaRegisto}" styleClass="outputText2" >
                                <f:convertDateTime pattern="dd/MM/yyyy hh:mm:ss"/>
                            </h:outputText>
                            <h:outputText value="Personal Generico" styleClass="outputText2"/>
                            <h:outputText value="::" styleClass="outputText2"/>
                            <h:selectBooleanCheckbox value="#{ManagedPersonalAreasProduccion.nuevo.personalGenerico}" id="coment"/>

                            <h:outputText value="Comentario" styleClass="outputText2"/>
                            <h:outputText value="::" styleClass="outputText2"/>
                            <h:inputTextarea value="#{ManagedPersonalAreasProduccion.comentario}" ></h:inputTextarea>
                      </h:panelGrid>
                      <center><a4j:commandButton value="Guardar" action="#{ManagedPersonalAreasProduccion.actionGuardarCambio}"
                      oncomplete="window.location='navegadorPersonalAreaProduccion.jsf'"
                      styleClass="btn"/>
                      <input type="button" onclick="window.location='navegadorPersonalAreaProduccion.jsf'" value="Cancelar" class="btn">
                    </center>
                </rich:panel>
            </center>

            </a4j:form>
                    
            
        </body>
    </html>
    
</f:view>

