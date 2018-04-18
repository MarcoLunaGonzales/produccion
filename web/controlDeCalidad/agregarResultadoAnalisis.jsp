

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <script>
                   A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
             function valNumero()
                {
                    if ((event.keyCode < 48 || event.keyCode > 57)&& event.keyCode!=46)
                     {
                        alert('Introduzca sólo Números');
                        event.returnValue = false;
                     }

                }
            </script>
        </head>
        <body >    
            <div style="text-align:center">
                <style>
                    .fuera{
                        background-color:#FAEBD7;
                    }
                </style>
              
                <br>
             
             <h:form id="form1"  >
                 <h:outputText value="#{ManagedResultadoAnalisis.cargarAgregarControlDeCalidad}"/>
                 <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Datos del Producto"/>

                    </f:facet>
                    <h:panelGrid columns="6" headerClass="headerClassACliente">
                        <h:outputText value="PRODUCTO " styleClass="outputText2"/>
                       <h:outputText value=":" styleClass="outputText2"/>
                       <h:outputText value="#{ManagedResultadoAnalisis.currentProgramaProduccion.formulaMaestra.componentesProd.nombreProdSemiterminado}   " styleClass="outputText2"/>

                        <h:outputText value="   LOTE" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedResultadoAnalisis.currentProgramaProduccion.codLoteProduccion}" styleClass="outputText2"/>
                        <h:outputText value="FORMA FARMACEÚTICA" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedResultadoAnalisis.currentProgramaProduccion.formulaMaestra.componentesProd.forma.nombreForma}" styleClass="outputText2"/>
                        <h:outputText value="   TAMAÑO DEL LOTE" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedResultadoAnalisis.currentProgramaProduccion.cantidadLote}" styleClass="outputText2"/>
                        <h:outputText value="   Nro analisis Físico Químico" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisis.nroAnalisis}" styleClass="inputText"/>
                        <h:outputText value="   Nro analisis Microbiologico" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisis.nroAnalisisMicrobiologico}" styleClass="inputText"/>
                        <h:outputText value="   Analista" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:selectOneMenu value="#{ManagedResultadoAnalisis.resultadoAnalisis.personalAnalista.codPersonal}" styleClass="inputText">
                            <f:selectItems value="#{ManagedResultadoAnalisis.listaAnalistas}"/>
                        </h:selectOneMenu>
                        <h:outputText value="   TOMO" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisis.tomo}" styleClass="inputText"/>
                        <h:outputText value="   PAGINA" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisis.pagina}" styleClass="inputText"/>
                        <h:outputText value="   FECHA VENCIMIENTO" styleClass="outputText2"/>
                        <h:outputText value=":" styleClass="outputText2"/>
                        <h:outputText value="#{ManagedResultadoAnalisis.fechaVencimientoLoteRegistro}" styleClass="outputText2"/>
                    </h:panelGrid>
                   </rich:panel>
                     <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Analisis Fisico"/>
                    </f:facet>
                    <rich:dataTable value="#{ManagedResultadoAnalisis.listaAnalisisFisicos}" var="data" id="dataEspecificacionesFisicas"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="width:90%">

                       <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Tipo de Analisis"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionesFisicasProducto.tiposEspecificacionesFisicas.nombreTipoEspecificacionFisica}" styleClass="outputText2" />
                        </rich:column>
                       <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Tipo de Analisis"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionesFisicasProducto.especificacionFisicaCC.nombreEspecificacion}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"  />
                            </f:facet>
                            <center><h:outputText value="#{data.especificacionesFisicasProducto.descripcion}" rendered="#{data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" /></center>
                            <center><h:panelGrid  columns="3" rendered="#{data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                <h:outputText value="#{data.especificacionesFisicasProducto.limiteInferior}" styleClass="outputText2"/>
                                <h:outputText value="-" styleClass="outputText2" />
                                <h:outputText value="#{data.especificacionesFisicasProducto.limiteSuperior}" styleClass="outputText2" />
                            </h:panelGrid></center>
                            <center><h:panelGrid  columns="2" rendered="#{(data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')&&(data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')}">
                                <h:outputText value="#{data.especificacionesFisicasProducto.especificacionFisicaCC.coeficiente} #{data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                <h:outputText value="#{data.especificacionesFisicasProducto.valorExacto}" styleClass="outputText2" />
                            </h:panelGrid></center>
                        </rich:column >
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionesFisicasProducto.especificacionFisicaCC.tiposReferenciaCc.nombreReferenciaCc}" styleClass="outputText2" />
                        </rich:column>
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Resultados"  />
                            </f:facet>
                            <h:panelGroup rendered="#{data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1'}">
                                <h:inputText value="#{data.resultadoNumerico}" styleClass="inputText" onkeypress="valNumero();" >
                            </h:inputText><br>
                            <h:selectOneMenu value="#{data.resultadoDescriptivoAlternativo.codTipoResultadoDescriptivo}" styleClass="inputText" >
                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivoAlternativo}"/>
                             </h:selectOneMenu>
                            </h:panelGroup>
                            <h:selectOneMenu value="#{data.tipoResultadoDescriptivo.codTipoResultadoDescriptivo}" styleClass="inputText"  rendered="#{data.especificacionesFisicasProducto.especificacionFisicaCC.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}">
                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivo}"/>
                             </h:selectOneMenu>
                            
                            <%--h:outputText value="#{data.tipoResultadoDescriptivo.codTipoResultadoDescriptivo}"/--%>
                            
                        </rich:column >


                   </rich:dataTable>
                   </rich:panel>

                  
                   <rich:panel headerClass="headerClassACliente" style="width:80%" >
                    <f:facet name="header">
                        <h:outputText value="Analisis Quimico"/>
                    </f:facet>
                    <rich:dataTable value="#{ManagedResultadoAnalisis.listaAnalisisQuimicos}" var="data" id="dataQuimicos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="width:90%">
                        
                        <rich:column>
                          <rich:panel headerClass="headerClassACliente" rendered="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.estado.codEstadoRegistro eq '1'}">
                                <center><table class="dr-table rich-table" id="tablaDatosDefectos">
                                   <tr class="dr-table-subheader rich-table-subheader" >
                                     <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente"><h:outputText value="Tipo Analisis"/></td>
                                     <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente"><h:outputText value="Especificaciones"/></td>
                                     <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente"><h:outputText value="Referencia"/></td>
                                     <td class="dr-table-subheadercell rich-table-subheadercell headerClassACliente"><h:outputText value="Resultados"/></td>
                                    </tr>
                                    <tr>
                                        <rich:column styleClass="dr-table-subheadercell rich-table-subheadercell  #{data.colorFila}"><h:outputText value="#{data.nombreEspecificacion}"/></rich:column>
                                      
                                      <rich:column styleClass="dr-table-subheadercell rich-table-subheadercell  #{data.colorFila}">
                                        <center><h:outputText value="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.descripcion}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" /></center>
                                        <center><h:panelGrid  columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                            <h:outputText value="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.limiteInferior}" styleClass="outputText2"/>
                                            <h:outputText value="-" styleClass="outputText2" />
                                            <h:outputText value="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.limiteSuperior}" styleClass="outputText2" />
                                        </h:panelGrid></center>
                                        <center><h:panelGrid  columns="2" rendered="#{(data.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')&&(data.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')}">
                                            <h:outputText value="#{data.coeficiente} #{data.tipoResultadoAnalisis.simbolo}" styleClass="outputText2"/>
                                            <h:outputText value="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.valorExacto}" styleClass="outputText2" />
                                        </h:panelGrid></center>
                                     </rich:column>
                                    <rich:column styleClass="dr-table-subheadercell rich-table-subheadercell  #{data.colorFila}">
                                        <h:outputText value="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.especificacionFisicaCC.tiposReferenciaCc.nombreReferenciaCc}" styleClass="outputText2" />
                                    </rich:column>


                                     <rich:column styleClass="dr-table-subheadercell rich-table-subheadercell  #{data.colorFila}">
                                         <h:panelGroup rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1'}">
                                             <h:inputText value="#{data.especificacionQuimicaGeneral.resultadoNumerico}" onkeypress="valNumero();" styleClass="inputText" >
                                            </h:inputText><br>
                                            <h:selectOneMenu value="#{data.especificacionQuimicaGeneral.resultadoDescriptivoAlternativo.codTipoResultadoDescriptivo}" styleClass="inputText" >
                                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivoAlternativo}"/>
                                            </h:selectOneMenu>
                                        </h:panelGroup>
                                        <h:selectOneMenu value="#{data.especificacionQuimicaGeneral.tipoResultadoDescriptivo.codTipoResultadoDescriptivo}" styleClass="inputText" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}">
                                            <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivo}"/>
                                         </h:selectOneMenu>
                                    </rich:column>
                                    </tr>
                                </table></center>
                          </rich:panel>
                          <rich:panel headerClass="headerClassACliente" rendered="#{data.especificacionQuimicaGeneral.especificacionesFisicasProducto.estado.codEstadoRegistro eq '2'}">
                            <f:facet name="header">
                                <h:outputText value="#{data.nombreEspecificacion}"  />
                            </f:facet>
                             <rich:dataTable value="#{data.listaResultadoAnalisisEspecificacionesQuimicas}" var="data1" id="dataDetalleQuimicos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="width:90%">
                                        <rich:column styleClass="#{data1.colorFila}">
                                         <f:facet name="header">
                                            <h:outputText value="Material"  />
                                            </f:facet>
                                         <h:outputText value="#{data1.especificacionesQuimicasProducto.material.nombreMaterial}"  styleClass="outputText2"/>
                                     </rich:column >
                                     <rich:column styleClass="#{data1.colorFila}">
                                        <f:facet name="header">
                                          <h:outputText value="Especificaciones" />
                                         </f:facet>
                                        <center><h:outputText value="#{data1.especificacionesQuimicasProducto.descripcion}"  rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}"/>
                                        <h:panelGrid columns="3" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}" >
                                         <h:outputText value="#{data1.especificacionesQuimicasProducto.limiteInferior}"  styleClass="outputText2"/>
                                         <h:outputText value="-" styleClass="outputText2"/>
                                        <h:outputText value="#{data1.especificacionesQuimicasProducto.limiteSuperior}"  styleClass="outputText2" />
                                        </h:panelGrid>
                                        <h:panelGrid columns="2" rendered="#{(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1')&&(data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '2')}" >
                                         <h:outputText value="#{data.coeficiente} #{data.tipoResultadoAnalisis.simbolo}" styleClass="outputText2"/>
                                        <h:outputText value="#{data1.especificacionesQuimicasProducto.valorExacto}"  styleClass="outputText2" />
                                        </h:panelGrid></center>
                                    </rich:column >
                                     <rich:column styleClass="#{data1.colorFila}">
                                         <f:facet name="header">
                                            <h:outputText value="referencia"  />
                                            </f:facet>
                                             <h:outputText value="#{data1.especificacionesQuimicasProducto.tiposReferenciaCc.nombreReferenciaCc}"  />
                                     </rich:column>
                                     <rich:column  styleClass="#{data1.colorFila}">
                                         <f:facet name="header">
                                            <h:outputText value="resultados"  />
                                            </f:facet>
                                            <h:panelGroup rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1'}">

                                                    <h:inputText value="#{data1.resultadoNumerico}" onkeypress="valNumero();" styleClass="inputText" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1'}">
                                                    </h:inputText><br>
                                                    <h:selectOneMenu value="#{data1.resultadoDescriptivoAlternativo.codTipoResultadoDescriptivo}"  styleClass="inputText" >
                                                        <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivoAlternativo}"/>
                                                    </h:selectOneMenu>
                                             </h:panelGroup>
                                            <%--rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}"--%>
                                            <h:selectOneMenu value="#{data1.tipoResultadoDescriptivo.codTipoResultadoDescriptivo}" rendered="#{data.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" styleClass="inputText" >
                                                
                                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivo}"/>
                                            </h:selectOneMenu>
                                     </rich:column>
                                    
                             </rich:dataTable>
                            </rich:panel>
                           
                            
                        </rich:column>


                   </rich:dataTable>
                   </rich:panel>
               
                   <rich:panel headerClass="headerClassACliente" style="width:80%">
                    <f:facet name="header">
                        <h:outputText value="Analisis Microbiologico"/>
                    </f:facet>
                    <rich:dataTable value="#{ManagedResultadoAnalisis.listaAnalisisMicrobiologia}" var="data" id="dataEspecificacionesMicrobiologia"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="width:90%">

                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Tipo de Analisis"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.nombreEspecificacion}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Especificaciones"  />
                            </f:facet>
                            <center><h:outputText value="#{data.especificacionesMicrobiologiaProducto.descripcion}" rendered="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}" /></center>
                            <center><h:panelGrid  columns="3" rendered="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '2'}">
                                <h:outputText value="#{data.especificacionesMicrobiologiaProducto.limiteInferior}" styleClass="outputText2"/>
                                <h:outputText value="-" styleClass="outputText2" />
                                <h:outputText value="#{data.especificacionesMicrobiologiaProducto.limiteSuperior}" styleClass="outputText2" />
                            </h:panelGrid></center>
                             <center><h:panelGrid  columns="2" rendered="#{(data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='1')&&(data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis !='2')}">
                                <h:outputText value="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.coeficiente} #{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.simbolo}" styleClass="outputText2" />
                                <h:outputText value="#{data.especificacionesMicrobiologiaProducto.valorExacto}" styleClass="outputText2" />
                            </h:panelGrid></center>
                        </rich:column >
                         <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Referencia"  />
                            </f:facet>
                            <h:outputText value="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tiposReferenciaCc.nombreReferenciaCc}" styleClass="outputText2" />
                        </rich:column >
                        <rich:column styleClass="#{data.colorFila}">
                            <f:facet name="header">
                                <h:outputText value="Resultados"  />
                            </f:facet>
                            <h:panelGroup rendered="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis != '1'}">
                            <h:inputText value="#{data.resultadoNumerico}" onkeypress="valNumero();" styleClass="inputText" >
                                <%--f:convertNumber locale="en" pattern="##0.00"/--%>
                            </h:inputText>
                            <h:selectOneMenu value="#{data.resultadoDescriptivoAlternativo.codTipoResultadoDescriptivo}" styleClass="inputText" >
                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivoAlternativo}"/>
                             </h:selectOneMenu>
                            </h:panelGroup>
                            <h:selectOneMenu value="#{data.tipoResultadoDescriptivo.codTipoResultadoDescriptivo}" styleClass="inputText" rendered="#{data.especificacionesMicrobiologiaProducto.especificacionMicrobiologiaCc.tipoResultadoAnalisis.codTipoResultadoAnalisis eq '1'}">
                                <f:selectItems value="#{ManagedResultadoAnalisis.listaTiposResultadoDescriptivo}"/>
                             </h:selectOneMenu>
                        </rich:column >
                   </rich:dataTable>
                   </rich:panel>
                   <a4j:jsFunction action="#{ManagedResultadoAnalisis.guardarAnalisisControlDeCalidad}" name="guardar" id="guardar" timeout="10000" oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq 'registrado'}){window.location.href='navProgProdResultadoAnalisis.jsf';alert('El analisis se registro satisfactoriamente');}else{alert('#{ManagedResultadoAnalisis.mensaje}');}"/>
               
               <a4j:commandButton value="Guardar" styleClass="btn" timeout="10000" action="#{ManagedResultadoAnalisis.verificarOperacion_Action}" oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq ''}){alert('Ocurrio un problema al momento de contactarse con el servidor, intente de nuevo');}
               else{ if(#{ManagedResultadoAnalisis.mensaje eq '0'}){if(confirm('Esta a punto de aprobar el analisis desea continuar?')==true){guardar();}} else{Richfaces.showModalPanel('panelRechazarAnalisis')};}" reRender="dataEspecificaciones,dataEspecificacionesFisicas,dataEspecificacionesMicrobiologia,dataQuimicos"/>

                  
                     <h:commandButton value="Cancelar"  styleClass="btn" action="#{ManagedResultadoAnalisis.cancelarAnalisisControlDeCalidad}"/>
                      
                    </div>            
                </h:form>
                <rich:modalPanel id="panelRechazarAnalisis" minHeight="350"  minWidth="530"
                                     height="350" width="530"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto" >
                        <f:facet name="header">
                            <h:outputText value="Especificaciones por las cuales puede rechazar el analisis"/>
                        </f:facet>
                        <center>
                        <a4j:form id="form2">
                            <div style="overflow:auto;height:240px">
                            <rich:dataTable value="#{ManagedResultadoAnalisis.lista}" var="data" id="dataEspecificaciones"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';"
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Tipo Especificación"  />
                                    </f:facet>
                                    <h:outputText value="#{data[0]}" styleClass="outputText2"/>
                                </rich:column >
                                <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Especificación"  />
                                    </f:facet>
                                    <h:outputText value="#{data[1]}" styleClass="outputText2"/>
                               </rich:column>
                               <rich:column>
                                    <f:facet name="header">
                                        <h:outputText value="Causa rechazo"  />
                                    </f:facet>
                                    <h:outputText value="#{data[2]}" styleClass="outputText2"/>
                               </rich:column>
                      </rich:dataTable>
                      </div>
                      <br>
                      <a4j:commandButton styleClass="btn" value="Guardar Rechazando el Análisis" onclick="guardar();" timeout="10000"/>
                      <a4j:commandButton styleClass="btn" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelRechazarAnalisis')"  timeout="7200"/>
                        </a4j:form>
                        </center>
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

            </div>    
        </body>
    </html>
    
</f:view>

