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
            
        </head>
        <body>
            <h:form id="form1">
                
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleEP.obtenerCodigo}"   />
                    
                </div>
                <div align="center">
                    
                    Empaque Primario de: <h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombreComProd}"   />
                    <br><h:outputText value="#{ManagedFormulaMaestraDetalleEP.nombrePresentacion} x  #{ManagedFormulaMaestraDetalleEP.cantidadPresentacion}"  />
                    <%--h:outputText value="#{areasdependientes.nombreAreaEmpresa}"   /--%>
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleEP.formulaMaestraDetalleEPList}" var="data" id="dataAreasDependientes" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.nombreUnidadMedida}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Estado Material"  />
                            </f:facet>
                            <h:outputText value="#{data.materiales.estadoRegistro.nombreEstadoRegistro}" />
                        </h:column>
                    
                        
                    </rich:dataTable>
                    
                    <br>
                    
                    <h:commandButton value="Agregar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.actionAgregar}"/>
                    <h:commandButton value="Editar "    styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.actionEditar}" onclick="return editarItem('form1:dataCliente'); "/>
                    <h:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.actionEliminar}"  onclick="return eliminarItem('form1:dataCliente'); "/>
                    <h:commandButton value="Cancelar"   styleClass="btn"  action="#{ManagedFormulaMaestraDetalleEP.cancelar1}"/>
                    
                    
                </div>
                
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFormulaMaestraDetalleEP.closeConnection}"  />
                
            </h:form>
            
        </body>
    </html>
    
</f:view>

