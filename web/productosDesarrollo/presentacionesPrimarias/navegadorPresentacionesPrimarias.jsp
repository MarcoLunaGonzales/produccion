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
            <script type="text/javascript" src='../../js/general.js' ></script>
            
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
        </head>
        <body>
            
            <h:form id="form1"  >                
                <div align="center">                    
                    
                    <h:outputText value="#{ManagedProductosDesarrollo.cargarPresentacionesPrimarias}"   />
                    <h3>Presentaciones Primarias</h3>
                    <rich:panel headerClass="headerClassACliente" style="width:80%">
                        <f:facet name="header">
                            <h:outputText value="DATOS DEL PRODUCTO"/>
                        </f:facet>
                    <h:panelGrid columns="6">
                        <h:outputText value="Nombre Producto" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.nombreProdSemiterminado}" styleClass="outputText2" />
                        <h:outputText value="Nombre Generico" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.nombreGenerico}" styleClass="outputText2" />
                        <h:outputText value="Nombre Comercial" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.producto.nombreProducto}" styleClass="outputText2" />
                        <h:outputText value="Color Presentacion Primaria" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.coloresPresentacion.nombreColor}" styleClass="outputText2" />
                        <h:outputText value="Sabor" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.saboresProductos.nombreSabor}" styleClass="outputText2" />
                        <h:outputText value="Area Fabricación" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                        <h:outputText value="Via Administración" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.viasAdministracionProducto.nombreViaAdministracionProducto}" styleClass="outputText2" />
                        <h:outputText value="Forma" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                        <h:outputText value="#{ManagedProductosDesarrollo.componentesProdPresPrim.forma.nombreForma}" styleClass="outputText2" />
                        
                    </h:panelGrid>
                    </rich:panel>
                    <rich:dataTable value="#{ManagedProductosDesarrollo.presentacionesPrimariasList}" var="data" id="dataPresentacionesPrimarias"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo" style="margin-top:1em;width:70%">
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                            
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="<b>Envase Primario</b>" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="<b>Cantidad</b>" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </rich:column >
                         <rich:column >
                            <f:facet name="header">
                                <h:outputText value="<b>Tipo Programa Produccion</b>" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column >
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="<b>Estado Registro</b>" escape="false"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column >
                        
                        

                    </rich:dataTable>
                    <br>
                        <a4j:commandButton value="Agregar" oncomplete="window.location.href='agregarPresentacionPrimaria.jsf?date='+(new Date()).getTime().toString();" styleClass="btn" />
                        <a4j:commandButton value="Editar" onclick="if(!editarItem('form1:dataPresentacionesPrimarias')){return false;}" action="#{ManagedProductosDesarrollo.editarPresentacionPrimaria_action}"
                        oncomplete="window.location.href='editarPresentacionPrimaria.jsf?date='+(new Date()).getTime().toString();" styleClass="btn" />
                        <a4j:commandButton value="Cancelar" oncomplete="window.location.href='../navegadorProductosDesarrollo.jsf?date='+(new Date()).getTime().toString();" styleClass="btn" />
                    <%--h:commandButton rendered="#{ManagedComponentesProducto.editarRs}" value="Editar R.S."  styleClass="btn"  action="#{ManagedComponentesProducto.editarRegistroSanitario_action}" onclick="return editarItem('form1:dataProductosDesarrollo');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.editarTipoProd}" value="Editar Produccion"  styleClass="btn" style="width='150px'" action="#{ManagedComponentesProducto.editarTipoProduccion_action}" onclick="return editarItem('form1:dataProductosDesarrollo');"/>
                    <h:commandButton rendered="#{ManagedComponentesProducto.agregarEdicionProd}" value="Eliminar"  styleClass="btn"  action="#{ManagedComponentesProducto.actionEliminar}"  onclick="return eliminarItem('form1:dataProductosDesarrollo');"/--%>
                    
                </div>
                <!--cerrando la conexion-->
               
            </h:form>
            
            
        </body>
    </html>
    
</f:view>

