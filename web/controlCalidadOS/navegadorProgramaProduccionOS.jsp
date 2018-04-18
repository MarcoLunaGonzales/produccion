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
                .oos
                {
                   background-color:#90EE90;
                }
            </style>
            <script  type="text/javascript">
                function openPopup(url){
                       window.open(url,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                }
                function verFormatoImpresionOOS(codRegistroOOS)
                {
                    urlOOS="reporteOOSControlCalidad.jsf?codRegistroOOS="+codRegistroOOS+"&date="+(new Date()).getTime().toString()+"&ale="+Math.random();
                    window.open(urlOOS,'detalle'+Math.round((Math.random()*1000)),'top=50,left=200,width=800,height=600,scrollbars=1,resizable=1');
                    
                }
                A4J.AJAX.onError = function(req,status,message){
                window.alert("Ocurrio un error "+message+" continue con su transaccion ");
                }
                A4J.AJAX.onExpired = function(loc,expiredMsg){
                if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
                return loc;
                } else {
                return false;
                }
                }
         </script>
        </head>
             <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedControlCalidadOS.cargarProgramaProduccion}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />

                        <rich:panel style="width:50%;margin-top:12px; " headerClass="headerClassACliente">
                            <f:facet name="header">
                                <h:outputText value="Datos del Programa Produccion"/>
                            </f:facet>
                                <h:panelGrid columns="3">
                                    <h:outputText value="Programa produccion" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.nombreProgramaProduccion}" rendered="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.codProgramaProduccion !=''}" styleClass="outputText2" />
                                    <h:outputText value="Por Busqueda" rendered="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.codProgramaProduccion  eq ''}" styleClass="outputText2" />

                                    <h:outputText value="Observaciones" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value=":" styleClass="outputText2" style="font-weight:bold"/>
                                    <h:outputText value="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.obsProgramaProduccion}" rendered="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.codProgramaProduccion !=''}" styleClass="outputText2" />
                                    <h:outputText value="Todos los lotes de produccion que cumplen con los parametros de la busqueda" rendered="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.codProgramaProduccion  eq ''}" styleClass="outputText2" />
                                </h:panelGrid>
                        </rich:panel>
                        <h:panelGroup id="contenidoProgramaProduccion">
                         <table>
                             <tr>
                                 <td>
                                     <span class="outputText2" style="font-weight:bold">Lotes con OOS&nbsp;</span>
                                 </td>
                                 <td style="width:4em" class="oos">
                                    &nbsp;
                                 </td>
                             </tr>
                         </table>

                        <rich:dataTable value="#{ManagedControlCalidadOS.programaProduccionList}" style="margin-top:12px;" var="data" id="dataFormula"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedControlCalidadOS.programaProduccionDataTable}">
                      

                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.checked?'oos':''}" rendered="#{ManagedControlCalidadOS.programaProduccionPeriodoSeleccionado.codProgramaProduccion eq ''}" >
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccionPeriodo.nombreProgramaProduccion}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidadLote}"  />
                        </rich:column>
                       
                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Nro de Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </rich:column >
                        
                        <rich:column  styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreProgramaProd}" />
                        </rich:column >
                      


                      
                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header" >
                                <h:outputText value="Area"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"/>
                        </rich:column>

                        
                        <rich:column  styleClass="#{data.checked?'oos':''}">
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}" />
                        </rich:column >
                       <rich:column  styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Correlativo<br>Registro OOS" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.registroOOS.correlativoOOS}" />
                        </rich:column >
                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Registro OOS"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedControlCalidadOS.seleccionarProgramaProduccion}" oncomplete="redireccionar('registroControlCalidadOOS.jsf');">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Control OS" />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column styleClass="#{data.checked?'oos':''}" >
                            <f:facet name="header">
                                <h:outputText value="Impresion"  />
                            </f:facet>
                            <a4j:commandLink oncomplete="verFormatoImpresionOOS('#{data.registroOOS.codRegistroOOS}');" rendered="#{data.registroOOS.codRegistroOOS>0}">
                                <h:graphicImage url="../img/organigrama3.jpg" alt="Control OS" />
                            </a4j:commandLink>
                        </rich:column>

                    </rich:dataTable>
                    
                    <br>
                   
                    </h:panelGroup>
                   
                    

            </a4j:form>
            
            
        </body>
    </html>
    
</f:view>

