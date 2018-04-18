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
                            <h:outputText value="Editar Programa Producción" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Formula Maestra"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  disabled="true" styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.formulaMaestra.codFormulaMaestra}">    
                            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.formulaMaestraList}"/>
                        </h:selectOneMenu>
                        
                        
                        <%-- h:outputText  styleClass="outputText2" value="Fecha Inicio"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.fechaInicio}"   id="f_inicio" >
                                
                            </h:inputText>
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinicio" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_inicio\" click_element_id=\"form1:imagenFinicio\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <h:outputText  styleClass="outputText2" value="Fecha Final"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.fechaFinal}"  id="f_final">
                                
                            </h:inputText>  
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinal" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_final\" click_element_id=\"form1:imagenFinal\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <%--h:outputText  styleClass="outputText2" value="Nro Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.codLoteProduccion}" id="cantidad"  /


<h:outputText  styleClass="outputText2" value="Cantidad Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.cantidadLote}"
                                     valueChangeListener="#{ManagedProgramaProduccionSimulacion.cantidadLoteProduccion_change}"
                                     id="cant_lote" onkeypress="valNum();" >
                            <a4j:support event="onchange"  reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR"  />
                        </h:inputText>
--%>
                        


                        
                            <h:outputText  styleClass="outputText2" value="Cantidad Lote Produccion"  />
                        <h:outputText styleClass="outputText2" value="::"  />

                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.cantidadLote}"
                                  onkeypress="valNum();"  id="cant_lote" >
                                  <a4j:support action="#{ManagedProgramaProduccionSimulacion.cantidadLoteProduccion_change}"
                                               event="onblur" reRender="cant_lote,dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR"
                                               oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje!=''}){alert('#{ManagedProgramaProduccionSimulacion.mensaje}');document.getElementById('form1:cant_lote').focus()}"
                                  />
                        </h:inputText>

                        <h:outputText  styleClass="outputText2" value="Nro.Lotes a Producir"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.nroLotes}"
                            id="nroLotes" onkeypress="valNum();" readonly="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.formulaMaestra.cantidadLote==ManagedProgramaProduccionSimulacion.programaProduccionbean.cantidadLote}" >
                                <a4j:support action="#{ManagedProgramaProduccionSimulacion.cantidadLoteProduccion_change}"
                                               event="onblur" reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR" />
                        </h:inputText>                        

                        <h:outputText styleClass="outputText2" value="Tipo Programa Producción"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.tiposProgramaProduccion.codTipoProgramaProd}" id="codTipoProgramaProduccion">
                            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.tiposProgramaProdList}"/>
                        </h:selectOneMenu>
                        
                        <h:outputText  styleClass="outputText2" value="Observación"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.observacion}" id="obs"  />
                        
                    </h:panelGrid>
                    
                    <br>
                    <b> Materia Prima </b>
                    <br>
                    
                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraMPList}" var="data" id="dataFormulaMP" 
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
                    <b> Material Reactivo </b>
                    <br>
                    
           
                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraMRList}" var="data" id="dataFormulaMR" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" width="50%">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Material Reactivo"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
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
                    <b> 
                    <h:outputText styleClass="outputText2" value="Empaque Primario"  /> </b>
                    <h:selectOneMenu id="empaque_prim" styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.codPresPrim}"
                                     valueChangeListener="#{ManagedProgramaProduccionSimulacion.changeEventPrim}">    
                        <f:selectItems value="#{ManagedProgramaProduccionSimulacion.empaquePrimarioList}"/>
                        <a4j:support event="onchange"  reRender="dataFormulaEP"  />
                    </h:selectOneMenu>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraEPList}" var="data" id="dataFormulaEP" 
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
                    <b> 
                    <h:outputText styleClass="outputText2" value="Empaque Secundario"  /> </b>
                    <br>
                    <h:selectOneMenu id="empaque_sec" styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.codPresProd}"
                                     valueChangeListener="#{ManagedProgramaProduccionSimulacion.changeEventSec}">    
                        <f:selectItems value="#{ManagedProgramaProduccionSimulacion.empaqueSecundarioList}"/>
                        <a4j:support event="onchange"  reRender="dataFormulaES"  />
                    </h:selectOneMenu>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraESList}" var="data" id="dataFormulaES" 
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
                    <%--b> Material Promocional </b>
                    <br>
                    <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.formulaMaestraMPROMList}" var="data" id="dataFormulaMPROM" 
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
                        
                    </rich:dataTable--%>
                   
                    <br>
                    
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.guardarEditarProgramaProduccion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccionSimulacion.cancelarEditarProgramaProduccion_action}"/>
                    
                </div>
                
                
            </h:form>
        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

