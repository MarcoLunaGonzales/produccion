

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
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }          
                .a1{
                  background-color:#98FB98;
                }
                .a2{
                  background-color:#FFB6C1;
                }
                
            </style>
            <script  type="text/javascript">
                
         </script>
        </head>
        
        <body   > 
            <a4j:form id="form1" >
                <div align="center">
                   
                    <h:outputText value="#{ManagedResultadoAnalisis.cargarResultadoAnalisis}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Revisión de Certificados de Control de Calidad" />
                        <br></br>
                        <table>
                            <tr>
                                <td><span class="outputText2">Aprobado</span></td><td class="a1" style="width:70px;height:20px"></td>
                                <td><span class="outputText2">Rechazado</span></td><td class="a2" style="width:70px;height:20px"></td>
                            </tr>
                        </table>
                        <h:panelGroup id="contenidoProgramaProduccion">

                        <a4j:commandButton  onclick="Richfaces.showModalPanel('PanelBuscarCertificado')" image="../img/buscar.png" alt="Buscar Certificado">
                            
                        </a4j:commandButton>
                        <rich:dataTable value="#{ManagedResultadoAnalisis.resultadosAnalisisList}" var="data" id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    style="width=100%"
                                    >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column rowspan="2">
                                    <h:outputText value=""  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText style="filter:glow(color=red, strength=5);" value="Nro Analisis<br> Físico<br> Químico" escape="false" />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Nro Analisis Microbiológico"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Lote "  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Fecha<br>Emision" escape="false"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Fecha<br> Revision"  escape="false" />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Producto"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Producto Semiterminado" escape="false"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Analista"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tomo"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Pagina"  />
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Estado"  />
                                </rich:column>
                                <%--rich:column colspan="3">
                                    <h:outputText value="Nro Version"  />
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="F."  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Q."  />
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="M."  />
                                </rich:column--%>
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                       <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.nroAnalisis}"/>
                        </rich:column>
                         <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.nroAnalisisMicrobiologico}"  />
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.codLote}"  styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                              <h:outputText value="#{data.fechaEmision}"  styleClass="outputText2" rendered="#{data.fechaEmision !=null}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                              <h:outputText value="#{data.fechaRevision}"  styleClass="outputText2" rendered="#{data.fechaRevision !=null}">
                                <f:convertDateTime pattern="dd/MM/yyyy"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.componenteProd.nombreComercial}"  styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.componenteProd.nombreProdSemiterminado}"  styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.personalAnalista.nombrePersonal}" styleClass="outputText2"/>
                        </rich:column>
                         <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.tomo}" styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.pagina}" styleClass="outputText2"/>
                        </rich:column>
                        
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.estadoResultadoAnalisis.nombreEstadoResultadoAnalisis}"  styleClass="outputText2"/>
                        </rich:column>
                        <%--rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.versionEspecificacionFisica.nroVersionEspecificacionProducto}"  styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.versionEspecificacionQuimica.nroVersionEspecificacionProducto}"  styleClass="outputText2"/>
                        </rich:column>
                        <rich:column styleClass="a#{data.colorFila}" >
                            <h:outputText value="#{data.versionEspecificacionMicrobiologica.nroVersionEspecificacionProducto}"  styleClass="outputText2"/>
                        </rich:column--%>

                    </rich:dataTable>
                    <div style="margin-top:5px;">
                        <a4j:commandLink id="masAction" reRender="contenidoProgramaProduccion" style="margin-right:4px;" action="#{ManagedResultadoAnalisis.anteriorPagina_action}" rendered="#{ManagedResultadoAnalisis.begin>1}">
                             <h:graphicImage url="../img/previous.gif" alt="PAGINA ANTERIOR"/>
                        </a4j:commandLink>
                        <a4j:commandLink id="menosAction" reRender="contenidoProgramaProduccion" style="margin-left:4px;" action="#{ManagedResultadoAnalisis.siguientePagina_action}" rendered="#{ManagedResultadoAnalisis.cantidadfilas>= 20}">
                             <h:graphicImage url="../img/next.gif" alt="PAGINA SIGUIENTE"/>
                         </a4j:commandLink>
                    </div>
                    </h:panelGroup>
                    <a4j:commandButton action="#{ManagedResultadoAnalisis.revisarResultadoAnalisis_action}" value="Revisar" styleClass="btn"
                                       oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq '1'}){var b=new Date();var a=Math.random();window.location='navegadorRevisarResultadoAnalisis.jsf?ad='+a+'&norepet='+b.getTime().toString();}
                                       else{alert('#{ManagedResultadoAnalisis.mensaje}')}"/>
                    </div>
                    <br/>
           </a4j:form>
           <rich:modalPanel id="PanelBuscarCertificado" minHeight="300"  minWidth="700"
                                     height="300" width="700"
                                     zindex="4"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Buscar Certificado CC"/>
                        </f:facet>
                        <a4j:form id="formRegistrar">
                        <h:panelGroup id="contenidoBuscarCertificado">
                            <h:panelGrid columns="6">
                                <h:outputText value="Lote" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.codLote}" styleClass="inputText"  />
                                <h:outputText value="" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="Nro Analisis Físico Químico" styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.nroAnalisis}" styleClass="inputText"  />
                                
                                
                                <h:outputText value="Nro Analisis Microbiológico" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.nroAnalisisMicrobiologico}" styleClass="inputText" id="nombreUnidad"  />
                                
                                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.componenteProd.producto.nombreProducto}" styleClass="inputText"  />
                                <h:outputText value="Producto Semiterminado" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.componenteProd.nombreProdSemiterminado}" styleClass="inputText"  />

                               <h:outputText value="Analista" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                               <h:selectOneMenu value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.personalAnalista.codPersonal}" styleClass="inputText" >
                                   <f:selectItems value="#{ManagedResultadoAnalisis.analistasList}"/>
                               </h:selectOneMenu>
                               <h:outputText value="Tomo" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                               <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.tomo}" styleClass="inputText"  />
                                <h:outputText value="Pagina" styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.pagina}" styleClass="inputText"  />
                               <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                               <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                               <h:selectOneMenu value="#{ManagedResultadoAnalisis.resultadoAnalisisBuscar.estadoResultadoAnalisis.codEstadoResultadoAnalisis}" styleClass="inputText" >
                                   <f:selectItems value="#{ManagedResultadoAnalisis.estadosResultadosList}"/>
                               </h:selectOneMenu>
                                <h:outputText value="De Fecha de Emisión " styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText  styleClass="outputText2"  value="::"style="font-weight:bold"/>
                                <rich:calendar  datePattern="dd/MM/yyyy" styleClass="inputText" zindex="200" value="#{ManagedResultadoAnalisis.fechaInicioEmision}" id="fechaInicioEmision" style="width:100%" enableManualInput="true"   />
                                <h:outputText value="A Fecha de Emisión " styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                                <rich:calendar  datePattern="dd/MM/yyyy" styleClass="inputText" zindex="200" value="#{ManagedResultadoAnalisis.fechaFinalEmision}" id="fechaFinalEmision" enableManualInput="true"   />
                                <h:outputText value="De Fecha de Revisión " styleClass="outputText2" style="font-weight:bold"/>
                                <h:outputText  styleClass="outputText2"  value="::"style="font-weight:bold"/>
                                <rich:calendar  datePattern="dd/MM/yyyy" styleClass="inputText" zindex="200" value="#{ManagedResultadoAnalisis.fechaInicioRevision}" id="fechaInicioRevision" style="width:100%" enableManualInput="true"   />
                                <h:outputText value="A Fecha de Revisión " styleClass="outputText2" style="font-weight:bold" />
                                <h:outputText  styleClass="outputText2"  value="::" style="font-weight:bold"/>
                                <rich:calendar  datePattern="dd/MM/yyyy" styleClass="inputText" zindex="200" value="#{ManagedResultadoAnalisis.fechaFinalRevision}" id="fechaFinalRevision"  enableManualInput="true"   />



                            </h:panelGrid>
                                <div align="center">
                                    <a4j:commandButton styleClass="btn" value="Buscar"  action="#{ManagedResultadoAnalisis.buscarResultadoAnalisis_action}"
                                    reRender="dataProgramaProduccion" oncomplete="javascript:Richfaces.hideModalPanel('PanelBuscarCertificado')"/>
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('PanelBuscarCertificado')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>
             <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        </body>
    </html>
    
</f:view>

