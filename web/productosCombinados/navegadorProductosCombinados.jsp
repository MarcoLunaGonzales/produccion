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
            <script type="text/javascript" src='../js/general.js' ></script> 
            <script>
                function componentes(obj){
                    var codpresentacion=obj.getElementsByTagName('td')[0].lastChild.value;
                    var url='presentacionescomponentes.jsf?codpresentacion='+codpresentacion;
                    window.open(url,'DETALLE','width=700,height=400,scrollbars=1,resizable=1');
                }
            </script>
        </head>
        <body >
            <h:form id="form1"  >                
                <div align="center">
                    <h3>Productos Combinados</h3>                    
                    <h:outputText value="Estado ::" styleClass="tituloCabezera"    />
                    <h:selectOneMenu value="#{ManagedBeanProductosCombinados.presentacionesProducto.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedBeanProductosCombinados.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                        <a4j:support event="onchange"  reRender="dataPresentacionProducto"  />
                    </h:selectOneMenu>                                        
                    <rich:dataTable value="#{ManagedBeanProductosCombinados.presentacionesProductoList}" var="data" id="dataPresentacionProducto" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo"  onRowDblClick="componentes(this);"
                                  >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            <h:inputHidden value="#{data.codPresentacion}"  />
                        </rich:column>
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Producto"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Peso Neto Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.pesoNetoPresentacion}"  />
                        </rich:column>
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Carton Corrugado"  />
                            </f:facet>
                            <h:outputText value="#{data.cartonesCorrugados.nombreCarton}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Lineas MKT"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Descripción"  />
                            </f:facet>
                            <h:outputText value="#{data.obsPresentacion}"  />
                        </rich:column> 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Codigo Anterior"  />
                            </f:facet>
                            <h:outputText value="#{data.codAnterior}"  />
                        </rich:column>
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column>
                    </rich:dataTable>
                   
                    <br><br>                
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.actionSavePresentacionesProducto}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.actionEditPresentacionesProductoCombinados}" onclick="return editarItem('form1:dataPresentacionProducto');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedBeanProductosCombinados.actionDeletePresentacionesProducto}"  onclick="return eliminarItem('form1:dataPresentacionProducto');"/>
                </div>                               
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedBeanProductosCombinados.closeConnection}"  />
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

