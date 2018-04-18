
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
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
            <script  type="text/javascript">
                
         </script>
        </head>
        
        <body   > 
            <a4j:form id="form1" >
                <rich:panel id="panelEstadoCuentas" styleClass="panelBuscar" style="top:50px;left:50px;width:700px;">
                    <f:facet name="header">
                        <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelEstadoCuentas');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"document.getElementById('form1:panelEstadoCuentas').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                              escape="false" />
                    </f:facet>
                </rich:panel>
                
                <div align="center">
                    
                    
                    <h:outputText value="#{ManagedSeguimientoProcesosPorLote.cargarProgProdPeriodo}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    

                        <br>
                   
                   <h:panelGrid columns="3">
                       <h:outputText styleClass="outputTextTitulo"  value="Lote de Producción:" />
                       <h:inputText value="#{ManagedSeguimientoProcesosPorLote.loteBuscar}" styleClass="inputText"/>
                       <a4j:commandButton action="#{ManagedSeguimientoProcesosPorLote.buscarLote_Action}" styleClass="btn" value="Buscar" oncomplete="var a='navProgProdProcesos.jsf?aleatorio='+Math.random();window.location=a"/>
                   </h:panelGrid>
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedSeguimientoProcesosPorLote.programaProduccionPeriodoList}" var="data" id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    style="width=100%" binding="#{ManagedSeguimientoProcesosPorLote.progPerEspecificacionesProcesos}"
                                    >
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <a4j:commandLink styleClass="outputText2" action="#{ManagedSeguimientoProcesosPorLote.seleccionarProgramaPeriodo_action}" 
                            oncomplete="var a='navProgProdProcesos.jsf?aleatorio='+Math.random();window.location.href=a">
                            <h:outputText value="#{data.nombreProgramaProduccion}"  />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"/>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column>
                                                

                    </rich:dataTable>
                    </h:panelGroup>
                    </div>
                    <br/>
           </a4j:form>
        </body>
    </html>
    
</f:view>

