asdsssss
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
               function verDetalleMaterialesAnalisis(codControl,codAnalisis)
               {
                   var url="reporteDetalleMaterialesAnalisis.jsf?cod="+Math.random()+"&codCC="+codControl+"&codAnalisis="+codAnalisis;
                   window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

               }
               function verDetalleMaterialesProgramaLote(codControl)
               {
                   var url="reporteDetalleMaterialesProgramaEstabilidad_x.jsf?cod="+Math.random()+"&codCC="+codControl;
                   window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');

               }
               function verReporteResultados(codProgramaControlCalidad,codProgramaControlCalidadAnalisis,codCompprod){
                   var url="reporteDetalleResultadosProgramaEstabilidad.jsf?cod="+Math.random()+"&codProgramaControlCalidad="+codProgramaControlCalidad+"&codProgramaControlCalidadAnalisis="+codProgramaControlCalidadAnalisis+"&codCompProd="+codCompprod;
                   window.open(url,'detalle','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
               }
          </script>
            <style>
               
                .subCabecera
                {
                    background-color:#9d5a9e;
                    color:white;
                    font-weight:bold;
                }
                .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                }
                .celdaVersion{
                    background-color:#eeeeee;
                }
            </style>
        </head>
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccionControlCalidad.cargarProgramaProduccionControlCalidad}"  />
                     <rich:panel headerClass="headerClassACliente" style="width:50%;align:center">
                            <f:facet name="header">
                                    <h:outputText value="Programa de Estabilidad"/>
                            </f:facet>
                            <h:panelGrid columns="3">
                                <h:outputText value="Nombre Programa" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.nombreProgramaProduccion}"
                                styleClass="outputText2" style=""/>
                                <h:outputText value="Observacion Programa" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="#{ManagedProgramaProduccionControlCalidad.programaProduccionPeriodoSeleccionado.obsProgramaProduccion}"
                                styleClass="outputText2" style=""/>
                            </h:panelGrid>
                    </rich:panel>
                     <br>
                        <h:panelGroup id="contenidoProgramaProduccion">
                            <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadList}" var="data" id="dataProgProdCC"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente headerLocal" binding="#{ManagedProgramaProduccionControlCalidad.programaProduccionControlCalidadDataTable}" >
                                 <f:facet name="header">
                                     <rich:columnGroup>
                                        <rich:column rowspan="2">
                                             <h:outputText value=""  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Producto"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Lote Produccion"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Almacen Muestra"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Tipo Estudio"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Tiempo Estudio"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Tipo Programa Producción"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Programa Produccion"  />
                                         </rich:column>
                                         <rich:column  colspan="12">
                                             <h:outputText value="Detalle de Analisis"  />
                                         </rich:column>
                                         
                                         <rich:column breakBefore="true"styleClass="subHeaderTableClass" >
                                             <h:outputText value="Tiempo Estudio"  />
                                         </rich:column>
                                         <rich:column styleClass="subHeaderTableClass">
                                             <h:outputText value="Fecha Analisis"  />
                                         </rich:column>
                                         <rich:column styleClass="subHeaderTableClass" >
                                             <h:outputText value="Tipo Material Reactivo"  />
                                         </rich:column>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Cantidad Test Disolución"  />
                                         </rich:column>
                                         <rich:column styleClass="subHeaderTableClass" >
                                             <h:outputText value="Cantidad Test Valoración"  />
                                         </rich:column>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Procede"  />
                                         </rich:column>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Observaciones"  />
                                         </rich:column>
                                         <%--rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Edicion Análisis"  />
                                         </rich:column--%>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Resultados CN"  />
                                         </rich:column>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Resultados EST"  />
                                         </rich:column>
                                         <rich:column  styleClass="subHeaderTableClass">
                                             <h:outputText value="Reporte Resultados"  />
                                         </rich:column>
                                         <rich:column rowspan="2">
                                             <h:outputText value="Detalle de Materiales"  />
                                         </rich:column>
                                     </rich:columnGroup>
                                     
                                 </f:facet>
                                 <rich:subTable var="subData" value="#{data.programaProduccionControlCalidadAnalisisList}"
                                     rowKeyVar="rowkey">
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:selectBooleanCheckbox value="#{data.checked}"   />
                                        </rich:column >
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}"  />
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.codLoteProduccion}"  />
                                        </rich:column>
                                        <%---rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.cantidadMuestras}"  />
                                        </rich:column--%>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.almacenesMuestra.nombreAlmacenMuestra}"  />
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.tiposEstudioEstabilidad.nombreTipoEstudioEstabilidad}"  />
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.tiempoEstudio}"  />
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <h:outputText value="#{data.programaProduccionPeriodoLoteProduccion.nombreProgramaProduccion}"  />
                                        </rich:column>
                                        <rich:column styleClass="celdaVersion">
                                            <h:outputText value="#{subData.tiempoEstudio}"/>
                                        </rich:column>
                                         <rich:column styleClass="celdaVersion">
                                            <h:outputText value="#{subData.fechaAnalisis}">
                                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                                            </h:outputText>
                                        </rich:column>
                                         <rich:column styleClass="celdaVersion">
                                            <h:outputText value="#{subData.tipoMaterialReactivo.nombreTipoMaterialReactivo}"/>
                                        </rich:column>
                                          <rich:column styleClass="celdaVersion">
                                              <h:outputText value="#{subData.cantidadTestDisolucion}"  />
                                        </rich:column>
                                         <rich:column styleClass="celdaVersion">
                                             <h:outputText value="#{subData.cantidadTestValoracion}"  />
                                        </rich:column>
                                         <rich:column styleClass="celdaVersion">
                                            <center>
                                                <h:graphicImage rendered="#{subData.procede eq '1'}" url="../img/ok.jpg"/>
                                                <h:graphicImage rendered="#{subData.procede eq '2'}" url="../img/notOk.jpg"/>
                                            </center>
                                        </rich:column>
                                         <rich:column styleClass="celdaVersion">
                                            <h:outputText value="#{subData.observacion}"/>
                                        </rich:column>
                                        
                                        <%--rich:column styleClass="celdaVersion">
                                            <a4j:commandLink action="#{ManagedProgramaProduccionControlCalidad.seleccionarAnalisisProgramaProduccion}" timeout="7200"
                                            oncomplete="Richfaces.showModalPanel('panelEditarAnalisis')" reRender="contenidoEditarAnalisis">
                                                <f:param name="codControlAnalisis" value="#{subData.codControlCalidadAnalisis}"/>
                                                <f:param name="codPrograma" value="#{data.codProgramaProdControlCalidad}"/>
                                                <h:graphicImage url="../img/edit.jpg" title="Editar Analisis"/>
                                            </a4j:commandLink>
                                        </rich:column--%>

                                        <rich:column styleClass="celdaVersion">
                                            <a4j:commandLink action="#{ManagedProgramaProduccionControlCalidad.registrarResultados_action}" timeout="7200"
                                            oncomplete="location='registrar_resultados_estabilidad.jsf'" reRender="contenidoResultados">
                                                <f:param name="codPrograma" value="#{data.codProgramaProdControlCalidad}"/>
                                                <f:param name="codControlAnalisis" value="#{subData.codControlCalidadAnalisis}"/>
                                                <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                                <f:param name="nombreProdSemiterminado" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                                <f:param name="codLoteProduccion" value="#{data.codLoteProduccion}"/>
                                                <f:param name="nombreTipoProgramaProd" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                                <f:param name="nombreAlmacenMuestra" value="#{data.almacenesMuestra.nombreAlmacenMuestra}"/>
                                                <f:param name="nombreTipoEstudioEstabilidad" value="#{data.tiposEstudioEstabilidad.nombreTipoEstudioEstabilidad}"/>
                                                <f:param name="codTipoResultadoEstabilidad" value="1"/>
                                                

                                                


                                                <h:graphicImage url="../img/edit.jpg" title="Resultados CN"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column styleClass="celdaVersion">
                                            <a4j:commandLink action="#{ManagedProgramaProduccionControlCalidad.registrarResultados_action}" timeout="7200"
                                            oncomplete="location='registrar_resultados_estabilidad.jsf'" reRender="contenidoResultados">
                                                <f:param name="codPrograma" value="#{data.codProgramaProdControlCalidad}"/>
                                                <f:param name="codControlAnalisis" value="#{subData.codControlCalidadAnalisis}"/>
                                                <f:param name="codCompProd" value="#{data.componentesProd.codCompprod}"/>
                                                <f:param name="nombreProdSemiterminado" value="#{data.componentesProd.nombreProdSemiterminado}"/>
                                                <f:param name="codLoteProduccion" value="#{data.codLoteProduccion}"/>
                                                <f:param name="nombreTipoProgramaProd" value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                                                <f:param name="nombreAlmacenMuestra" value="#{data.almacenesMuestra.nombreAlmacenMuestra}"/>
                                                <f:param name="nombreTipoEstudioEstabilidad" value="#{data.tiposEstudioEstabilidad.nombreTipoEstudioEstabilidad}"/>
                                                <f:param name="codTipoResultadoEstabilidad" value="2"/>
                                                

                                                <h:graphicImage url="../img/edit.jpg" title="Resultados EST"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                         
                                         
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <a4j:commandLink oncomplete="verReporteResultados('#{data.codProgramaProdControlCalidad}','#{subData.codControlCalidadAnalisis}','#{data.componentesProd.codCompprod}')">
                                                <h:graphicImage url="../img/organigrama3.jpg" title="ver detalle"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                        <rich:column rowspan="#{data.cantidadEstudios}"  rendered="#{rowkey eq 0}">
                                            <a4j:commandLink oncomplete="verDetalleMaterialesProgramaLote('#{data.codProgramaProdControlCalidad}');">
                                                <h:graphicImage url="../img/organigrama3.jpg" title="ver detalle"/>
                                            </a4j:commandLink>
                                        </rich:column>
                                         <rich:column style="height:12px;background-color:#cccccc" breakBefore="true" styleClass="subHeaderTableClass" colspan="20"  rendered="#{rowkey eq (data.cantidadEstudios-1)}">
                                         </rich:column>
                                         <%--rich:column styleClass="celdaVersion">
                                            <a4j:commandLink oncomplete="verDetalleMaterialesAnalisis('#{data.codProgramaProdControlCalidad}','#{subData.codControlCalidadAnalisis}')">
                                                <h:graphicImage url="../img/organigrama3.jpg" title="ver detalle"/>
                                            </a4j:commandLink>
                                        </rich:column--%>
                               </rich:subTable>
                        </rich:dataTable>
                    
                    <br>
                    <a4j:commandButton value="Agregar a partir de Programa Produccion"  styleClass="btn" onclick="window.location='agregar_programa_control_calidad_produccion.jsf'" />
                    
                    
                    <a4j:commandButton value="Editar" action="#{ManagedProgramaProduccionControlCalidad.editarProgramaProduccionControlCalidad_action}"
                    styleClass="btn" oncomplete="window.location.href='editar_programa_control_calidad_produccion.jsf'" />
                    <a4j:commandButton value="Eliminar" action="#{ManagedProgramaProduccionControlCalidad.eliminarProgramaProduccionControlCalidad_action}" styleClass="btn"
                    oncomplete="if(#{ManagedProgramaProduccionControlCalidad.mensaje eq '1'}){alert('Se elimino el programa de produccion');}else{alert('#{ManagedProgramaProduccionControlCalidad.mensaje}');}"
                    reRender="dataProgProdCC"/>
                    
                    </h:panelGroup>
                   
                </div>

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

                


            </a4j:form>
             <rich:modalPanel id="panelEditarAnalisis"  minHeight="470"  minWidth="500"
                                     height="470" width="500"
                                     zindex="200"
                                     headerClass="headerLocal "
                                     resizeable="true"  >
                        <f:facet name="header">
                            <h:outputText value="Edicion de Analisis" styleClass="outputText2" style="font-weight:bold"/>
                        </f:facet>
                        <a4j:form id="form5">
                                 <h:panelGroup id="contenidoEditarAnalisis">
                                     <center>
                                     <rich:panel headerClass="headerLocal">
                                         <f:facet name="header">
                                             <h:outputText value="Datos Del Programa De Estabilidad" styleClass="outputText2" style='font-weight:bold;'/>
                                         </f:facet>
                                         <h:panelGrid columns="3">
                                        <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                                        <h:outputText value="Almacen Muestra" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.almacenesMuestra.nombreAlmacenMuestra}" styleClass="outputText2" />
                                        <h:outputText value="Tipo Programa" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.tiposProgramaProduccion.nombreTipoProgramaProd}" styleClass="outputText2" />
                                        <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.programaProduccionControlCalidad.codLoteProduccion}" styleClass="outputText2" />
                                         </h:panelGrid>

                                     </rich:panel>
                                     <rich:panel headerClass="headerLocal" style="margin-top:12px;">
                                         <f:facet name="header">
                                             <h:outputText styleClass="outputText2" value="Datos Del Analisis de Estabilidad" style="font-weight:bold"/>
                                         </f:facet>
                                         <h:panelGrid columns="3" style="padding:5px;" cellspacing="3px;">
                                        <h:outputText value="Tiempo Estudio" styleClass="outputText2" style='font-weight:bold;'/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.tiempoEstudio} meses" styleClass="outputText2" />
                                        <h:outputText value="Cant. Test Disolucion" styleClass="outputText2" style='font-weight:bold;'/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.cantidadTestDisolucion}" styleClass="outputText2" />
                                        <h:outputText value="Cant. Test Valoracion" styleClass="outputText2" style='font-weight:bold;'/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.cantidadTestValoracion}" styleClass="outputText2" />
                                        <h:outputText value="Tipo Material" styleClass="outputText2" style='font-weight:bold;'/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.tipoMaterialReactivo.nombreTipoMaterialReactivo}" styleClass="outputText2" />
                                        <h:outputText value="Fecha Analisis" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <rich:calendar  value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.fechaAnalisis}" styleClass="inputText" datePattern="dd/MM/yyyy">
                                        </rich:calendar>
                                        <h:outputText value="Recorrer Fechas" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectBooleanCheckbox value="#{ManagedProgramaProduccionControlCalidad.recorrerFechas}"/>
                                        <h:outputText value="Observaciones" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputTextarea value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.observacion}" styleClass="inputText" style="width:100%" rows="3"/>
                                        <h:outputText value="Procede" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:selectOneRadio styleClass="outputText2" value="#{ManagedProgramaProduccionControlCalidad.produccionControlCalidadAnalisisEditar.procede}">
                                            <f:selectItem itemLabel="Sí" itemValue='1'/>
                                            <f:selectItem itemLabel="No" itemValue='2'/>
                                            <f:selectItem itemLabel="Ninguno" itemValue='0'/>
                                        </h:selectOneRadio>
                                        
                                    </h:panelGrid>
                                </rich:panel>
                                    </center>
                                  </h:panelGroup>
                                  <center style="margin-top:12px;">
                                      <a4j:commandButton timeout="10000" value="Guardar"  styleClass="btn" action="#{ManagedProgramaProduccionControlCalidad.guardarEdicionControlCalidadAnalisis_action}"
                                      oncomplete="if(#{ManagedProgramaProduccionControlCalidad.mensaje eq '1'}){if(#{ManagedProgramaProduccionControlCalidad.recorrerFechas}){alert('Se registro la edicion del analisis.Se recorrieron #{ManagedProgramaProduccionControlCalidad.cantidadAfectados} analisis');}
                                      else{alert('Se registro la edición del analisis')};javascript:Richfaces.hideModalPanel('panelEditarAnalisis')}
                                      else{alert('#{ManagedProgramaProduccionControlCalidad.mensaje}');}" reRender="dataProgProdCC"/>
                                       <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelEditarAnalisis')" />
                                  </center>
                                
                        </a4j:form>
            </rich:modalPanel>
            <rich:modalPanel id="panelRegistroResultados"  minHeight="400"  minWidth="500"
                                     height="400" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente "
                                     resizeable="true" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registrar Resultados"/>
                        </f:facet>
                        <a4j:form id="form1XX">
                          
                            
                                 <h:panelGroup id="contenidoResultados">

                                     <center>
                                    <div style="height:320px;overflow:auto; margin-top:6px;"  id="container" ><%--onscroll="onScroll('form11:dataProgProd','container')"--%>
                                          <rich:dataTable value="#{ManagedProgramaProduccionControlCalidad.resultadoFisicoEstabilidad}"
                                                              var="data" id="dataProgProd" headerClass="headerClassACliente"  >

                                                <rich:column >
                                                    <f:facet name="header">
                                                        <h:outputText value=""/>
                                                    </f:facet>
                                                    <%--/h:selectBooleanCheckbox value="#{data.checked}" /--%>
                                                    <h:outputText value="#{data.especificacionesFisicasProducto.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2"/>

                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Especificacion"/>
                                                    </f:facet>
                                                    <h:panelGroup rendered="#{data.especificacionesFisicasProducto.limiteInferior!=0 && data.especificacionesFisicasProducto.limiteSuperior!=0}">
                                                    <h:outputText value="#{data.especificacionesFisicasProducto.limiteInferior}" styleClass="outputText2"/>-
                                                    <h:outputText value="#{data.especificacionesFisicasProducto.limiteSuperior}" styleClass="outputText2"/>
                                                    </h:panelGroup>
                                                    <h:outputText value="#{data.especificacionesFisicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" />
                                                </rich:column >
                                                <rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Resultado"/>
                                                    </f:facet>
                                                    <h:panelGroup rendered="#{data.especificacionesFisicasProducto.limiteInferior!=0 && data.especificacionesFisicasProducto.limiteSuperior!=0}">
                                                    <h:inputText value="#{data.resultadoNumerico}" styleClass="inputText1"/>
                                                    </h:panelGroup>
                                                    <br/>
                                                    <h:selectOneMenu value="#{data.codTipoResultadoDescriptivo}"><%-- rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" --%>
                                                        <f:selectItem itemValue="0"  itemLabel="-Ninguno-" />
                                                        <f:selectItem itemValue="1"  itemLabel="Conforme" />
                                                        <f:selectItem itemValue="2"  itemLabel="No Conforme" />
                                                    </h:selectOneMenu>
                                                    <%--h:outputText value="#{data.especificacionesFisicasProducto.descripcion}" styleClass="outputText2"  rendered="#{data.especificacionesFisicasProducto.limiteInferior eq 0 && data.especificacionesFisicasProducto.limiteSuperior  eq 0}" /--%>
                                                </rich:column >
                                                

                                                <%--rich:column  >
                                                    <f:facet name="header">
                                                        <h:outputText value="Cant."/>
                                                    </f:facet>
                                                    <h:inputText value="#{data.cantidad}" styleClass="outputText2" size = "8" />
                                                </rich:column --%>

                                        </rich:dataTable>
                                    </div>
                                  </h:panelGroup>
                                  <a4j:commandButton timeout="10000" value="Guardar" action="#{ManagedProgramaProduccionControlCalidad.guardarResultadosFisicosEstabilidad}"  styleClass="btn" oncomplete="javascript:Richfaces.hideModalPanel('panelRegistroResultados')" />
                                  <a4j:commandButton timeout="10000" value="Cancelar"  styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelRegistroResultados')" />

                                </center>
                        </a4j:form>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

