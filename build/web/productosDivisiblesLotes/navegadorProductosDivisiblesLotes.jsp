<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <link rel="STYLESHEET" type="text/css" href="../css/chosen.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <script>
                function validarRegistro()
                {
                    if(document.getElementById("form4:codComprodAsociado").value!=document.getElementById("form4:codComprod").value)
                        {
                            return true;
                        }
                    else
                        {
                            alert('El producto y el producto asociado no pueden ser los mismos');
                            return false;
                        }
                        return false;
                }
            </script>
          
        </head>
        <body >
          <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedProductosDivisionLotes.cargarProductosDivisiblesLotes}"/>
                    <h:outputText styleClass="outputTextTituloSistema"  value="PRODUCTOS PARA DIVISION DE LOTES" />
                    
                    <rich:dataTable value="#{ManagedProductosDivisionLotes.productosDivisionLotesList}"
                                    var="data"
                                    id="dataProductosDivisibles"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente" >
                        <f:facet name="header">
                            <rich:columnGroup>
                                <rich:column colspan="2">
                                    <h:outputText value="Producto Base"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Tipo Programa de Producción"/>
                                </rich:column>
                                <rich:column colspan="2">
                                    <h:outputText value="Producto Alternativo"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Cantidad<br/>Lotes<br/>Asociados" escape="false"/>
                                </rich:column>
                                <rich:column rowspan="2">
                                    <h:outputText value="Eliminar"/>
                                </rich:column>
                                <rich:column breakBefore="true">
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Tamaño Lote"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Nombre"/>
                                </rich:column>
                                <rich:column >
                                    <h:outputText value="Tamaño Lote"/>
                                </rich:column>
                                
                            </rich:columnGroup>
                        </f:facet>
                        <rich:column >
                            <h:outputText value="#{data.componentesProd.nombreProdSemiterminado}" />
                        </rich:column>
                        <rich:column styleClass="tdRight">
                            <h:outputText value="#{data.componentesProd.tamanioLoteProduccion}">
                                <f:convertNumber pattern="#,##0" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"/>
                        </rich:column>
                        <rich:column >
                            <h:outputText value="#{data.componentesProdAsociado.nombreProdSemiterminado}" />
                        </rich:column>
                        <rich:column styleClass="tdRight">
                            <h:outputText value="#{data.componentesProdAsociado.tamanioLoteProduccion}">
                                <f:convertNumber pattern="#,##0" locale="en"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{data.cantidadLotesCreados}"/>
                        </rich:column>
                        <rich:column>
                            <a4j:commandButton value="Eliminar" styleClass="btn" rendered="#{data.cantidadLotesCreados eq 0}"
                                               action="#{ManagedProductosDivisionLotes.eliminarProductoDivisibleAction(data.codProductoDivisionLote)}"
                                               oncomplete="mostrarMensajeTransaccion()"
                                               reRender="dataProductosDivisibles">
                            </a4j:commandButton>
                        </rich:column>
                       
                    </rich:dataTable>
                    <a4j:commandButton value="Registrar" styleClass="btn" action="#{ManagedProductosDivisionLotes.nuevoRegistroAction}" oncomplete="Richfaces.showModalPanel('PanelRegistrarProductosDivisibles')" reRender="contenidoRegistrarProductosDivisionLotes" />
                </div>
                
            </a4j:form>
             <rich:modalPanel id="PanelRegistrarProductosDivisibles" minHeight="200"  minWidth="715"
                                     height="200" width="715"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Registrar Producto Alternativo"/>
                        </f:facet>
                        <a4j:form id="form4">
                            <center>
                        <h:panelGroup id="contenidoRegistrarProductosDivisionLotes">

                            <h:panelGrid columns="4">

                                <h:outputText value="Producto:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedProductosDivisionLotes.productosDivisionLotesNuevo.componentesProd.codCompprod}" 
                                                 styleClass="inputText chosen" style="width:340px" id="codComprod">
                                    <f:selectItems value="#{ManagedProductosDivisionLotes.componentesProdList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Tipo Programa Producción:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedProductosDivisionLotes.productosDivisionLotesNuevo.tiposProgramaProduccion.codTipoProgramaProd}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProductosDivisionLotes.tiposProgramaProduccionList}"/>
                                </h:selectOneMenu>
                                <h:outputText value="Producto Asociado:" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedProductosDivisionLotes.productosDivisionLotesNuevo.componentesProdAsociado.codCompprod}"
                                                 styleClass="inputText chosen" style="width:340px" id="codComprodAsociado">
                                    <f:selectItems value="#{ManagedProductosDivisionLotes.componentesProdList}"/>
                                </h:selectOneMenu>
                                
                                
                            </h:panelGrid>
                         
                                
                        </h:panelGroup>
                        
                        <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(validarRegistro()==false){return false;}"
                                action="#{ManagedProductosDivisionLotes.guardarProductoDivisionLoteAction()}" 
                                oncomplete="mostrarMensajeTransaccionEvento(function(){Richfaces.hideModalPanel('PanelRegistrarProductosDivisibles')})"
                                reRender="dataProductosDivisibles" />
                        <a4j:commandButton oncomplete="Richfaces.hideModalPanel('PanelRegistrarProductosDivisibles')"
                                           styleClass="btn"  value="Cancelar"/>
                               </center>
                        </a4j:form>
                         
            </rich:modalPanel>
            <a4j:include viewId="/panelProgreso.jsp"/>
            <a4j:include viewId="/message.jsp"/>
                       
                 
        </body>
    </html>

</f:view>

