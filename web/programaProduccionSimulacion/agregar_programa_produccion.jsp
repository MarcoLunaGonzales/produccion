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
                   
                   var codFormulaMaestra=document.getElementById('form1:codFormulaMaestra');
                   var codTipoProgramaProduccion=document.getElementById('form1:codTipoProgramaProduccion');
                   var cantidadProduccion = document.getElementById('form1:cant_lote');
                   var nroLotes = document.getElementById('form1:nroLotes');
                   
                   if(codFormulaMaestra.value=='0'){
                     alert('Por favor Seleccione un producto para su formula maestra.');
                     codFormulaMaestra.focus();
                     return false;
                   }
                   
                   if(codTipoProgramaProduccion.value==0){
                     alert('Por favor Seleccione el tipo de Programa de Produccion.');
                     codTipoProgramaProduccion.focus();
                     return false;
                   }
                   
                   if(cantidadProduccion.value<=0){
                       alert('La cantidad de lote de produccion debe ser mayor a cero');
                       cantidadProduccion.focus();
                       return false;
                   }
                   if(nroLotes.value<=0){
                       alert('El numero de lotes debe ser mayor a cero');
                       nroLotes.focus();
                       return false;
                   }


                   return true;
                }
            </script>
        </head>
        <body >
            <a4j:form id="form1"  >
                
                <div align="center">
                    <br><br>
                         <a4j:commandLink value="Seleccionar Programa Produccion Simulacion" onclick="Richfaces.showModalPanel('panelSeleccionarProducto')">

                        </a4j:commandLink>

                        <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionProductosList}"
                                    var="data" id="dataProgramaProduccionProductos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"                                    
                                     >
                                     <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Producto"  />
                                        </f:facet>
                                        <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                                    </rich:column>
                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Cantidad de Lote"  />
                                        </f:facet>
                                        <h:outputText value="#{data.cantidadLote}"  />
                                    </rich:column>
                                    <rich:column  >
                                        <f:facet name="header">
                                            <h:outputText value="Nro de Lote"  />
                                        </f:facet>
                                        <h:outputText value="#{data.codLoteProduccion}"  />
                                    </rich:column >
                                    <rich:column   >
                                        <f:facet name="header">
                                            <h:outputText value="Tipo Programa Producción"  />
                                        </f:facet>
                                        <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}" />
                                    </rich:column >

                                    <rich:column  >
                                        <f:facet name="header" >
                                            <h:outputText value="Area"  />
                                        </f:facet>
                                        <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                                    </rich:column>

                                    <rich:column   >
                                        <f:facet name="header">
                                            <h:outputText value="Estado"  />
                                        </f:facet>
                                        <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                    </rich:column >

                       </rich:dataTable>
                    <h:panelGrid columns="3" id="contenidoProgramaProduccion" styleClass="panelgrid" headerClass="headerClassACliente">
                        <f:facet name="header" >
                            <h:outputText value="Registrar Programa Producción" styleClass="outputText2" style="color:#FFFFFF"   />
                        </f:facet>      
                        
                        <h:outputText styleClass="outputText2" value="Formula Maestra"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <%--
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.formulaMaestra.codFormulaMaestra}"
                                          valueChangeListener="#{ManagedProgramaProduccionSimulacion.changeEvent}" id="codFormulaMaestra">
                            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.formulaMaestraList}"/>
                            <a4j:support event="onchange"  reRender="cantidadLoteProduccion,dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,empaque_prim,empaque_sec,dataFormulaMR"
                            />
                        </h:selectOneMenu>
                        --%>
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.formulaMaestra.codFormulaMaestra}"
                                          id="codFormulaMaestra">
                            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.formulaMaestraList}"/>
                            <a4j:support event="onchange" action="#{ManagedProgramaProduccionSimulacion.formulaMaestra_change}"
                                         reRender="contenidoProgramaProduccion,cantidadLoteProduccion,dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,empaque_prim,empaque_sec,dataFormulaMR,nroLotes"
                            />
                        </h:selectOneMenu>
                        
                        

                        
                        
                        <%--h:outputText  styleClass="outputText2" value="Fecha Inicio"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.fechaInicio}"   id="f_inicio" >
                                <a4j:support event="onchange" reRender="dias_calculados,dias_acuenta"  /> 
                            </h:inputText>
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinicio" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_inicio\" click_element_id=\"form1:imagenFinicio\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <h:outputText  styleClass="outputText2" value="Fecha Final"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:panelGroup>
                            <h:inputText styleClass="outputText2" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.fechaFinal}"  id="f_final">
                                <a4j:support event="onchange"   />   
                            </h:inputText>  
                            <h:graphicImage url="../img/fecha.bmp"  id="imagenFinal" />
                            <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:f_final\" click_element_id=\"form1:imagenFinal\"></DLCALENDAR>"  escape="false"  />
                        </h:panelGroup>  
                        
                        <%--h:outputText  styleClass="outputText2" value="Nro Lote"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputText styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.codLoteProduccion}" id="cantidad"  /--%>
                        
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
                            id="nroLotes" onkeypress="valNum();" >
                                <a4j:support action="#{ManagedProgramaProduccionSimulacion.cantidadLoteProduccion_change}"
                                               event="onblur" reRender="dataFormulaMP,dataFormulaEP,dataFormulaES,dataFormulaMPROM,dataFormulaMR,nroLotes"
                                               oncomplete="if(#{ManagedProgramaProduccionSimulacion.mensaje!=''}){alert('#{ManagedProgramaProduccionSimulacion.mensaje}');document.getElementById('form1:nroLotes').focus() }"    />
                        </h:inputText>                        
                        
                        <h:outputText styleClass="outputText2" value="Tipo Programa Producción"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:selectOneMenu  styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.tiposProgramaProduccion.codTipoProgramaProd}" id="codTipoProgramaProduccion">
                            <f:selectItems value="#{ManagedProgramaProduccionSimulacion.tiposProgramaProdList}"/>
                        </h:selectOneMenu>
                        
                        
                        <h:outputText  styleClass="outputText2" value="Observaciones"  />
                        <h:outputText styleClass="outputText2" value="::"  />
                        <h:inputTextarea styleClass="inputText" value="#{ManagedProgramaProduccionSimulacion.programaProduccionbean.observacion}" id="obs"  />
                        
                    </h:panelGrid>
                    
                    <br>
                    <b> Materia Prima </b>
                    <br>
                    
                    <table width="27%" align="center" class="outputText2">
                        <tr>
                            <td>Material Reactivo : </td>
                            <td bgcolor="#C5F7C8" width="20%" >&nbsp;</td>
                        </tr>
                    </table>
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
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Materia Prima"  />
                            </f:facet>
                            <h:outputText rendered="#{data.swSi}" style="background-color: #C5F7C8" value="#{data.materiales.nombreMaterial}"  />
                            <h:outputText rendered="#{data.swNo}" value="#{data.materiales.nombreMaterial}" />
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
                    
                    <h:commandButton value="Guardar" styleClass="btn"  action="#{ManagedProgramaProduccionSimulacion.guardarProgramaProduccion}"   onclick="return validar();" />
                    <h:commandButton value="Cancelar" styleClass="btn"   action="#{ManagedProgramaProduccionSimulacion.Cancelar}"/>
                    
                </div>
                
                
            </a4j:form>

                <rich:modalPanel id="panelSeleccionarProducto" minHeight="300"  minWidth="600"
                                     height="300" width="600"  zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Seleccionar Producto"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoSeleccionarProducto">
                            <div align="center">
                                  <rich:dataTable value="#{ManagedProgramaProduccionSimulacion.programaProduccionLotesList}"
                                  var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccionSimulacion.programaProduccionLotesDataTable}"
                                     >


                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Producto"  />
                                            </f:facet>
                                            <a4j:commandLink value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"
                                            onclick="Richfaces.hideModalPanel('panelSeleccionarProducto')"
                                            reRender="dataProgramaProduccionProductos,contenidoProgramaProduccion,dataFormulaMP,dataFormulaEP,dataFormulaES"
                                            action="#{ManagedProgramaProduccionSimulacion.seleccionarProgramaProduccionLotes_action}"
                                            >
                                            </a4j:commandLink>
                                        </h:column>


                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Lote"  />
                                            </f:facet>
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </h:column>

                                        <h:column>
                                            <f:facet name="header">
                                                <h:outputText value="Categoría"  />
                                            </f:facet>
                                            <h:outputText value="#{data.formulaMaestra.componentesProd.categoriasCompProd.nombreCategoriaCompProd}"  />
                                        </h:column>


                                        <h:column >
                                            <f:facet name="header">
                                                <h:outputText value="Estado"  />
                                            </f:facet>
                                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                                        </h:column>
                                </rich:dataTable>

                        <br/>

                        <a4j:commandButton styleClass="btn" value="Registrar" onclick="if(validarAsignacionCintasSeguridad('form2:listadoSeleccionarProducto')){Richfaces.showModalPanel('panelIngresosDetalleAcond');}"  action="#{ManagedCintasSeguridad.seleccionarIngresoAcondicionamiento_action}"
                                           reRender="contenidoIngresosDetalleAcond" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelSeleccionarProducto')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
        </body>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
        
    </html>
    
</f:view>

