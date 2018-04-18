

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
            <script  type="text/javascript">
                function validarBusqueda()
                {
                    if(document.getElementById("form2:loteProduccion").value =='')
                    {
                        
                    }
                    return true;
                }
         </script>
        </head>
        
        <body>
            <a4j:form id="form1" onreset="alert('hola')"  oncomplete="Richfaces.showModalPanel('panelTipoSalidaAlmacenProduccion');" >
                <rich:panel id="panelEstadoCuentas" styleClass="panelBuscar" style="top:50px;left:50px;width:700px;">
                    <f:facet name="header">
                        <h:outputText value="<div   onmouseover=\"this.style.cursor='move'\" onmousedown=\"comienzoMovimiento(event, 'form1:panelEstadoCuentas');\"  >Buscar<div   style=\"margin-left:550px;\"   onclick=\"document.getElementById('form1:panelEstadoCuentas').style.visibility='hidden';document.getElementById('panelsuper').style.visibility='hidden';\" onmouseover=\"this.style.cursor='hand'\"   >Cerrar</div> </div> "
                              escape="false" />
                    </f:facet>
                </rich:panel>
                
                <div align="center">
                    
                    
                    <h:outputText value="#{ManagedControlCalidadOS.cargarContenidoProgramaProduccionPeriodo}"  />
                    <h:outputText styleClass="outputText2" style="font-weight:bold;font-size:16px"  value="Programas de Producción" />
                    

                        <br>
                    
                        <br>Buscar
                        <a4j:commandLink oncomplete="Richfaces.showModalPanel('panelBuscarLoteProduccion')" reRender="contenidoBuscarLoteProduccion" >
                                <h:graphicImage url="../img/buscar.png" />
                        </a4j:commandLink>
                        
                        <h:panelGroup id="contenidoProgramaProduccion">

                        <center>
                        <rich:dataTable value="#{ManagedControlCalidadOS.programaProduccionPeriodoList}" var="data" id="dataProgramaPeriodo"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" binding="#{ManagedControlCalidadOS.programaProduccionPeriodoDataTable}"
                                    style="width=100%"
                                    >
                       
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <a4j:commandLink styleClass="outputText2" action="#{ManagedControlCalidadOS.seleccionarProgramaProduccionPeriodo_action}" oncomplete="var a=Math.random();window.location.href='navegadorProgramaProduccionOS.jsf?coda='+a">
                            <h:outputText value="#{data.nombreProgramaProduccion}"  />
                            </a4j:commandLink>
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Observacion"  />
                            </f:facet>
                            <h:outputText value="#{data.obsProgramaProduccion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />
                        </rich:column>
                                                

                    </rich:dataTable>
                    </center>
                    </h:panelGroup>


                    <br/>
                </div>

                <h:outputText value="#{ManagedFormulaMaestra.closeConnection}"  />


            </a4j:form>
            
            <rich:modalPanel id="panelBuscarLoteProduccion"  minHeight="420"  minWidth="600"
                                     height="420" width="600"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value=" Buscar Lote de Produccion "/>
                        </f:facet>
                        <a4j:form id="form2">
                        <h:panelGroup id="contenidoBuscarLoteProduccion">
                            <div align="center">
                            <h:panelGrid columns="3">
                                <h:outputText value="Lote " styleClass="outputText2" style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2"style='font-weight:bold'  />
                                <h:inputText id="loteProduccion" value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalBuscar.seguimientoProgramaProduccion.programaProduccion.codLoteProduccion}" styleClass="inputText"  />
                                <h:outputText value="Tipo Programa Prod" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectOneMenu id="codTipoProgramaProd" value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalBuscar.seguimientoProgramaProduccion.programaProduccion.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedControlCalidadOS.tiposProgrProdSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Estado Programa Prod" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectOneMenu id="codEstadoPrograma"  value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalBuscar.seguimientoProgramaProduccion.programaProduccion.estadoProgramaProduccion.codEstadoProgramaProd}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedControlCalidadOS.estadosProgramaProdSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Area Empresa" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectOneMenu id="codAreaPrograma" value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalBuscar.seguimientoProgramaProduccion.programaProduccion.formulaMaestra.componentesProd.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                    <a4j:support event="onchange" action="#{ManagedControlCalidadOS.areasEmpresa_change}" reRender="producto"/>
                                    <f:selectItems value="#{ManagedControlCalidadOS.areasEmpresaSelectList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Producto" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectOneMenu id="codProducto" value="#{ManagedControlCalidadOS.seguimientoProgramaProduccionPersonalBuscar.seguimientoProgramaProduccion.programaProduccion.formulaMaestra.componentesProd.codCompprod}" styleClass="inputText">
                                    <f:selectItems value="#{ManagedControlCalidadOS.componentesProdSelectList}"/>
                                </h:selectOneMenu>
                                 <h:outputText value="Programa Produccion" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectManyListbox  id="codProgramaProdBuscar" value="#{ManagedControlCalidadOS.codProgramaProduccion}"  size="5" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedControlCalidadOS.programaProduccionSelectList}"/>
                                 </h:selectManyListbox>
                                 <h:outputText value="Estado Registro OOS" styleClass="outputText2"style='font-weight:bold' />
                                <h:outputText value="::" styleClass="outputText2" style='font-weight:bold' />
                                <h:selectOneMenu id="codEstadoOOs"  value="#{ManagedControlCalidadOS.estadoRegistroOOS}" styleClass="inputText">
                                    <f:selectItem itemLabel="--TODOS--" itemValue='0'/>
                                    <f:selectItem itemLabel="Posibles OOS" itemValue='1'/>
                                    <f:selectItem itemLabel="Registrados" itemValue='2'/>

                                </h:selectOneMenu>
                            </h:panelGrid>
                            <a4j:commandButton value="Aceptar" action="#{ManagedControlCalidadOS.buscarLotesProgramaProduccion_action}" oncomplete = "var ad=Math.random();window.location.href='navegadorProgramaProduccionOS.jsf?ad'+ad;" styleClass="btn"/>
                                 <input value="Cancelar" onclick="Richfaces.hideModalPanel('panelBuscarLoteProduccion')" class="btn" type="button" />


                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

