<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
 <script>
               function mostrar()
               {
                   javascript:Richfaces.showModalPanel('panelFiltro');
               }
               function mostrar2()
               {
                   javascript:Richfaces.showModalPanel('panelCambiarEstado');
               }
                function validar(nametable){
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
                    if(count==1){
                        return true;
                    } else if(count==0){
                        alert('No escogio ningun registro');
                        return false;
                    }
                    else if(count>1){
                        alert('Solo puede escoger un registro');
                        return false;
                    }
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
    <html>
        <head >
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
          
        </head>
       <body onload="mostrar()">
            <a4j:form id="form1">
                <div align="center">
                   
                     <h:outputText value="#{ManagedEstadosProgramaProduccion.cargarProgramasProduccion}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Terminar/Cancelar Lote en Programa de Produccion" />
                    <br><br>
                   
                        
                        <h:panelGroup id="contenidoProgramaProduccion">
                        <rich:dataTable value="#{ManagedEstadosProgramaProduccion.programaProduccionList}"
                        var="data" id="dataProgramaProduccion"
                        headerClass="headerClassACliente"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';">

                        <rich:column styleClass="#{data.styleClass}" >
                            <f:facet name="header">
                                <h:outputText value=""  />

                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />


                        </rich:column >
                       <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.formulaMaestra.componentesProd.nombreProdSemiterminado}"  />
                        </rich:column>
                         <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Lote"  />
                            </f:facet>
                            <h:outputText value="#{data.codLoteProduccion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.programaProduccionPeriodo.nombreProgramaProduccion}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Producción"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha Pesaje"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaInicio}"  />
                        </rich:column>
                        <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Fecha Vencimiento"  />
                            </f:facet>
                            <h:outputText value="#{data.fechaFinal}"  />
                        </rich:column>
                        
                         <rich:column  >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoProgramaProduccion.nombreEstadoProgramaProd}"  />

                        </rich:column>


                    </rich:dataTable>
                    </h:panelGroup>

                    <a4j:commandButton  value="Cambiar Estado" styleClass="btn" onclick="if(validar('form1:dataProgramaProduccion')){mostrar2();}"  action="#{ManagedEstadosProgramaProduccion.cambiarEstadoAction}"  reRender="contenidoCambioEstado"
                    
                       />
                   <a4j:commandButton  value="Filtrar" styleClass="btn" onclick="mostrar()"/>

            </a4j:form>
            <rich:modalPanel id="panelCambiarEstado"
                                     minHeight="300"  minWidth="400"
                                     height="300" width="400" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Cambio de Estado" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form3">
                            <h:panelGroup id="contenidoCambioEstado">

                            <rich:panel headerClass="headerClassACliente">
                                <f:facet name="header">
                                    <h:outputText value="Datos de Programa Produccion" />
                                </f:facet>
                                <h:panelGrid columns="2">
                                    <h:outputText styleClass="outputTextTitulo"  value="Programa de Produccion:" />
                                    <h:outputText styleClass="outputTextTitulo"  value="#{ManagedEstadosProgramaProduccion.programaProduccionCambio.programaProduccionPeriodo.nombreProgramaProduccion}" />
                                    <h:outputText styleClass="outputTextTitulo"  value="Producto:" />
                                    <h:outputText styleClass="outputTextTitulo"  value="#{ManagedEstadosProgramaProduccion.programaProduccionCambio.formulaMaestra.componentesProd.nombreProdSemiterminado}" />
                                    <h:outputText styleClass="outputTextTitulo"  value="Lote:" />
                                    <h:outputText styleClass="outputTextTitulo"  value="#{ManagedEstadosProgramaProduccion.programaProduccionCambio.codLoteProduccion}" />
                                    <h:outputText styleClass="outputTextTitulo"  value="Tipo Programa Produccion:" />
                                    <h:outputText styleClass="outputTextTitulo"  value="#{ManagedEstadosProgramaProduccion.programaProduccionCambio.tiposProgramaProduccion.nombreTipoProgramaProd}" />
                                </h:panelGrid>
                        </rich:panel>
                        <h:panelGrid columns="2">
                        <h:outputText styleClass="outputTextTitulo"  value="Estado:" />
                        <h:selectOneMenu value="#{ManagedEstadosProgramaProduccion.programaProduccionCambio.estadoProgramaProduccion.codEstadoProgramaProd}">
                            <f:selectItems value="#{ManagedEstadosProgramaProduccion.estadosProgramaCambiar}"/>
                        </h:selectOneMenu>

                        </h:panelGrid>

                        <a4j:commandButton  value="Aceptar" styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelCambiarEstado')"   action="#{ManagedEstadosProgramaProduccion.guardarCambioEstadoAction}" oncomplete="if('#{ManagedEstadosProgramaProduccion.mensaje}'!=''){alert('#{ManagedEstadosProgramaProduccion.mensaje}')}" reRender="contenidoProgramaProduccion" />
                       <a4j:commandButton  value="Cancelar" styleClass="btn" onclick="javascript:Richfaces.hideModalPanel('panelCambiarEstado')"   />
                       </h:panelGroup>

                        </a4j:form>
                        </div>
                    </rich:modalPanel>



                 <rich:modalPanel id="panelFiltro"
                                     minHeight="300"  minWidth="600"
                                     height="300" width="600" zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false">
                        <f:facet name="header">
                            <h:outputText value="Terminar/Cancelar Lote en Programa de Produccion" />
                        </f:facet>
                        <div align="center">
                        <a4j:form id="form2">
                        <h:panelGrid columns="2">
                        <h:outputText styleClass="outputTextTitulo"  value="Programa de Produccion:" />
                        <h:panelGroup id="contenidoFiltro">
                            <h:selectManyListbox value="#{ManagedEstadosProgramaProduccion.codProgramaProd}" styleClass="outputText2" size="10" >
                            <f:selectItems value="#{ManagedEstadosProgramaProduccion.programaPeriodoList}" />

                                </h:selectManyListbox>
                        </h:panelGroup>
                        <h:outputText styleClass="outputTextTitulo"  value="Estado:" />
                        <h:selectOneMenu value="#{ManagedEstadosProgramaProduccion.codEstado}" styleClass="inputText">
                            <f:selectItems value="#{ManagedEstadosProgramaProduccion.estadosProgramaProdList}"/>
                        </h:selectOneMenu>

                        </h:panelGrid>
                        
                        <a4j:commandButton  value="Aceptar" styleClass="btn"
                        action="#{ManagedEstadosProgramaProduccion.mostrarResultadosFiltroAction}"
                        reRender="contenidoProgramaProduccion"  timeout="40000"
                        oncomplete="javascript:Richfaces.hideModalPanel('panelFiltro')"
                          />
                          </a4j:form>

                        </div>
                        
                    </rich:modalPanel>
                   <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="2000" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>


                        <%--final ale devoluciones--%>
                    


        </body>
    </html>

</f:view>

