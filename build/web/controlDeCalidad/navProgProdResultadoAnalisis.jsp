

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
            </style>
            <script type="text/javascript">
                function verificarAutorizacion()
                {
                    var cod=document.getElementById("formRegistrar:codigo").innerHTML;
                    var var1=cod.substring(0,1);
                    var var2=cod.substring(cod.length-1,cod.length);
                    var sum=0;
                    for(var cont=0;cont<=cod.length-1;cont++)
                    {
                        sum+=parseInt(cod.substring(cont, cont+1));
                    }
                    var cod=sum+var2+var1;
                    if(cod==document.getElementById("formRegistrar:autorizacion").value)
                    {
                        window.location.href='agregarResultadoAnalisis.jsf';
                    }
                    else
                    {
                        alert('Autorización invalida');
                    }
                }
            </script>
        </head>
        
            
            
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedResultadoAnalisis.cogerCodProgProdPeriodo}"  />
                    <rich:panel headerClass="headerClassACliente" style="width:60%">
                        <f:facet name="header">
                            <h:outputText value="Datos del Programa Produccion"/>
                        </f:facet>
                        <h:panelGrid columns="3">
                            <h:outputText value="Programa Produccion" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedResultadoAnalisis.programaProduccionbean.programaProduccionPeriodo.nombreProgramaProduccion}" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codProgramaProduccion != '0'}" styleClass="outputText2" />
                            <h:outputText value="Por Busqueda" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codProgramaProduccion eq '0'}" styleClass="outputText2" />
                            <h:outputText value="Lote Produccion" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codLoteProduccion != ''}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codLoteProduccion != ''}"/>
                            <h:outputText value="#{ManagedResultadoAnalisis.programaProduccionbean.codLoteProduccion}" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codLoteProduccion != ''}" styleClass="outputText2" />
                        </h:panelGrid>

                    </rich:panel>
                    <br><br>
                  
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedResultadoAnalisis.programaProduccionList}" var="data" id="dataProgramaproduccionList"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedResultadoAnalisis.progProdResultadoAnalisDataTable}">
                       <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Producto " escape="false" />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreComercial}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Producto<br> Semiterminado" escape="false" />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" rendered="#{ManagedResultadoAnalisis.programaProduccionbean.codProgramaProduccion eq '0'}">
                            <f:facet name="header">
                                <h:outputText value="Programa<br> Produccion" escape="false" />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccionPeriodo.nombreProgramaProduccion}"  />
                        </rich:column>
                        
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Nro de Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </rich:column >
                        
                        <rich:column  styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}"  >
                            <f:facet name="header">
                                <h:outputText value="Categoría"  />
                            </f:facet>
                            <h:outputText value="#{data.categoriasCompProd.nombreCategoriaCompProd}"  />
                        </rich:column >
                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header" >
                                <h:outputText value="Area"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>

                        <rich:column  styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Observaciones"  />
                            </f:facet>
                            <h:outputText value="#{data.observacion}" />
                        </rich:column >
                        <rich:column  styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </rich:column >
                       <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Analisis de Control de Calidad"  />
                            </f:facet>
                            
                             <a4j:commandLink styleClass="outputText2" action="#{ManagedResultadoAnalisis.agregarControlDeCalidad}" 
                             oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq ''}){window.location.href='agregarResultadoAnalisis.jsf'}
                             else{if(#{ManagedResultadoAnalisis.mensaje eq '-1'}){alert('No se pueden modificar certificados registrados con el anterior versionamiento');}else{if(#{ManagedResultadoAnalisis.mensaje eq '2'}){Richfaces.showModalPanel('panelAutorizacion');}
                             else{if(confirm('#{ManagedResultadoAnalisis.mensaje}')==true){window.location.href='agregarResultadoAnalisis.jsf';}}}}"
                             reRender="contenidoAutorizacion" >
                                 <h:graphicImage url="../img/detalle.jpg" title="Analisis de Control de Calidad"/>
                             </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    <br>
                    <button class="btn" onclick="window.location='navProgPerControlCalidad.jsf'">Cancelar</button>
                    <a4j:jsFunction action="#{ManagedResultadoAnalisis.mostrarAnalisisControlDeCalidad}" name="showPage" id="showPage"/>
                    <br>
                    </h:panelGroup>
                    </div>
                    </a4j:form>
                            <rich:modalPanel id="panelAutorizacion" minHeight="140"  minWidth="370"
                                             height="140" width="370"
                                             zindex="200"
                                             headerClass="headerClassACliente"
                                             resizeable="false" style="overflow :auto" >
                                <f:facet name="header">
                                    <h:outputText value="Autorizacion para Edicion de Certificados Aprobados"/>
                                </f:facet>
                                <a4j:form id="formRegistrar">
                                    <center>
                                <h:panelGroup id="contenidoAutorizacion">
                                    <h:panelGrid columns="3">
                                        <h:outputText value="Codigo" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedResultadoAnalisis.codigoAleatorio}" styleClass="outputText2" style="font-weight:bold" id="codigo"/>
                                        <h:outputText value="Autorización" styleClass="outputText2" style="font-weight:bold" />
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:inputText value="#{ManagedResultadoAnalisis.autorizacion}" styleClass="inputText" id="autorizacion"/>
                                        
                                    </h:panelGrid>
                                        
                                            <input type="button" value="Aceptar" onclick="verificarAutorizacion();" class="btn" />
                                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAutorizacion');" class="btn" />
                                        </center>
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

