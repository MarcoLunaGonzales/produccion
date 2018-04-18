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
            <script type="text/javascript">
                function validarAsignacionCintasSeguridad(nametable){

                    var count=0;
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel=cellsElement[0];
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel.getElementsByTagName('input')[0].checked){
                                count++;
                            }
                        }
                    }
                    if(count==0){
                        alert('No selecciono ningun Registro');
                        return false;
                    }else{
                     if(count>1){
                        alert('solo se puede editar un Registro');
                        return false;
                    }
                    }
                    return true;
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        <body>
            <a4j:form id="form1"  >
                <div align="center">                    
                    <br>
                    <h:outputText value="Cintas de Seguridad" styleClass="tituloCabezera1"    />
                    <h:outputText value="#{ManagedCintasSeguridad.cargarDatosCintasSeguridad}"/>
                    <br>  <br>
                    
                    <h:panelGrid columns="2">
                    <h:outputText value="Programa de Produccion ::" styleClass="outputTextTitulo"  />
                    <h:selectOneMenu value="#{ManagedCintasSeguridad.programaProduccionPeriodo.codProgramaProduccion}" styleClass="inputText" >
                        <f:selectItems value="#{ManagedCintasSeguridad.programaProduccionPeriodoList}"  />
                        <a4j:support event="onchange"  reRender="panelContenido"  actionListener="#{ManagedCintasSeguridad.programaProduccionPeriodo_change}" />
                    </h:selectOneMenu>

                    <h:outputText value="Estado de Lotes en Acondicionamiento ::" styleClass="outputTextTitulo"  />
                    <h:selectOneMenu value="#{ManagedCintasSeguridad.estadosIngresoAcond.codEstadoIngresoAcond}" styleClass="inputText" >
                        <f:selectItems value="#{ManagedCintasSeguridad.estadosIngresoAcondList}"  />
                        <a4j:support event="onchange"  reRender="panelContenido"  actionListener="#{ManagedCintasSeguridad.programaProduccionPeriodo_change}" />
                    </h:selectOneMenu>

                    </h:panelGrid>
                    <br>
                    <br>
                    <h:panelGroup id="panelContenido">
                    <rich:dataTable value="#{ManagedCintasSeguridad.programaProduccionList}" var="data"
                                    id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"                                   
                                    binding="#{ManagedCintasSeguridad.programaProduccionDataTable}"
                    >
                        <%--
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        --%>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </h:column>
                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Cantidad Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}" styleClass="" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Estado Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </h:column>

                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            
                            <a4j:commandLink action="#{ManagedCintasSeguridad.registrarCintasDeSeguridad_action}"
                                            onclick="Richfaces.showModalPanel('panelIngresosDetalleAcondCantidadPeso')"
                                            reRender="contenidoIngresosDetalleAcondCantidadPeso">
                                <h:outputText value="Detalle"/>
                            </a4j:commandLink>
                        </h:column>



                    </rich:dataTable>
                    </h:panelGroup>
                    <br/>
                    <%--
                    <a4j:commandButton  value="Registrar/Modificar" styleClass="btn"
                        onclick="if(validarAsignacionCintasSeguridad('form1:dataProgramaProduccion')){Richfaces.showModalPanel('panelIngresosDetalleAcondCantidadPeso')}"
                        reRender="contenidoIngresosDetalleAcondCantidadPeso" action="#{ManagedCintasSeguridad.seleccionarProductoProduccion_action}"
                        ajaxSingle="false"/>
                     --%>
                    
                    <br>                    
                    
                </div>
                <!--cerrando la conexion-->
                
            </a4j:form>


                    <rich:modalPanel id="panelIngresosAcond" minHeight="300"  minWidth="600"
                                     height="300" width="600"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Ingresos Acondicionamiento"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoIngresosAcond">
                            <div align="center">
                            <rich:dataTable value="#{ManagedCintasSeguridad.ingresosAcondList}" var="data"
                                        id="listadoIngresosAcond"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"
                                        rows="5"
                                        align="center" >
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value=""  />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nro de Ingreso" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Tipo de Ingreso" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Gestion" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Estado" styleClass="outputText2" />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column styleClass="">
                                <h:selectBooleanCheckbox value="#{data.checked}" />
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.nroIngresoAcond}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.tipoIngresoAcond.nombreTipoIngresoAcond}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.gestion.nombreGestion}" styleClass="outputText2" />
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.estadosIngresoAcond.nombreEstadoIngresoAcond}" styleClass="outputText2" />
                            </rich:column>
                            
                        </rich:dataTable>
                        <rich:datascroller align="center" for="listadoIngresosAcond" maxPages="20" id="scIngresosAcond" ajaxSingle="true" />
                        <br/>
                        
                        <a4j:commandButton styleClass="btn" value="Registrar" onclick="if(validarAsignacionCintasSeguridad('form2:listadoIngresosAcond')){Richfaces.showModalPanel('panelIngresosDetalleAcond');}"  action="#{ManagedCintasSeguridad.seleccionarIngresoAcondicionamiento_action}"
                                           reRender="contenidoIngresosDetalleAcond" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosAcond')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>


                <rich:modalPanel id="panelIngresosDetalleAcond" minHeight="300"  minWidth="700"
                                     height="300" width="700"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Ingresos Detalle Acondicionamiento"/>
                        </f:facet>
                        <a4j:form>
                            <h:panelGroup id="contenidoIngresosDetalleAcond">
                            <div align="center">
                            <rich:dataTable value="#{ManagedCintasSeguridad.ingresosDetalleAcondList}" var="data"
                                        id="listadoIngresosDetalleAcond"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"
                                        rows="5"
                                        align="center">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Producto" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Lote Produccion" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fecha Vencimiento" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Ingreso Produccion" styleClass="outputText2" />
                                    </rich:column>
                                    
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column styleClass="">
                                <h:selectBooleanCheckbox value="#{data.checked}" />
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.codLoteProduccion}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.fechaVencimiento}"  styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy" />
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.cantIngresoProduccion}" styleClass="outputText2" >
                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                </h:outputText>
                            </rich:column>                            

                        </rich:dataTable>
                        <rich:datascroller align="center" for="listadoIngresosDetalleAcond" maxPages="20" id="scIngresosDetalleAcond" ajaxSingle="true" />
                        <br/>

                        <a4j:commandButton styleClass="btn" value="Registrar Cintas de Seguridad" onclick="javascript:Richfaces.showModalPanel('panelIngresosDetalleCantidadPeso')"
                        action="#{ManagedCintasSeguridad.seleccionarDetalleIngresoAcondicionamiento_action}" reRender="contenidoIngresosDetalleCantPeso" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosDetalleAcond')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>

                
                <rich:modalPanel id="panelIngresosDetalleCantidadPeso" minHeight="400"  minWidth="700"
                                     height="400" width="700"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Ingresos Detalle Cantidad Peso"/>
                        </f:facet>
                        <a4j:form>
                            <h:panelGroup id="contenidoIngresosDetalleCantPeso">
                            <div align="center">
                            <rich:dataTable value="#{ManagedCintasSeguridad.ingresosDetalleCantidadPesoList}" var="data"
                                        id="listadoIngresosDetalleCantidadPeso"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"                                        
                                        align="center">
                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Cantidad" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Peso" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Envase" styleClass="outputText2" />
                                    </rich:column>                                    
                                    <rich:column>
                                        <h:outputText value="Nro Cinta de Seguridad 1" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Nro Cinta de Seguridad 2" styleClass="outputText2" />
                                    </rich:column>
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.cantidad}"  styleClass="outputText2">
                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.peso}"  styleClass="outputText2">
                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.tiposEnvase.nombreTipoEnvase}"  styleClass="outputText2" />                                    
                            </rich:column>                            
                            <rich:column styleClass="">
                                <h:inputText value="#{data.nroCintaSeguridad1}" styleClass="outputText2" size="10" />
                            </rich:column>
                            <rich:column styleClass="">
                                <h:inputText value="#{data.nroCintaSeguridad2}" styleClass="outputText2" size="10" />
                            </rich:column>
                        </rich:dataTable>
                        
                        <br/>

                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosDetalleCantidadPeso');Richfaces.hideModalPanel('panelIngresosDetalleAcond');Richfaces.hideModalPanel('panelIngresosAcond')"  action="#{ManagedCintasSeguridad.registrarCintasSeguridad_action}" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosDetalleCantidadPeso')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>




                <rich:modalPanel id="panelIngresosDetalleAcondCantidadPeso" minHeight="400"  minWidth="800"
                                     height="400" width="800"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto">
                        <f:facet name="header">
                            <h:outputText value="Ingresos Detalle Acondicionamiento - Cantidad Peso"/>
                        </f:facet>
                        <a4j:form>
                            <h:panelGroup id="contenidoIngresosDetalleAcondCantidadPeso">
                            <div align="center">
                            <rich:dataTable value="#{ManagedCintasSeguridad.ingresoDetalleAcondCantidadPesoList}" var="data"
                                        id="listadoIngresosDetalleAcondCantidadPeso"
                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                        headerClass="headerClassACliente"
                                        align="center" binding = "#{ManagedCintasSeguridad.ingresoDetalleAcondCantidadPesoDataTable}" >

                            <f:facet name="header">
                                <rich:columnGroup>
                                    <rich:column>
                                        <h:outputText value="Nro de Ingreso" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Producto" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Lote Produccion" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Fecha Vencimiento" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Cantidad Ingreso Produccion" styleClass="outputText2" />
                                    </rich:column>
                                    <rich:column>
                                        <h:outputText value="Detalle Cantidad Peso" styleClass="outputText2" />
                                    </rich:column>
                                    
                                </rich:columnGroup>
                            </f:facet>
                            <rich:column styleClass="">
                                <a4j:commandLink value="#{data.ingresosAcondicionamiento.nroIngresoAcond}"  styleClass="outputText2"
                                action="#{ManagedCintasSeguridad.verReporteHojaDeTransporte_action}" oncomplete="openPopup('reporteHojaDeRutaTransporte.jsp');" >
                                    
                                </a4j:commandLink>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.ingresosAlmacenDetalleAcond.componentesProd.nombreProdSemiterminado}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.ingresosAlmacenDetalleAcond.codLoteProduccion}"  styleClass="outputText2"/>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.ingresosAlmacenDetalleAcond.fechaVencimiento}"  styleClass="outputText2">
                                    <f:convertDateTime pattern="dd/MM/yyyy" />
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="">
                                <h:outputText value="#{data.ingresosAlmacenDetalleAcond.cantIngresoProduccion}" styleClass="outputText2" >
                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                </h:outputText>
                            </rich:column>
                            <rich:column styleClass="">
                                    <rich:dataTable value="#{data.ingresosDetalleCantPesoList}" var="data1"
                                                        id="listadoIngresosDetalleCantidadPeso1"
                                                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                                        onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                                        headerClass="headerClassACliente"
                                                        align="center">
                                            <f:facet name="header">
                                                <rich:columnGroup>
                                                    <rich:column>
                                                        <h:outputText value="Cantidad" styleClass="outputText2" />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Peso" styleClass="outputText2" />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Envase" styleClass="outputText2" />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Nro Cinta de Seguridad 1" styleClass="outputText2" />
                                                    </rich:column>
                                                    <rich:column>
                                                        <h:outputText value="Nro Cinta de Seguridad 2" styleClass="outputText2" />
                                                    </rich:column>
                                                </rich:columnGroup>
                                            </f:facet>
                                            <rich:column styleClass="">
                                                <h:outputText value="#{data1.cantidad}"  styleClass="outputText2">
                                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"  />
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column styleClass="">
                                                <h:outputText value="#{data1.peso}"  styleClass="outputText2">
                                                    <f:convertNumber maxFractionDigits="2"  minFractionDigits="2" pattern="##,###.00"   />
                                                </h:outputText>
                                            </rich:column>
                                            <rich:column styleClass="">
                                                <h:outputText value="#{data1.tiposEnvase.nombreTipoEnvase}"  styleClass="outputText2" />
                                            </rich:column>
                                            <rich:column styleClass="">
                                                <h:inputText value="#{data1.nroCintaSeguridad1}" styleClass="outputText2" size="10" />
                                            </rich:column>
                                            <rich:column styleClass="">
                                                <h:inputText value="#{data1.nroCintaSeguridad2}" styleClass="outputText2" size="10" />
                                            </rich:column>
                                        </rich:dataTable>
                            </rich:column>




                        </rich:dataTable>

                        <br/>

                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosDetalleAcondCantidadPeso')"  action="#{ManagedCintasSeguridad.guardarIngresoDetalleAcondCantidadPeso_action}" />
                        <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelIngresosDetalleAcondCantidadPeso')" class="btn" />
                        </div>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>                
        </body>
    </html>
    
</f:view>

