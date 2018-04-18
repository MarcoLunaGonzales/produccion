<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    
    <html>
        <head>
            <title></title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
             <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function validar(){
                   var compronenteProd=document.getElementById('form1:compronenteProd');                  
                   if(compronenteProd.value==''){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     compronenteProd.focus();
                     return false;
                   }                   
                   return true;
                }
            </script>
        </head>
        <body >
            <h:form id="form1"  >
                
                <div align="center">
                    <br><br>
                    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Editar Programa Producción Desarrollo" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Formula Maestra"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  disabled="true" styleClass="inputText" value="#{ManagedProgramaProduccionDesarrollo.programaProduccionbean.formulaMaestra.codFormulaMaestra}">
                            <f:selectItems value="#{ManagedProgramaProduccionDesarrollo.formulaMaestraList}"/>
                        </h:selectOneMenu>
                        
                        
                        <h:outputText  styleClass="outputText2" value="Fecha Inicio"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionbean.fechaInicio}"   id="f_inicio" >
                                
                            </h:inputText>
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinicio" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_inicio\" click_element_id=\"form1:imagenFinicio\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <h:outputText  styleClass="outputText2" value="Fecha Final"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccion.programaProduccionbean.fechaFinal}"  id="f_final">
                                
                            </h:inputText>  
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinal" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_final\" click_element_id=\"form1:imagenFinal\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <h:outputText  styleClass="outputText2" value="Nro Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.codLoteProduccion}" id="cantidad"  />
                        
                        <h:outputText  styleClass="outputText2" value="Observación"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" value="#{ManagedProgramaProduccion.programaProduccionbean.observacion}" id="obs"  />
                        
                    </h:panelGrid>
                    
                    <br>
                    <b> Materia Prima </b>
                    <br>
                    
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraMPList}" var="data" id="dataFormulaMP" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    <b> Empaque Primario </b>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraEPList}" var="data" id="dataFormulaEP" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    <br>
                    <b> Empaque Secundario </b>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraESList}" var="data" id="dataFormulaES" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                        
                    </rich:dataTable>
                    <br>
                    <b> Material Promocional </b>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccion.formulaMaestraMPROMList}" var="data" id="dataFormulaMPROM" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}"  />
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedProgramaProduccion.guardarEditarProgramaProduccion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccion.Cancelar}"/>
                    
                </div>
                
                
            </h:form>
        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

