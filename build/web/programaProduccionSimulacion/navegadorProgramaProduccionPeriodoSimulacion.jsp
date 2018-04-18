
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
    <script>
              
            </script>
</head>
<body >
    
    <div  align="center" id="panelCenter">
        <a4j:form id="form1"  >
        
        <h:outputText value="#{ManagedProgramaProduccionSimulacion.cargarProgramaProduccionPeriodoList}"  />
        <h:outputText styleClass="outputTextTituloSistema"  value="Simulación de Programas de Producción " />                    
        
        <br>
        
        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoList}" var="data" 
                        id="dataProgramaProduccionPeriodo" 
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                        headerClass="headerClassACliente"
                        binding="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoDataTable}" >
                
                <f:facet name="header">
                    <rich:columnGroup>
                        <rich:column>
                            <h:outputText value=""/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="Nombre Programa Producción"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="Observación"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="Estado"/>
                        </rich:column>
                    </rich:columnGroup>
                </f:facet>
                
                <rich:column>
                    <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{data.cantProgramaProduccionPeriodoSolicitudCompra eq 0}"/>
                </rich:column>
                <rich:column>
                    <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.seleccionarProgramaProduccionPeriodo_action}" oncomplete="window.location.href='navegadorProgramaProduccionSimulacion.jsf?data='+(new Date()).getTime().toString();">
                        <h:outputText value="#{data.nombreProgramaProduccion}"/>
                    </a4j:commandLink>
                </rich:column>
                <rich:column>
                    <h:outputText value="#{data.obsProgramaProduccion}"/>
                </rich:column>
                <rich:column>
                    <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"/>
                </rich:column>
                <rich:column>
                    <a4j:commandLink action="#{ManagedProgramaProduccionSimulacion.seleccionarProgramaProduccionPeriodoClonar_action}"
                                     oncomplete="Richfaces.showModalPanel('panelClonarProgramaProduccion')" reRender="contenidoClonarProgramaProduccion">
                        <h:graphicImage value="../edit.jpg"/>
                    </a4j:commandLink>
                </rich:column>
        </rich:dataTable>
        <a4j:commandButton styleClass="btn" value="Agregar " oncomplete="window.location.href='agregarProgramaProduccionPeriodo.jsf?add='+(new Date()).getTime().toString();"/>
        <a4j:commandButton styleClass="btn" value="Editar" action="#{ManagedProgramaProduccionSimulacion.editarProgramaProduccionPeriodo_action}"
                           onclick="if(!editarItem('form1:dataProgramaProduccionPeriodo')){return false}"
                           oncomplete="window.location.href='editarProgramaProduccionPeriodo.jsf?data='+(new Date()).getTime().toString()"/>
        <a4j:commandButton styleClass="btn" value="Eliminar" action="#{ManagedProgramaProduccionSimulacion.eliminarProgramaProduccionPeriodo_action}"
                           reRender="dataProgramaProduccionPeriodo"
                           onclick="if(!editarItem('form1:dataProgramaProduccionPeriodo')){return false}"
                           oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje eq '1'}){alert('Se elimino el programa de produccion periodo');}else{alert('#{ManagedProgramaProduccionSimulacion.mensaje}');}"/>

        
        
    </div>
    </a4j:form>
    <rich:modalPanel id="panelClonarProgramaProduccion" minHeight="140"  minWidth="300"
                        height="260" width="540"
                        zindex="4"
                        headerClass="headerClassACliente"
                        resizeable="false" style="overflow :auto" >
           <f:facet name="header">
               <h:outputText value="<center>Clonar Programa</center>" escape="false"/>
           </f:facet>
           <a4j:form id="formRegistrar">
           <h:panelGroup id="contenidoClonarProgramaProduccion">
               <div align="center">
               <h:panelGrid columns="3">
                    <h:outputText value="Programa" styleClass="outputTextBold"/>
                    <h:outputText value="::" styleClass="outputTextBold"/>
                    <h:outputText value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoClonar.nombreProgramaProduccion}" styleClass="outputText2"  />
                </h:panelGrid>
                <rich:panel headerClass="headerClassACliente">
                    <f:facet name="header">
                        <h:outputText value="Datos Nuevo Programa"/>
                    </f:facet>
                    <h:panelGrid columns="3">
                        <h:outputText value="Nombre" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputText value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoClonarNuevo.nombreProgramaProduccion}" styleClass="inputText"/>
                        <h:outputText value="Observación" styleClass="outputTextBold"/>
                        <h:outputText value="::" styleClass="outputTextBold"/>
                        <h:inputTextarea value="#{ManagedProgramaProduccionSimulacion.programaProduccionPeriodoClonarNuevo.nombreProgramaProduccion}" styleClass="inputText">
                        </h:inputTextarea>
                    </h:panelGrid>
                </rich:panel>

                   <a4j:commandButton styleClass="btn" action="#{ManagedProgramaProduccionSimulacion.guardarClonarProgramaProduccionPeriodo_action}" 
                                      value="Guardar" oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje eq '1'}){alert('Se clono el programa de producción');Richfaces.hideModalPanel('panelClonarProgramaProduccion');}else{alert('#{ManagedProgramaProduccionSimulacion.mensaje}');}"/>
                   <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelBuscarCertificado')" class="btn" />
                   </div>
           </h:panelGroup>
           </a4j:form>
    </rich:modalPanel>

    <a4j:status id="statusPeticion"
                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
     </a4j:status>

    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                     minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

        <div align="center">
            <h:graphicImage value="../img/load2.gif" />
        </div>
    </rich:modalPanel>
</body>
</html>

</f:view>

