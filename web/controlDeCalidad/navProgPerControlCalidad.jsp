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
                    var codLote=document.getElementById("contenidoBuscadorLote:codLoteProduccion").value;
                    if(codLote !='')
                    {
                        return true;
                    }
                    else
                    {
                        if(parseInt(document.getElementById("contenidoBuscadorLote:codProgPer").value)>0)
                            {
                                return true;
                            }
                            else
                            {
                                alert('Debe de introducir un lote para la busqueda o seleccionar uno o varios programas de produccion para poder realizar la busqueda');
                                return false;
                            }
                        
                    }
                    return false;
                }
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
                    
                    
                    <h:outputText value="#{ManagedResultadoAnalisis.cargarProgProdPeriodo}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    

                        <br>
                            <a4j:commandButton  onclick="Richfaces.showModalPanel('panelBuscadorLote')" reRender="contenidoBuscadorLote" image="../img/buscar.png" alt="Buscar Certificado">

                </a4j:commandButton>
                   
                   
                        <h:panelGroup id="contenidoProgramaProduccion">


                        <rich:dataTable value="#{ManagedResultadoAnalisis.programaProduccionPeriodoList}" var="data" id="dataProgramaProduccion"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    style="width=100%" binding="#{ManagedResultadoAnalisis.programaProduccionPeriodoDataTable}"
                                    >
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Produccion"  />
                            </f:facet>
                            <a4j:commandLink styleClass="outputText2" action="#{ManagedResultadoAnalisis.seleccionarProgramaProduccionPeriodoAction}" oncomplete="window.location='navProgProdResultadoAnalisis.jsf'">
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
                    </h:panelGroup>
                    </div>
                    <br/>
           </a4j:form>
           <rich:modalPanel id="panelBuscadorLote" minHeight="250"  minWidth="550"
                                     height="250" width="550"
                                     zindex="4"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Buscar Lote de Produccion"/>
                        </f:facet>
                        <a4j:form id="contenidoBuscadorLote">
                        <h:panelGroup id="contenidoBuscarCertificado">
                            <h:panelGrid columns="3">
                               <h:outputText styleClass="outputTextTitulo"  value="Lote de Producción"  style="font-weight:bold"/>
                               <h:outputText styleClass="outputTextTitulo"  value="::"  style="font-weight:bold"/>
                               <h:inputText value="#{ManagedResultadoAnalisis.loteBuscar}" styleClass="inputText" id="codLoteProduccion" />
                               <h:outputText styleClass="outputTextTitulo"  value="Producto"  style="font-weight:bold"/>
                               <h:outputText styleClass="outputTextTitulo"  value="::"  style="font-weight:bold"/>
                               <h:selectOneMenu value="#{ManagedResultadoAnalisis.codCompProdBuscar}" id="codCompProd" styleClass="inputText">
                                   <f:selectItems value="#{ManagedResultadoAnalisis.componentesProdSelectList}"/>
                               </h:selectOneMenu>
                               <h:outputText styleClass="outputTextTitulo"  value="Programa Producción"  style="font-weight:bold"/>
                               <h:outputText styleClass="outputTextTitulo"  value="::"  style="font-weight:bold"/>
                               <h:selectManyListbox size="5" value="#{ManagedResultadoAnalisis.codProgramaProdPerSeleccionado}" id="codProgPer" styleClass="inputText">
                                   <f:selectItems value="#{ManagedResultadoAnalisis.programaProdPeriodoSelectList}"/>
                               </h:selectManyListbox>
                           </h:panelGrid>
                           <center style="margin-top:12px;">
                               <a4j:commandButton action="#{ManagedResultadoAnalisis.buscarLote_Action}" onclick="if(!validarBusqueda()){return false;}" styleClass="btn" value="Buscar" reRender="dataProgramaProduccion" oncomplete="location='navProgProdResultadoAnalisis.jsf?codProgramaProd=#{data.codProgramaProduccion}'"/>
                           </center>
                        </h:panelGroup>
                    </a4j:form>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

