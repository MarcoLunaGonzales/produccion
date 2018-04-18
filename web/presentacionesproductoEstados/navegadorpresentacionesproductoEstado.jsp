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
                    <br>
                    <h:outputText value="Presentaciones de Productos" styleClass="tituloCabezera1"    />
                    <h:outputText value="#{ManagedPresentacionesProducto.cargarProductosPresentaciones}"  />
                    
                    <br>  <br>  
                    <h:outputText value="Estado ::" styleClass="outputText2"    />
                    <h:selectOneMenu  onchange="submit();" value="#{ManagedPresentacionesProducto.presentacionesProducto.estadoReferencial.codEstadoRegistro}" styleClass="inputText" 
                                     valueChangeListener="#{ManagedPresentacionesProducto.changeEvent}">
                        <f:selectItems value="#{ManagedEstadosReferenciales.estadosReferenciales}"  />
                    </h:selectOneMenu>                    

                    <h:outputText value="Línea ::" styleClass="outputText2"    />
                    <h:selectOneMenu onchange="submit();" value="#{ManagedPresentacionesProducto.presentacionesProducto.lineaMKT.codLineaMKT}" styleClass="inputText"
                                     valueChangeListener="#{ManagedPresentacionesProducto.changeEventLinea}"> 
                        <f:selectItems value="#{ManagedPresentacionesProducto.lineasMKTList}"  />
                    </h:selectOneMenu>                    

                    <h:outputText value="Tipo de Mercaderia::" styleClass="outputText2"    />
                    <h:selectOneMenu onchange="submit();" value="#{ManagedPresentacionesProducto.presentacionesProducto.tiposMercaderia.codTipoMercaderia}" styleClass="inputText"
                                     valueChangeListener="#{ManagedPresentacionesProducto.changeEventTipoMer}"> 
                        <f:selectItems value="#{ManagedPresentacionesProducto.tiposMercaderia}"  />
                    </h:selectOneMenu>                    
                    <br>
                    <br>
                    <rich:dataTable value="#{ManagedPresentacionesProducto.presentacionesProductoList}" var="data" id="dataPresentacionProducto" 
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
                            
                        </rich:column>
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código"  />
                            </f:facet>
                            <h:outputText value="#{data.codPresentacion}" id="codPresentacion" />
                        </rich:column>

                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Presentación"  />
                            </f:facet>
                            <h:outputText value="#{data.nombreProductoPresentacion}"  id="nombreProductoPresentacion" />
                        </rich:column>
 
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Comercial"  />
                            </f:facet>
                            <h:outputText value="#{data.producto.nombreProducto}"  />
                        </rich:column>
                   
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo de Mercaderia"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposMercaderia.nombreTipoMercaderia}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cant. Envase Secundario"  />
                            </f:facet>
                            <h:outputText value="#{data.cantEnvaseSecundario}"  />
                        </rich:column>
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Línea"  />
                            </f:facet>
                            <h:outputText value="#{data.lineaMKT.nombreLineaMKT}"  />
                        </rich:column>                       
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Código Alfanumérico"  />
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

         
                <%--
                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedPresentacionesProducto.actionSavePresentacionesProducto}"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedPresentacionesProducto.actionEditPresentacionesProducto}" onclick="return editarItem('form1:dataPresentacionProducto');"/>
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedPresentacionesProducto.actionDeletePresentacionesProducto}"  onclick="return eliminarItem('form1:dataPresentacionProducto');"/>
                --%>
                    <br><br><br>                            
                    <h:commandButton value="Dar de Baja" styleClass="commandButton"  action="#{ManagedPresentacionesProducto.actionDarDeBaja}"/>
                    <h:commandButton value="Dar de Alta"  styleClass="commandButton"  action="#{ManagedPresentacionesProducto.actionDarDeAlta}" />                    
                    
                    
                </div>                               
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedPresentacionesProducto.closeConnection}"  />
            </h:form>
        </body>
    </html>
    
</f:view>

